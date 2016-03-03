//
//  ResetPasswordViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/14.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  重置密码界面

#import "ResetPasswordViewController.h"
#import "ResetPasswordView.h"

#import "LoginViewController.h"

@interface ResetPasswordViewController ()

@property(nonatomic , strong)ResetPasswordView *rootView;
@end

@implementation ResetPasswordViewController

- (void)loadView
{
    [super loadView];
    
    self.rootView = [[ResetPasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"重置密码";
    
    [self.rootView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];

}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonAction:(UIButton *)sender
{
    NSInteger count = 0;
    if (![self.rootView.password.text isEqualToString:self.rootView.againPassword.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码不一致！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        if ([self isValidatePassword:self.rootView.password.text]) {
            NSLog(@"密码正确");
            count++;
            
        }else{
            NSLog(@"密码错误");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码格式" message:@"6-16位,不能有空格,不能是9位以下纯数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    }
    
    
    if (count == 1) {
        [self netWorkingRequest];
    }
}


//重置密码请求
- (void)netWorkingRequest
{
    [self.dic setValue:[self.rootView.password.text MD5EncodedString]forKey:@"newPW"];
    NSLog(@"%@" , self.dic);
    
    [CMAPI postUrl:API_USER_RESETPWD Param:self.dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            NSLog(@"%@" , detailDict);
            
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[LoginViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
            
        }else{
            
            NSLog(@"%@" , error);
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}


- (BOOL)isValidatePassword:(NSString *)password{
    
    NSString *emailRegex = @"^(?![0-9]{1,8}$)[\\S]{6,16}$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:password];
    
}



@end
