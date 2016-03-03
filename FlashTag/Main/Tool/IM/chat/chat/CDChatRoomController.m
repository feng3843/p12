//
//  CDChatRoomController.m
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/28/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "CDChatRoomController.h"
#import "CDSessionManager.h"
#import "CMData.h"
#import "UIViewController+Custom.h"
#import "CMTool.h"
#import "UIColor+Extensions.h"
#import "CDEmotionUtils.h"
#import "SVProgressHUD.h"
#import "UIViewController+Puyun.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+fixOrientation.h"

@interface CDChatRoomController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    NSMutableArray *_timestampArray;
    NSDate *_lastTime;
    NSMutableDictionary *_loadedData;
}
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSArray *emotionManagers;

//拍照
@property UIImagePickerController *uip;

@end

@implementation CDChatRoomController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if ((self = [super init])) {
        self.hidesBottomBarWhenPushed = YES;
        _loadedData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == CDChatRoomTypeGroup) {
        NSString *title = @"group";
        if (self.group.groupId) {
            title = [NSString stringWithFormat:@"group:%@", self.group.groupId];
        }
        self.title = title;
    } else {
        self.title = self.other.strName;
    }
    
    UIButton *btnRightBar=[UIButton buttonWithType:UIButtonTypeSystem];
    btnRightBar.frame=CGRectMake(0, 10, 30, 20);
    UIImage *image=[UIImage imageNamed:@"ic_chat_connect"];
    image=[image stretchableImageWithLeftCapWidth:floorf(20) topCapHeight:20];
    [btnRightBar setBackgroundImage:image forState:UIControlStateNormal];
    [btnRightBar addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    //    btnRightBar.backgroundColor=[UIColor redColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btnRightBar];

    [self createBackButton];

    _emotionManagers=[CDEmotionUtils getEmotionManagers];
    [self.emotionManagerView reloadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageUpdated:) name:NOTIFICATION_MESSAGE_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionUpdated:) name:NOTIFICATION_SESSION_UPDATED object:nil];
    
    self.delegate = self;
    self.dataSource = self;
    [self setBackgroundColor:[UIColor colorWithHexString:@"EBEBEB"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:nil];
    
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CMContact* contact = [CMData queryContactById:_otherId];
    NSDictionary *dict = [[CDSessionManager sharedInstance] getMaxMessageForPeerId:_otherId];
    NSTimeInterval readtime = [[dict objectForKey:@"time"] doubleValue];
    contact.readMsgTimestamp = readtime;
    [CMData updateReadTime:readtime ContactID:_otherId];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SESSION_UPDATED object:nil userInfo:dict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightItemAction
{
    VisitSellerViewController *vc=[VisitSellerViewController new];
    vc.userId=self.otherId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)refreshTimestampArray {
    NSDate *lastDate = nil;
    NSMutableArray *hasTimestampArray = [NSMutableArray array];
    for (NSDictionary *dict in self.messages) {
        NSDate *date = [dict objectForKey:@"time"];
        if (!lastDate) {
            lastDate = date;
            [hasTimestampArray addObject:[NSNumber numberWithBool:YES]];
        } else {
            if ([date timeIntervalSinceDate:lastDate] > 60) {
                [hasTimestampArray addObject:[NSNumber numberWithBool:YES]];
                lastDate = date;
            } else {
                [hasTimestampArray addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
    _timestampArray = hasTimestampArray;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (CDEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark XHShareMenuViewDelegate
/**
 *  点击第三方功能回调方法
 *
 *  @param shareMenuItem 被点击的第三方Model对象，可以在这里做一些特殊的定制
 *  @param index         被点击的位置
 */
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            //拍照
            [self takePhoto:UIImagePickerControllerSourceTypeCamera Item:index];
        }
            break;
        case 1:
        {
            //相册
            [self takePhoto:UIImagePickerControllerSourceTypePhotoLibrary Item:index];
        }
            break;
    }
}

/**使用图片Start
 @name Mingle
 @email fu.chenming@puyuntech.com
 */

- (void)takePhoto:(UIImagePickerControllerSourceType)type Item:(NSInteger)item{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && type == UIImagePickerControllerSourceTypeCamera)
    {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.toolbarHidden = YES;
        imagePicker.navigationBarHidden = YES;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        _uip = imagePicker;
    }
    else
    {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //       imagePicker.showsCameraControls = YES;
        imagePicker.toolbarHidden = YES;
        imagePicker.navigationBarHidden = YES;
        imagePicker.allowsEditing = YES;
        //        imagePicker.wantsFullScreenLayout = NO;
        imagePicker.delegate = self;
        _uip = imagePicker;
    }
    
    if (self.uip)
    {
        [self presentViewController:_uip animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    image = [image fixOrientation];
    
    //去除 图片压缩
    //    CGSize scaledsize = CGSizeMake(200,200);
    //    if (image.size.width > image.size.height) {
    //        scaledsize = CGSizeMake(200,200);
    //    }
    //    image = [image scaleToSize:scaledsize];
    
    [self sendAttachment:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**使用图片End
 @name Mingle
 @email fu.chenming@puyuntech.com
 */

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text {
    if (self.type == CDChatRoomTypeGroup) {
        if (!self.group.groupId) {
            return;
        }
        [[CDSessionManager sharedInstance] sendMessage:text toGroup:self.group.groupId];
    } else {
        [[CDSessionManager sharedInstance] sendMessage:text toPeerId:self.otherId];
    }
    [self refreshTimestampArray];
    [self finishSend]; 
}

- (void)cameraPressed:(id)sender
{
    
}

- (void)sendAttachment:(id)object {
    if (self.type == CDChatRoomTypeGroup) {
        if (!self.group.groupId) {
            return;
        }
        [[CDSessionManager sharedInstance] sendAttachment:object toGroup:self.group.groupId];
    } else {
        [[CDSessionManager sharedInstance] sendAttachment:object toPeerId:self.otherId];
    }
    [self refreshTimestampArray];
    [self finishSend];

}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fromid = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"fromid"];
    
    return (![fromid isEqualToString:[CMData getMemId]]) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"type"];

   if ([type isEqualToString:@"image"])
   {
        return JSBubbleMediaTypeImage;
    }
    return JSBubbleMediaTypeText;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyCustom;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleSquare;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[_timestampArray objectAtIndex:indexPath.row] boolValue];
}

- (BOOL)hasNameForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == CDChatRoomTypeGroup) {
        return YES;
    }
    return NO;
}

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"]){
//        return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"];
//    }
    return [[self.messages objectAtIndex:indexPath.row] objectForKey:@"message"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *time = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"time"];
    return time;
}

- (NSString *)nameForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"fromid"];
    return name;
}

- (UIImage *)avatarImageForIncomingMessage {
    return [CMTool setImageFileName:_other.strAvatar ImageCate:@"defaultAvatar"];
}

- (NSString *)avatarImageNameForIncomingMessage {
    return [NSString stringWithFormat:@"%@/userIcon/icon%@.jpg",[CMData getCommonImagePath],self.otherId];
}

- (SEL)avatarImageForIncomingMessageAction {
    return @selector(onInComingAvatarImageClick);
}

- (void)onInComingAvatarImageClick {
    NSLog(@"__%s__",__func__);
}

- (SEL)avatarImageForOutgoingMessageAction {
    return @selector(onOutgoingAvatarImageClick);
}

- (void)onOutgoingAvatarImageClick {
    NSLog(@"__%s__",__func__);
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [CMTool setImageFileName:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg",[CMData getCommonImagePath],[CMData getUserId]] ImageCate:@"defaultAvatar"];
}

- (NSString *)avatarImageNameForOutgoingMessage
{
    return [NSString stringWithFormat:@"%@/userIcon/icon%@.jpg",[CMData getCommonImagePath],[CMData getUserId]];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *r = @(indexPath.row);
    AVFile *file = [_loadedData objectForKey:r];
    if (file) {
        NSData *data = [file getData];
        UIImage *image = [[UIImage alloc] initWithData:data];
        return image;
    }
    else
    {
        NSString *objectId = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"object"];
        UIImage *image = [UIImage imageWithContentsOfFile:objectId];
        return image;
    }
}

- (void)messageUpdated:(NSNotification *)notification {
    NSArray *messages = nil;
    if (self.type == CDChatRoomTypeGroup) {
        NSString *groupId = self.group.groupId;
        if (!groupId) {
            return;
        }
        messages = [[CDSessionManager sharedInstance] getMessagesForGroup:groupId];
    }
    else
    {
        messages = [[CDSessionManager sharedInstance] getMessagesForPeerId:self.otherId];
    }
    self.messages = messages;
    [self refreshTimestampArray];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)sessionUpdated:(NSNotification *)notification {
    if (self.type == CDChatRoomTypeGroup) {
        NSString *title = @"group";
        if (self.group.groupId)
        {
            title = [NSString stringWithFormat:@"group:%@", self.group.groupId];
        }
        self.title = title;
    }
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

- (IBAction)callTelClick:(id)sender {
    [CMTool callPhoneNumber:self.other.strTelePhone];
}

@end