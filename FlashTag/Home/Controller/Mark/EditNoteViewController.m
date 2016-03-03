//
//  EditNoteViewController.m
//  FlashTag
//
//  Created by py on 15/9/5.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  编辑帖子  

#import "EditNoteViewController.h"
#import "CameraViewController.h"
#import "DataBaseTool.h"
#import "AddTagsViewController.h"
#import "DetailedDescriptionViewController.h"
#import "MarkModel.h"
#import "CameraViewController.h"
#import "MarkFilterViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "PYHttpTool.h"
#import "FolderOperationViewController.h"
#import "HomeViewController.h"
#define btnColor PYColor(@"3385cb")

@interface EditNoteViewController ()<UIActionSheetDelegate,CameraDelagate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,FolderOperationViewControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblAddImage;
@property (strong, nonatomic) IBOutlet UIButton *noteFirstImage;
@property (strong, nonatomic) IBOutlet UIButton *noteSecondImage;
@property (strong, nonatomic) IBOutlet UIButton *noteThirdImage;
@property (strong, nonatomic) IBOutlet UIButton *AddImageBtn;
@property(nonatomic ,strong)NSMutableArray *resultArray;
- (IBAction)addNoteImage;
@property (weak, nonatomic) IBOutlet UILabel *tagsLable;
@property (weak, nonatomic) IBOutlet UILabel *noteDesc;
@property (weak, nonatomic) IBOutlet UILabel *placeLable;

@property(nonatomic ,copy) NSString *currentNoteDetail;

///** mark*/
//@property(nonatomic,copy)NSString *marks;
///** mark位置*/
//@property(nonatomic,copy)NSString *markAttributes;

@property(nonatomic,assign)NSInteger currentImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

/** 定位*/
@property(nonatomic,strong) BMKLocationService* locService;
@property(nonatomic ,strong) CLLocation* location;
@property(nonatomic, strong)BMKGeoCodeSearch* geocodesearch;

- (IBAction)editImage:(UIButton *)sender;
@property(nonatomic ,strong)NSMutableArray *noteImageInfo;

@property(nonatomic ,strong)FolderOperationViewController *folderOperationView;

@property(nonatomic ,copy)NSString *placeType;
@property(nonatomic ,copy)NSString *placeId;
@property (nonatomic ,weak) UIButton *completeBtn;
@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationLabel.textColor = PYColor(@"3385cb");
  
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0 *rateH, 24 *rateW, 24 *rateH)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_back"] forState:UIControlStateNormal];
    // backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchDown];
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [completeBtn setTitle:@"发布" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    completeBtn.backgroundColor = [UIColor redColor];
    [completeBtn setTitleColor:btnColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    self.completeBtn = completeBtn;
    
    self.tagsLable.hidden = YES;
    self.placeLable.hidden = YES;
  
    [PYNotificationCenter addObserver:self selector:@selector(AddNotoImage:) name:DEFAULT_NOTEIMAGE_NOTIFICATION object:nil];
    [PYNotificationCenter addObserver:self selector:@selector(AddTags:) name:DEFAULT_ADDTAGS_NOTIFICATION object:nil];
    [PYNotificationCenter addObserver:self selector:@selector(AddNOteDesc:) name:DEFAULT_NOTEDESC_NOTIFICATION object:nil];
    [PYNotificationCenter addObserver:self selector:@selector(AddPlace:) name:DEFAULT_NOTEPLACE_NOTIFICATION object:nil];
    
    MarkModel *model = [[MarkModel alloc]init];
    model.imageName = self.firstNoteImageInfo.imageName;
    model.mark = self.firstNoteImageInfo.mark;
    model.markAttributes = self.firstNoteImageInfo.markAttributes;
    [self.noteImageInfo addObject:model];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    [self.noteFirstImage setBackgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]] forState:UIControlStateNormal];
    
    self.noteFirstImage.layer.cornerRadius = 4 *rateH;
    self.noteFirstImage.clipsToBounds = YES;
    self.noteSecondImage.layer.cornerRadius = 4 *rateH;
    self.noteSecondImage.clipsToBounds = YES;
    self.noteThirdImage.layer.cornerRadius = 4 *rateH;
    self.noteThirdImage.clipsToBounds = YES;
    self.AddImageBtn.layer.cornerRadius = 4 *rateH;
    self.AddImageBtn.clipsToBounds = YES;
    
    self.AddImageBtn.enabled = YES;
    self.noteFirstImage.enabled = YES;
    self.noteSecondImage.enabled = NO;
    self.noteThirdImage.enabled = NO;
    /** 定位*/
   
    [self BMKlocation];
}

- (void)dealloc
{
    
    [PYNotificationCenter removeObserver:self];

}

- (FolderOperationViewController *)folderOperationView
{
    if (_folderOperationView == nil) {
    
        FolderOperationViewController *FolderOperationView =  [[FolderOperationViewController alloc]init];
        FolderOperationView.view.frame = CGRectMake(0, 0, fDeviceWidth,fDeviceHeight);
        FolderOperationView.headtitle = @"放置到文件夹";
        FolderOperationView.delegate = self;
        FolderOperationView.foType = FolderOperationTypeAll;
        _folderOperationView = FolderOperationView;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [UIApplication sharedApplication].windows.firstObject;
        }
        [window addSubview:FolderOperationView.view];
        [window bringSubviewToFront:FolderOperationView.view];
    }
    return _folderOperationView;
}
- (NSMutableArray *)resultArray
{
    if (_resultArray == nil) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (IBAction)editImage:(UIButton *)sender
{
    self.currentImage = sender.tag;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles:@"编辑图片", nil];
    [sheet showInView:self.view];}

#pragma mark - 删除照片

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)
    {
        if (self.currentImage==4) {
            
            MarkModel *model = [self.noteImageInfo objectAtIndex:self.noteImageInfo.count - 1];
            [self.noteImageInfo removeObjectAtIndex:(self.noteImageInfo.count - 1)];
           NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath = [path stringByAppendingPathComponent:model.imageName];
            BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
            if (bRet) {
                //
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
            }
        }else{
             MarkModel *model = [self.noteImageInfo objectAtIndex:self.noteImageInfo.count - self.currentImage];
            [self.noteImageInfo removeObjectAtIndex:(self.noteImageInfo.count - self.currentImage)];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath = [path stringByAppendingPathComponent:model.imageName];
            BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
            if (bRet) {
                //
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
            }
        }
        
       
        switch (self.currentImage) {


            case 4:
                if (self.noteImageInfo.count>1) {
                    MarkModel *model = [self.noteImageInfo objectAtIndex:self.noteImageInfo.count - 1];
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
                    [self updateImageAndTarget4Btn:_AddImageBtn backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]] removeTarget:NULL addTarget:NULL];
                    if (self.noteImageInfo.count==2) {
                        [self updateImageAndTarget4Btn:_noteSecondImage backgroundImage:[UIImage imageNamed:@"ic_add_newpicture"] removeTarget:@selector(editImage:) addTarget:@selector(addNoteImage)];
                        [self updateImageAndTarget4Btn:_noteThirdImage backgroundImage:[[UIImage alloc] init] removeTarget:@selector(addNoteImage) addTarget:NULL];
                        self.AddImageBtn.enabled = YES;
                        self.noteSecondImage.enabled = YES;
                        self.noteThirdImage.enabled = NO;
                    }else{
                        model=[self.noteImageInfo objectAtIndex:2];
                        [self updateImageAndTarget4Btn:_noteSecondImage backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]] removeTarget:NULL addTarget:NULL];
                        [self updateImageAndTarget4Btn:_noteThirdImage backgroundImage:[UIImage imageNamed:@"ic_add_newpicture"] removeTarget:@selector(editImage:) addTarget:@selector(addNoteImage)];
                        self.AddImageBtn.enabled = YES;
                        self.noteSecondImage.enabled = YES;
                        self.noteThirdImage.enabled = YES;
                    }
                }else{
                    [self updateImageAndTarget4Btn:self.AddImageBtn backgroundImage:[UIImage imageNamed:@"ic_add_newpicture"] removeTarget:@selector(editImage:) addTarget:@selector(addNoteImage)];
                    [self updateImageAndTarget4Btn:self.noteSecondImage backgroundImage:[[UIImage alloc] init] removeTarget:@selector(addNoteImage) addTarget:NULL];
                    self.AddImageBtn.enabled = YES;
                    self.noteSecondImage.enabled = NO;
                    self.noteThirdImage.enabled = NO;
                }
                break;
            case 3:
                [self updateImageAndTarget4Btn:_noteThirdImage backgroundImage:[UIImage imageNamed:@"ic_add_newpicture"] removeTarget:@selector(editImage:) addTarget:@selector(addNoteImage)];
                self.AddImageBtn.enabled = YES;
                self.noteSecondImage.enabled = YES;
                self.noteThirdImage.enabled = YES;
                break;
            case 2:
                if (self.noteImageInfo.count <3) {
                    [self updateImageAndTarget4Btn:_noteSecondImage backgroundImage:[UIImage imageNamed:@"ic_add_newpicture"] removeTarget:@selector(editImage:) addTarget:@selector(addNoteImage)];
                    [self updateImageAndTarget4Btn:_noteThirdImage backgroundImage:[[UIImage alloc] init] removeTarget:@selector(addNoteImage) addTarget:NULL];
                    self.AddImageBtn.enabled = YES;
                    self.noteSecondImage.enabled = YES;
                    self.noteThirdImage.enabled = NO;
                }else
                {
                    MarkModel *model = [self.noteImageInfo objectAtIndex:(self.noteImageInfo.count - self.currentImage)];
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
                    [self updateImageAndTarget4Btn:_noteSecondImage backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]]  removeTarget:@selector(editImage:) addTarget:@selector(editImage:)];
                    [self updateImageAndTarget4Btn:_noteThirdImage backgroundImage:[UIImage imageNamed:@"ic_add_newpicture"] removeTarget:@selector(editImage:) addTarget:@selector(addNoteImage)];
                    self.AddImageBtn.enabled = YES;
                    self.noteSecondImage.enabled = YES;
                    self.noteThirdImage.enabled = YES;
                }
                break;
                
            default:
                break;
        }
    }
    else
    if (buttonIndex == 1)
    {
//        MarkModel *model = self.noteImageInfo[self.currentImage - 1];
        MarkModel *model = nil;
        if (self.currentImage==4) {
            model = self.noteImageInfo[self.noteImageInfo.count - 1];
        }else{
            model = self.noteImageInfo[self.noteImageInfo.count - self.currentImage];
        }
        
        MarkFilterViewController *markVC = [[MarkFilterViewController alloc]init];
        UIButton *btn = (UIButton *)[self.tableView viewWithTag:self.currentImage];
        markVC.image =btn.currentBackgroundImage;
        markVC.isFirst = NO;
        markVC.model = model;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:markVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}

- (NSMutableArray *)noteImageInfo
{
    if (_noteImageInfo == nil) {
        _noteImageInfo = [NSMutableArray array];
    }
    return _noteImageInfo;
}

- (void)setFirstNoteImageInfo:(MarkModel *)firstNoteImageInfo
{
    _firstNoteImageInfo = firstNoteImageInfo;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNoteImage {
    
    if (self.noteImageInfo.count ==4) {
        [self editImage:self.AddImageBtn];
        
    }else
    {
        CameraViewController *vc = [[CameraViewController alloc]init];
        vc.isFrist = NO;
        vc.delagate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        
        [self presentViewController:nav
                           animated:YES completion:nil];
    }
   
    
}

-(void)afterCut:(UIImage *)image ByViewController:(UIViewController *)viewC
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            DetailedDescriptionViewController *vc = [[DetailedDescriptionViewController alloc]init];
            vc.noteDesc = self.noteDesc.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            
            if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败,您可以在设置->隐私->定位服务中开启定位。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [view show];
               
            }else
            {
                [self BMKlocation];
            }
     
        }
 
    }
    if(indexPath.section ==1)
    {
        
        AddTagsViewController *vc = [[AddTagsViewController alloc]init];
        if (!self.tagsLable.hidden) {
               vc.tags = self.tagsLable.text;
        }else
        {
              vc.tags = nil;
        }
     
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    
    if (indexPath.section == 3) {
        
       self.folderOperationView.view.hidden = NO;
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.005;
    }
    return 10 *rateH;
}
#pragma mark - 返回按钮
- (void)backToHome
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"" message:@"您确定取消您辛苦添加的帖子吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [view show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
   
        for (MarkModel *model in self.noteImageInfo) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath = [path stringByAppendingPathComponent:model.imageName];
            BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
            if (bRet) {
                //
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
            }
        }
          [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - 点击发布按钮
- (void)completeBtnClick
{
    
    if ([self.currentNoteDetail isEqualToString:@""] ||self.currentNoteDetail == nil) {
        [SVProgressHUD showInfoWithStatus:@"请分享您的使用心得吧!"];
        return;
    }
    
    NSMutableArray *loadFormData = [NSMutableArray array];
    NSString *mark = @"";
    NSString *markAttributes =@"";
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    // 将mark和mark位置组合起来
    for (int i = 0; i < self.noteImageInfo.count; i ++) {
        MarkModel *model = self.noteImageInfo[i];
        
        PYFormData* formData = [[PYFormData alloc] init];
        formData.name =[NSString stringWithFormat:@"noteImage%d",i];
        formData.filename = [NSString stringWithFormat:@"noteImage%d",i];
        formData.mimeType = @"image/jpg";
        formData.data = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]], 1);
        [loadFormData addObject:formData];
        if(![model.mark isEqualToString:@""])
        {
            if([mark isEqualToString:@""])
            {
                mark = [NSString stringWithFormat:@"%d:%@",(i+1) ,model.mark];
                markAttributes =[NSString stringWithFormat:@"%d:%@",(i+1) ,model.markAttributes];
            }else
            {
                mark = [NSString stringWithFormat:@"%@,%d:%@",mark,(i+1) ,model.mark];
                markAttributes =[NSString stringWithFormat:@"%@,%d:%@",markAttributes,(i+1) ,model.markAttributes];
            }
        }
        
    }
    
    NSString *tag = self.tagsLable.text;
    if ([tag isEqualToString:@"tag"]) {
        [SVProgressHUD showInfoWithStatus:@"您还没有添加标签"];
        return;
    }
    
    NSString *location = self.locationLabel.text;
    
    if ([self.locationLabel.text isEqualToString:@"正在定位..."]) {
        location =@"";
    }
    if ([self.placeId isEqualToString:@""] ||self.placeId ==nil) {
        self.placeType = @"sys";
        self.placeId = @"0";
    }
//
//    NSString *noteDetail = self.noteDesc.text;
    
    self.completeBtn.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [CMData getUserId];
    params[@"token"] = [CMData getToken];
    params[@"marks"]=mark;
    params[@"markAttributes"] = markAttributes;
    params[@"noteLocation"]= location;
    params[@"tags"] = tag;
    params[@"noteDesc"] = self.currentNoteDetail;
    params[@"placeId"] = self.placeId;
    params[@"placeType"]=self.placeType;
 
    //    PYLog(@"%@",[CMData getCommonImagePath]) ;
    //    PYLog(@"%@",[CMData getUserId]);
  
//     if (![self.marks isEqualToString:@""]) {
//        params[@"marks"] = self.marks;
//    }
//    if (![self.markAttributes isEqualToString:@""]) {
//        params[@"markAttributes"] = self.marks;
//    }
    
    [CMAPI postWithURLWithNotWEB:API_POST_NOTE params:params formDataArray:loadFormData Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            for (MarkModel *model in self.noteImageInfo) {
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                NSString *MapLayerDataPath = [path stringByAppendingPathComponent:model.imageName];
                BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
                if (bRet) {
                    //
                    NSError *err;
                    [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
                }
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            
        }
        
    }];
    
    

}

#pragma mark - 通知事件
- (void)AddTags:(NSNotification *)notification
{
     self.tagsLable.hidden = NO;
//    PYLog(@"%@",notification.userInfo[DEFAULT_ADD_TAGS]);
    self.tagsLable.text = notification.userInfo[DEFAULT_ADD_TAGS];
}

- (void)AddNOteDesc:(NSNotification *)notification
{
    self.noteDesc.text = notification.userInfo[DEFAULT_ADDNOTEDESC_TAGS];
    self.currentNoteDetail = notification.userInfo[DEFAULT_ADDNOTEDESC_TAGS];
}

- (void)AddNotoImage:(NSNotification *)notification
{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];

    if ([notification.userInfo[DEFAULT_NOTEIMAGETYPE] isEqualToString:DEFAULT_NOTEIMAGETYPEADD]) {
        MarkModel *model = [[MarkModel alloc]init];
        model.imageName = notification.userInfo[DEFAULT_NOTEIMAGENAME];
        model.mark = notification.userInfo[DEFAULT_NOTEIMAGEMARK];
        model.markAttributes = notification.userInfo[DEFAULT_NOTEIMAGEATTRIBUTES];
        [self.noteImageInfo addObject:model];
//        UIButton *btn = (UIButton *)[self.tableView viewWithTag:self.noteImageInfo.count];
//         [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]] forState:UIControlStateNormal];
        MarkModel *model2;
        MarkModel *model3;
        switch (self.noteImageInfo.count) {
            case 2:
                [self updateImageAndTarget4Btn:self.AddImageBtn backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]] removeTarget:@selector(addNoteImage) addTarget:@selector(editImage:)];
                [self updateImageAndTarget4Btn:self.noteSecondImage backgroundImage:[UIImage imageNamed:@"ic_add_newpicture"] removeTarget:@selector(editImage:) addTarget:@selector(addNoteImage)];
                self.AddImageBtn.enabled = YES;
                self.noteSecondImage.enabled = YES;
                self.noteThirdImage.enabled = NO;
                break;
            case 3:
                model2 = [self.noteImageInfo objectAtIndex:self.noteImageInfo.count - 2];
                [self updateImageAndTarget4Btn:self.AddImageBtn backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]] removeTarget:@selector(addNoteImage) addTarget:@selector(editImage:)];
                [self updateImageAndTarget4Btn:self.noteSecondImage backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model2.imageName]] removeTarget:@selector(addNoteImage) addTarget:@selector(editImage:)];
                [self updateImageAndTarget4Btn:_noteThirdImage backgroundImage:[UIImage imageNamed:@"ic_add_newpicture"] removeTarget:@selector(editImage:) addTarget:@selector(addNoteImage)];
                self.AddImageBtn.enabled = YES;
                self.noteSecondImage.enabled = YES;
                self.noteThirdImage.enabled = YES;
                break;
            case 4:
                model2 = [self.noteImageInfo objectAtIndex:self.noteImageInfo.count - 2];
                model3 = [self.noteImageInfo objectAtIndex:self.noteImageInfo.count - 3];
                [self updateImageAndTarget4Btn:self.noteSecondImage backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model2.imageName]] removeTarget:@selector(editImage:) addTarget:@selector(editImage:)];
                [self updateImageAndTarget4Btn:self.noteThirdImage backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model3.imageName]] removeTarget:@selector(addNoteImage) addTarget:@selector(editImage:)];
                [self updateImageAndTarget4Btn:self.AddImageBtn backgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]] removeTarget:@selector(editImage:) addTarget:@selector(editImage:)];
                self.AddImageBtn.enabled = YES;
                self.noteSecondImage.enabled = YES;
                self.noteThirdImage.enabled = YES;
                break;
                
            default:
                break;
        }
    }
    else
    {
        MarkModel *model;
        if (self.currentImage==4) {
            model =self.noteImageInfo.lastObject;
        }else{
            model = self.noteImageInfo[self.noteImageInfo.count - self.currentImage];
        }
        model.imageName = notification.userInfo[DEFAULT_NOTEIMAGENAME];
        model.mark = notification.userInfo[DEFAULT_NOTEIMAGEMARK];
        model.markAttributes = notification.userInfo[DEFAULT_NOTEIMAGEATTRIBUTES];
        UIButton *btn = (UIButton *)[self.tableView viewWithTag:self.currentImage];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:model.imageName]] forState:UIControlStateNormal];

    }
 }

-(void)updateImageAndTarget4Btn:(UIButton*)pBtn backgroundImage:(UIImage*)pBackgroundImage removeTarget:(nullable SEL)pRemoveTarget addTarget:(nullable SEL)pAddTarget{
    if(pBackgroundImage!=nil)[pBtn setBackgroundImage:pBackgroundImage forState:UIControlStateNormal];
    if(pRemoveTarget!=NULL)[pBtn removeTarget:self action:pRemoveTarget forControlEvents:UIControlEventTouchUpInside];
    if(pAddTarget!=NULL)[pBtn addTarget:self action:pAddTarget forControlEvents:UIControlEventTouchUpInside];
}
- (void)AddPlace:(NSNotification *)notification
{
    [self bgBtnClick];
    self.placeLable.hidden = NO;
    self.placeLable.text = notification.userInfo[DEFAULT_NOTEPLACENAME];
    self.placeId = notification.userInfo[DEFAULT_NOTEPLACEID];
    self.placeType = notification.userInfo[DEFAULT_NOTEPLACTYPE];
}


#pragma mark - 定位
- (void)BMKlocation
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
//        [locationManager requestWhenInUseAuthorization];
    }
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    [BMKLocationService setLocationDistanceFilter:1.0f];
    _locService=[[BMKLocationService alloc]init];
    _locService.delegate=self;
    [_locService startUserLocationService];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.location=userLocation.location;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = self.location.coordinate;
    _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate=self;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
//      NSLog(@"&&& 反geo检索发送成功");
    }
    else
    {
//      NSLog(@"&&& 反geo检索发送失败");
    }
}

-(void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"&&& 反geo检索发送成功");
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
//       __block NSString *item=[NSString stringWithFormat:@"经度：%f\n\r纬度：%f",self.location.coordinate.longitude,self.location.coordinate.latitude];
//       item=[NSString stringWithFormat:@"%@\n\r地址：%@",item,result.address];
//       item=[NSString stringWithFormat:@"%@\n\r街道：%@",item,result.addressDetail.streetName];
//       item=[NSString stringWithFormat:@"%@\n\r区域：%@",item,result.addressDetail.district];
//       item=[NSString stringWithFormat:@"%@\n\r城市：%@",item,result.addressDetail.city];
//       item=[NSString stringWithFormat:@"%@\n\r省：%@",item,result.addressDetail.province];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.location
                       completionHandler:^(NSArray *placemarks, NSError *error){
                           NSString *item = nil;
                           for (CLPlacemark *place in placemarks) {
                               item=[NSString stringWithFormat:@"%@,",place.country];
                             //  item=[NSString stringWithFormat:@"%@\n\r国家代码：%@",item,place.ISOcountryCode];
                           }
                          item=[NSString stringWithFormat:@"%@%@,",item,result.addressDetail.province];
                         item=[NSString stringWithFormat:@"%@%@",item,result.addressDetail.city];
                           self.locationLabel.text = item;
                       }];
        
       
    }
    else {
//        NSLog(@"抱歉，未找到结果");
        [SVProgressHUD showErrorWithStatus:@"抱歉，未找到结果"];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _geocodesearch.delegate=nil;
}

#pragma mark - 文件夹操作
- (void)bgBtnClick
{
    [self.folderOperationView.view removeFromSuperview];
    self.folderOperationView = nil;
}

-(void)selectFolder:(FolderOperateModel*)model
{
    self.placeId = model.placeId;
    self.placeType = model.placeType;
}

@end
