//
//  NoteVIewController.m
//  FlashTag
//
//  Created by MingleFu on 15/10/12.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import "NoteVIewController.h"
#import "UIViewController+Puyun.h"

@implementation NoteVIewController

- (FolderOperationViewController *)folderOperationView
{
    if (_folderOperationView == nil) {
        
        FolderOperationViewController *FolderOperationView =  [[FolderOperationViewController alloc]init];
        FolderOperationView.view.frame = CGRectMake(0, 0, fDeviceWidth,fDeviceHeight);
        //   [self addChildViewController:FolderOperationView];
        FolderOperationView.headtitle = @"转移至文件夹";
        FolderOperationView.delegate = self;
        _folderOperationView = FolderOperationView;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [UIApplication sharedApplication].windows.firstObject;
        }
        [window addSubview:FolderOperationView.view];
        [window bringSubviewToFront:FolderOperationView.view];
        
        [PYNotificationCenter addObserver:self selector:@selector(AddPlace:) name:DEFAULT_NOTEPLACE_NOTIFICATION object:nil];
    }
//    _folderOperationView.headtitle = self.model.isForSale?@"转移至文件夹":@"转移至货位";
    _folderOperationView.foType = self.model.isForSale?FolderOperationTypeForSale:FolderOperationTypeNormal;
    return _folderOperationView;
}
- (void)dealloc
{
    [PYNotificationCenter removeObserver:self];
}
#pragma mark - 文件夹操作
- (void)bgBtnClick
{
    [self.folderOperationView.view removeFromSuperview];
    self.folderOperationView = nil;
    
    [PYNotificationCenter removeObserver:self name:DEFAULT_NOTEPLACE_NOTIFICATION object:nil];
}

- (void)AddPlace:(NSNotification *)notification
{
    if (self.model)
    {
        NSDictionary *param = @{@"noteIds":self.model.noteId,
                                @"toPlaceId":notification.userInfo[DEFAULT_NOTEPLACEID],
                                @"placeType":notification.userInfo[DEFAULT_NOTEPLACTYPE],
                                @"userId":@([CMData getUserIdForInt]),
                                @"token":[CMData getToken]
                                };
        [CommonInterface callingInterfacePostComment:param succeed:^{
            
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        }];
        
        [CMAPI postUrl:API_USER_TRANSFERNOTES Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
            id result = [detailDict objectForKey:@"result"] ;
            if(succeed)
            {
                [SVProgressHUD showSuccessWithStatus:@"帖子转移成功"];
                [self bgBtnClick];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            
        }];
    }
}

// 更多
- (void)moreClick
{
    
    if ([[CMData getToken] isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:DEFAULT_NO_LOGIN];
        return;
    }
    if([self.model.userId isEqualToString:[CMData getUserId]])
    {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"帖子操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"分享",@"转移", nil];
        [sheet showInView:self.view];
        //
    }
    else
    {
        NoteInfoModel* model = self.model;
        
        [self shareImage:self.view Model:model InController:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 删除
    if(buttonIndex == 0)
    {
        
    }
    //转移
    if (buttonIndex == 2) {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //发出举报请求
        [self report];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSInteger num = actionSheet.numberOfButtons;
    if (num > 2) {
        //分享
        if(buttonIndex == 1)
        {
            NoteInfoModel* model = self.model;
            
            [self shareImage:self.view Model:model InController:self];
        }
        else
            if(buttonIndex == 2)
            {
                self.folderOperationView.view.hidden = NO;
            }
    }
    else
    {
        //分享
        if(buttonIndex == 0)
        {
            NoteInfoModel* model = self.model;
            
            [self shareImage:self.view Model:model InController:self];
        }
    }
}

- (void)report
{
    
    NSDictionary *param = @{@"noteId":self.model.noteId,
                            @"userId":[CMData getUserId],
                            @"reason":@""
                            };
    [CMAPI postUrl:API_REPORT_NOTE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        // PYLog(@"xxxxxx%@",result);
        if(succeed)
        {
            [SVProgressHUD showErrorWithStatus:@"举报成功！"];
        }else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
        }
        
    }];
}

@end
