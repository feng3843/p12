//
//  ModificationForVerificationViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  修改手机号输入验证码

#import "ModificationForVerificationViewController.h"
#import "ModificationForVerificationView.h"
#import "UserInfoViewController.h"

#import "ResetPasswordViewController.h"

@interface ModificationForVerificationViewController ()<UIAlertViewDelegate>

@property(nonatomic , strong)ModificationForVerificationView *modificationForVerificationView;
@property(nonatomic , assign)int time;

@property(nonatomic , strong)NSTimer *timer;
@property(nonatomic , strong)UIAlertView *alertView;


@end

@implementation ModificationForVerificationViewController

- (void)loadView
{
    [super loadView];
    self.modificationForVerificationView = [[ModificationForVerificationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.modificationForVerificationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //忘记密码界面
    if (self.verificationCodeWithForget.length > 0) {

    }else{
        //获取验证码
        [self networkingRequest];
    }
    
    self.title = @"输入验证码";
    
    self.modificationForVerificationView.label.text = [NSString stringWithFormat:@"请输入%@收到的验证码" , self.phoneNumber];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //右侧
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    right.frame = CGRectMake(0, 0, 60, 44);
    [right setTitle:@"完成" forState:UIControlStateNormal];
    [right setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:17];
    [right addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    self.time = 59;
    
    [self.modificationForVerificationView.timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.modificationForVerificationView.timeButton.userInteractionEnabled = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [self.timer fire];
    
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)nextAction
{
    if ([self.modificationForVerificationView.textField.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        //忘记密码界面
        if (self.verificationCodeWithForget.length > 0) {
            
            if ([self.modificationForVerificationView.textField.text isEqual:self.verificationCodeWithForget]) {
                //重置密码
                ResetPasswordViewController *vc = [ResetPasswordViewController new];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:self.phoneNumber forKey:@"mobile"];
                vc.dic = dic;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }else{
            if ([self.modificationForVerificationView.textField.text isEqual:self.verificationCode]) {
                [self networkingChangePhoneNumber];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }

        
    }

}

- (void)timeButtonAction:(UIButton *)sender
{
    self.modificationForVerificationView.timeButton.userInteractionEnabled = NO;
    
    self.time = 59;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [self.timer fire];

    [self networkingRequest];
}

- (void)timeAction:(NSTimer *)sender
{
    if (self.time == 0) {
        [self.modificationForVerificationView.timeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        self.modificationForVerificationView.timeButton.userInteractionEnabled = YES;
        [sender invalidate];
    }else{
        [self.modificationForVerificationView.timeButton setTitle:[NSString stringWithFormat:@"%d秒后重发" , self.time--] forState:UIControlStateNormal];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - networking
//验证码
- (void)networkingRequest
{
    NSDictionary *param;
    //忘记密码界面
    if (self.verificationCodeWithForget.length > 0) {
        param = @{@"destination":self.phoneNumber,@"type":@"email"};
    
    }else{
        param = @{@"destination":self.phoneNumber,@"type":@"mobile"};
    }
    
    [CMAPI postUrl:API_USER_VERIFICATIONCODE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            PYLog(@"%@" , detailDict);
            
            if (self.verificationCodeWithForget.length > 0) {
                self.verificationCodeWithForget = detailDict[@"result"][@"verificationCode"];
                
            }else{
                self.verificationCode = detailDict[@"result"][@"verificationCode"];
            }
            
            self.alertView = [[UIAlertView alloc] initWithTitle:nil message:@"发送成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.alertView show];
            
        }else{
            
            self.modificationForVerificationView.timeButton.userInteractionEnabled = YES;
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
    
}

//修改信息
- (void)networkingChangePhoneNumber
{
    NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"mobile",@"mobile":self.phoneNumber};
    [CMAPI postUrl:API_USER_MODIFYInfo Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"%@" , detailDict);

            [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"] animated:NO completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }]; 

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.alertView]) {
        if (buttonIndex == 0) {
            self.time = 59;
            [self.timer fire];
        }
    }
}



@end
