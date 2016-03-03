//
//  ForgetPasswordViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  忘记密码界面

#import "ForgetPasswordViewController.h"
#import "ForgetPasswordView.h"
#import "SafetyReminderViewController.h"

#import "ModificationForVerificationViewController.h"

@interface ForgetPasswordViewController ()

@property(nonatomic , strong)ForgetPasswordView *forgetPasswordView;
@property(nonatomic , assign)BOOL isShow;
@property(nonatomic , assign)BOOL isEmail;

//邮箱用户验证码
@property(nonatomic , strong)UIAlertView *alertView;
@property(nonatomic , copy)NSString *verificationCode;

@end

@implementation ForgetPasswordViewController

- (void)loadView
{
    [super loadView];
    self.forgetPasswordView = [[ForgetPasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.forgetPasswordView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    
    [self.forgetPasswordView.reminderButton addTarget:self action:@selector(reminderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPasswordView.reminderButton1 addTarget:self action:@selector(reminderButton1Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forgetPasswordView.completeButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)reminderButtonAction
{
    CGRect reminder1Rect = self.forgetPasswordView.reminder1BgView.frame;
    CGFloat h = reminder1Rect.origin.y;
    
    CGRect textfieldRect = self.forgetPasswordView.answerBgView.frame;
    CGFloat h1 = textfieldRect.origin.y;
    
    
    CGRect completeRect = self.forgetPasswordView.completeButton.frame;
    CGFloat h3 = completeRect.origin.y;

    
    CGFloat change = kCalculateV(44);
    
    if (self.isShow) {
        self.isShow = NO;
        
        reminder1Rect.origin.y = h - change;
        textfieldRect.origin.y = h1 - change;
        completeRect.origin.y = h3 - change;
        
    }else{
        self.isShow = YES;
        
        reminder1Rect.origin.y = h + change;
        textfieldRect.origin.y = h1 + change;
        completeRect.origin.y = h3 + change;
       
        self.forgetPasswordView.reminder1BgView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.forgetPasswordView.reminder1BgView.frame = reminder1Rect;
        self.forgetPasswordView.answerBgView.frame = textfieldRect;
        self.forgetPasswordView.completeButton.frame = completeRect;
    }completion:^(BOOL finished) {
        if (self.isShow) {

        }else{
            self.forgetPasswordView.reminder1BgView.hidden = YES;
        }
    }];

}

- (void)reminderButton1Action:(UIButton *)sender
{
    if (self.isEmail) {
        self.isEmail = NO;
        [self.forgetPasswordView.reminderButton1 setTitle:@"使用邮箱注册" forState:UIControlStateNormal];
        [self.forgetPasswordView.reminderButton setTitle:@"使用手机号注册" forState:UIControlStateNormal];
        
        self.forgetPasswordView.answerTextField.placeholder = @"输入注册手机号";
    }else{
        self.isEmail = YES;
        [self.forgetPasswordView.reminderButton setTitle:@"使用邮箱注册" forState:UIControlStateNormal];
        [self.forgetPasswordView.reminderButton1 setTitle:@"使用手机号注册" forState:UIControlStateNormal];
        
        self.forgetPasswordView.answerTextField.placeholder = @"输入注册邮箱";
    }
    
    [self reminderButtonAction];
}

//下一步按钮
- (void)completeButtonAction:(UIButton *)sender
{
    if (self.isEmail) {
        
        if ([[HandyWay shareHandyWay] isValidateEmail:self.forgetPasswordView.answerTextField.text]) {
            [self networkingRequest];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else{
        
        if ([[HandyWay shareHandyWay] isValidatePhoneNumber:self.forgetPasswordView.answerTextField.text]) {
            SafetyReminderViewController *vc = [[SafetyReminderViewController alloc] init];
            vc.isForgetPassword = YES;
            vc.userName = self.forgetPasswordView.answerTextField.text;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}

//alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.alertView]) {
        if (buttonIndex == 1) {
            [self networkingRequest];
        }else{
            ModificationForVerificationViewController *vc = [ModificationForVerificationViewController new];
            vc.verificationCodeWithForget = self.verificationCode;
            vc.phoneNumber = self.forgetPasswordView.answerTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

//验证码
- (void)networkingRequest
{
    NSDictionary *param = @{@"destination":self.forgetPasswordView.answerTextField.text,@"type":@"email"};
    [CMAPI postUrl:API_USER_VERIFICATIONCODE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            PYLog(@"%@" , detailDict);
            
            self.alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已发送一封验证邮件到您的邮箱，你需要立刻前往确认哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"再次发送", nil];
            [self.alertView show];
            
            self.verificationCode = detailDict[@"result"][@"verificationCode"];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
    
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


@end
