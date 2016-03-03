//
//  VerificationViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  输入验证码界面

#import "VerificationViewController.h"
#import "VerificationView.h"
#import "SafetyReminderViewController.h"
#import "UserProtocolViewController.h"

@interface VerificationViewController ()<UIAlertViewDelegate>

@property(nonatomic , strong)VerificationView *verificationView;
@property(nonatomic , assign)int time;

@property(nonatomic , strong)NSTimer *timer;
@property(nonatomic , strong)UIAlertView *alertView;

@end

@implementation VerificationViewController

- (void)loadView
{
    [super loadView];
    
    self.verificationView = [[VerificationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.verificationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入验证码";
    self.verificationView.remindLabel.text = [NSString stringWithFormat:@"请输入%@收到的验证码" , self.dic[self.dic[@"type"]]];
    
    self.time = 59;
    
    [self addAction];
}

- (void)addAction
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    self.verificationView.timeButton.userInteractionEnabled = NO;
    [self.verificationView.timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.verificationView.agreementButton addTarget:self action:@selector(agreementButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.verificationView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.verificationView.userProtocol addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
}

- (void)protocolAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[UserProtocolViewController new] animated:YES];
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)timeButtonAction:(UIButton *)sender
{
    self.verificationView.timeButton.userInteractionEnabled = NO;
    
    self.time = 59;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    
    [self networkingRequest];
}

- (void)agreementButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.verificationView.nextButton.userInteractionEnabled = YES;
        [self.verificationView.nextButton setBackgroundColor:PYColor(@"5db5f3")];
    }else{
        self.verificationView.nextButton.userInteractionEnabled = NO;
        [self.verificationView.nextButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void)timeAction:(NSTimer *)sender
{
    if (self.time == 0) {
        [self.verificationView.timeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        self.verificationView.timeButton.userInteractionEnabled = YES;
        [sender invalidate];
    }else{
        [self.verificationView.timeButton setTitle:[NSString stringWithFormat:@"%d秒后重发" , self.time--] forState:UIControlStateNormal];
    }
}

- (void)nextButtonAction:(UIButton *)sender
{
    if ([self.verificationView.verificationCode.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([self.verificationView.verificationCode.text isEqual:self.dic[@"verificationCode"]]) {
            SafetyReminderViewController *vc = [SafetyReminderViewController new];
            vc.dic = [NSMutableDictionary dictionaryWithDictionary:self.dic];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

//验证码
- (void)networkingRequest
{
    NSDictionary *param = @{@"destination":[self.dic objectForKey:self.dic[@"type"]],@"type":self.dic[@"type"]};
    [CMAPI postUrl:API_USER_VERIFICATIONCODE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            PYLog(@"%@" , detailDict);
            [self.dic setValue:detailDict[@"result"][@"verificationCode"] forKey:@"verificationCode"];
            
            self.alertView = [[UIAlertView alloc] initWithTitle:nil message:@"发送成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.alertView show];
            
            }else{
            
            self.verificationView.timeButton.userInteractionEnabled = YES;
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
