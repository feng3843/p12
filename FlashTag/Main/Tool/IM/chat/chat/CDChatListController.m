//
//  CDChatListController.m
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/25/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "CDChatListController.h"
#import "CDSessionManager.h"
#import "CDChatRoomController.h"
#import "CMData.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "UIViewController+Custom.h"
#import "ContactCell.h"
#import "UIColor+Extensions.h"
#import "UIViewController+Puyun.h"

enum : NSUInteger {
    kTagNameLabel = 10000,
};
@interface CDChatListController () {
    UIImageView* emptyChatImageView;
}

@end

@implementation CDChatListController

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"消息";
        self.tabBarItem.image = [UIImage imageNamed:@"wechat"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBackButton];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionUpdated:) name:NOTIFICATION_SESSION_UPDATED object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addContactForGroup {
    CDChatRoomController *controller = [[CDChatRoomController alloc] init];
    [[CDSessionManager sharedInstance] startNewGroup:^(AVGroup *group, NSError *error) {
        controller.type = CDChatRoomTypeGroup;
        controller.group = group;
        [self.navigationController pushViewController:controller animated:YES];
    }];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row%2==1) {
        return kCalculateV(1);
    }
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int result = 0;

    if (![[CMData getUserId] isEqualToString:@""]) {
        [emptyChatImageView setHidden:YES];
        result = [[[CDSessionManager sharedInstance] chatRooms] count];
        result= result*2-1;
    }
    if (result == 0)
    {
        if (emptyChatImageView) {
            [emptyChatImageView setHidden:NO];
        }
        else
        {
            emptyChatImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_default"]];
            //[[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/2-70, 320, 20)];
            CGRect rect = emptyChatImageView.frame;
            [emptyChatImageView setFrame:CGRectMake(self.view.frame.size.width/2 - rect.size.width/2, self.view.frame.size.height/2-70-rect.size.height/2, rect.size.width, rect.size.height)];
            [self.view addSubview:emptyChatImageView];
        }
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CONTACT_CELL";
    NSInteger row = indexPath.row;
    ContactCell *cell ;
    if (row%2==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
            label.font = [UIFont systemFontOfSize:14];
            label.tag = kTagNameLabel;
            //        label.textColor = [UIColor redColor];
            //[cell.contentView addSubview:label];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSDictionary *chatRoom = [[[CDSessionManager sharedInstance] chatRooms] objectAtIndex:row/2];
        NSString *otherid = [chatRoom objectForKey:@"otherid"];
        CMContact* contact = [CMData queryContactById:otherid];
        
        contact.strCorpName = [[chatRoom objectForKey:@"maxmsg"] objectForKey:@"message"];
        if (!contact.strCorpName) {
            contact.strCorpName = @"[图片]";
        }
        contact.maxMsgTimestamp = [[[chatRoom objectForKey:@"maxmsg"] objectForKey:@"time"] doubleValue];
        cell.msgContact = contact;
        cell.delegate = self;
    }
    else
    {
        cell = [[ContactCell alloc] init];
        cell.backgroundColor = PYColor(@"e7e7e7");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *chatRoom = [[[CDSessionManager sharedInstance] chatRooms] objectAtIndex:indexPath.row/2];
    CDChatRoomType type = [[chatRoom objectForKey:@"type"] integerValue];
    NSString *otherid = [chatRoom objectForKey:@"otherid"];
    NSMutableString *nameString = [[NSMutableString alloc] init];
    if (type == CDChatRoomTypeGroup) {
        [nameString appendFormat:@"group:%@", otherid];
    } else {
        [nameString appendFormat:@"%@", otherid];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kTagNameLabel];
    label.text = nameString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = (ContactCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *chatRoom = [[[CDSessionManager sharedInstance] chatRooms] objectAtIndex:indexPath.row/2];
    CDChatRoomType type = [[chatRoom objectForKey:@"type"] integerValue];
    NSString *otherId = [chatRoom objectForKey:@"otherid"];
    CDChatRoomController *controller = [[CDChatRoomController alloc] init];
    controller.type = type;
    if (type == CDChatRoomTypeGroup) {
        AVGroup *group = [[CDSessionManager sharedInstance] joinGroup:otherId];
        controller.group = group;
        controller.otherId = otherId;
    } else {
        controller.otherId = otherId;
        controller.other = cell.contact;
    }
    [self unselectCell:nil];
    
    CMContact* contact;
    controller.otherId = otherId;
    contact = [CMData queryContactById:otherId];
    if (!contact)
    {
        contact = [[CMContact alloc] init];
    }
    contact.strContactID = otherId;
    controller.other = contact;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)unselectCell:(id)sender{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)sessionUpdated:(NSNotification *)notification {
    [self reloadData];
}

-(void)reloadData
{
    [self.tableView reloadData];
}


#pragma SWTableView delegate methods
// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

            NSDictionary *chatRoom = [[[CDSessionManager sharedInstance] chatRooms] objectAtIndex:indexPath.row/2];
            NSString *otherid = [chatRoom objectForKey:@"otherid"];
            [[CDSessionManager sharedInstance] deleteChatByPeerId:otherid];
            
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}
// utility button open/close event
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    
}

// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

// prevent cell(s) from displaying left/right utility buttons
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    return YES;
}

#pragma mark - Navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showChatRoomSegue"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        ContactCell *cell = (ContactCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        CDChatRoomController* controller = (CDChatRoomController*)segue.destinationViewController;
        NSDictionary *chatRoom = [[[CDSessionManager sharedInstance] chatRooms] objectAtIndex:indexPath.row/2];
        CDChatRoomType type = [[chatRoom objectForKey:@"type"] integerValue];
        NSString *otherid = [chatRoom objectForKey:@"otherid"];
        controller.type = type;
        if (type == CDChatRoomTypeGroup) {
            AVGroup *group = [[CDSessionManager sharedInstance] joinGroup:otherid];
            controller.group = group;
            controller.otherId = otherid;
        } else {
            controller.otherId = otherid;
            controller.other = cell.msgContact;
        }
    }
}
@end
