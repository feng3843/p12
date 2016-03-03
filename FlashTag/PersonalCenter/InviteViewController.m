//
//  InviteViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  输入邀请码界面

#import "InviteViewController.h"
#import "InviteView.h"
#import "VerificationViewController.h"

@interface InviteViewController ()<UIAlertViewDelegate>

@property(nonatomic , strong)InviteView *inviteView;
@property(nonatomic , strong)UIAlertView *alertView;

@end

@implementation InviteViewController

- (void)loadView
{
    [super loadView];
    
    self.inviteView = [[InviteView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.inviteView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入邀请码";
    
    [self.inviteView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //右侧
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    right.frame = CGRectMake(0, 0, 44, 44);
    [right setTitle:@" 跳过 " forState:UIControlStateNormal];
    [right setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:17];
    [right addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonAction:(UIButton *)sender
{
    if ([self.inviteView.inviteCode.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邀请码不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        [self.dic setValue:self.inviteView.inviteCode.text forKey:@"invitationCode"];
        
        if ([self.dic[@"type"] isEqualToString:@"email"]) {

            self.alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已发送一封验证邮件到您的邮箱，你需要立刻前往确认哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"再次发送", nil];
            [self.alertView show];
            
        }else{
            
            VerificationViewController *vc = [VerificationViewController new];
            vc.dic = [NSMutableDictionary dictionaryWithDictionary:self.dic];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)skipAction
{
    if ([self.dic[@"type"] isEqualToString:@"email"]) {

        self.alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已发送一封验证邮件到您的邮箱，你需要立刻前往确认哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"再次发送", nil];
        [self.alertView show];
        
    }else{
        
        VerificationViewController *vc = [VerificationViewController new];
        vc.dic = [NSMutableDictionary dictionaryWithDictionary:self.dic];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.alertView]) {
        if (buttonIndex == 1) {
            [self networkingRequest];
        }else{
            VerificationViewController *vc = [VerificationViewController new];
            vc.dic = [NSMutableDictionary dictionaryWithDictionary:self.dic];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


//验证码
- (void)networkingRequest
{
    NSDictionary *param = @{@"destination":self.dic[@"email"],@"type":self.dic[@"type"]};
    [CMAPI postUrl:API_USER_VERIFICATIONCODE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            PYLog(@"%@" , detailDict);
            [self.dic setValue:detailDict[@"result"][@"verificationCode"] forKey:@"verificationCode"];
            
            self.alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已发送一封验证邮件到您的邮箱，你需要立刻前往确认哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"再次发送", nil];
            [self.alertView show];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];

}

@end
