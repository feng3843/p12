//
//  CreateFolderViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/8.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  新建文件夹

#import "CreateFolderViewController.h"
#import "CreateFolderView.h"

@interface CreateFolderViewController ()

@property(nonatomic , strong)CreateFolderView *createFolderView;

@end

@implementation CreateFolderViewController

- (void)loadView
{
    [super loadView];
    self.createFolderView = [[CreateFolderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.createFolderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新建文件夹";
    
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

}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)nextAction:(UIButton *)sender
{
    [self networkRequest];
}


#pragma mark - network
- (void)networkRequest
{
    NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]) ,@"token":[CMData getToken],@"folderName":self.createFolderView.textField.text};
    
    [CMAPI postUrl:API_USER_CUSTROMFOLDER Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"%@" , detailDict);
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
           [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

@end
