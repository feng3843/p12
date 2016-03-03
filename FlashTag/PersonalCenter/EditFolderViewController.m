//
//  EditFolderViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/8.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  编辑文件夹

#import "EditFolderViewController.h"
#import "EditFolderView.h"

@interface EditFolderViewController ()<UIAlertViewDelegate>

@property(nonatomic , strong)EditFolderView *editFolderView;

@end

@implementation EditFolderViewController

- (void)loadView
{
    [super loadView];
    self.editFolderView = [[EditFolderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.editFolderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑文件夹";
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //右侧
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    right.frame = CGRectMake(0, 0, 50, 44);
    [right setTitle:@"保存" forState:UIControlStateNormal];
    [right setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:17];
    [right addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    [self.editFolderView.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)nextAction:(UIButton *)sender
{
    [self networkRequestForChangeName];
}

- (void)deleteButtonAction:(UIButton *)sender
{
    if (!self.isDelete) {
        [self networkRequestForDelete];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件夹下有帖子时不可删除!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        [self networkRequestForDelete];
//    }
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


#pragma mark - network 
- (void)networkRequestForDelete
{
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token": [CMData getToken],@"folderIds":@(self.placeID)};
    
    [CMAPI postUrl:API_USER_DELCUSTOMFOLDERS Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"%@" , detailDict);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}


- (void)networkRequestForChangeName
{
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token": [CMData getToken],@"folderId":@(self.placeID),@"folderName":self.editFolderView.textField.text};
    
    [CMAPI postUrl:API_USER_MODIFYCUSTOMFOLDER Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
             NSLog(@"%@" , detailDict);
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

@end
