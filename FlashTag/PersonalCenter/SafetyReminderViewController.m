//
//  SafetyReminderViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  安全提示页面

#import "SafetyReminderViewController.h"
#import "SafetyReminderView.h"
#import "ResetPasswordViewController.h"

@interface SafetyReminderViewController ()<UITextFieldDelegate>

@property(nonatomic , strong)SafetyReminderView *safetyReminderView;
@property(nonatomic , assign)BOOL isShow;
@property(nonatomic , assign)BOOL isOther;

@end

@implementation SafetyReminderViewController

- (void)loadView
{
    [super loadView];
    self.safetyReminderView = [[SafetyReminderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.safetyReminderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"安全提示";
    
    [self.safetyReminderView.reminderButton addTarget:self action:@selector(reminderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.safetyReminderView.reminderButton1 addTarget:self action:@selector(reminderButton1Action:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.safetyReminderView.completeButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.safetyReminderView.answerTextField.delegate = self;
    
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reminderButtonAction
{
    CGRect reminder1Rect = self.safetyReminderView.reminder1BgView.frame;
    CGFloat h = reminder1Rect.origin.y;
    
    
    CGRect textfieldRect = self.safetyReminderView.answerBgView.frame;
    CGFloat h1 = textfieldRect.origin.y;
    
    
    CGRect completeRect = self.safetyReminderView.completeButton.frame;
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
        
        self.safetyReminderView.reminder1BgView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.safetyReminderView.reminder1BgView.frame = reminder1Rect;
        self.safetyReminderView.answerBgView.frame = textfieldRect;
        self.safetyReminderView.completeButton.frame = completeRect;
    }completion:^(BOOL finished) {
        if (self.isShow) {
        
        }else{
            self.safetyReminderView.reminder1BgView.hidden = YES;
        }
    }];
}

- (void)reminderButton1Action:(UIButton *)sender
{
    [self.safetyReminderView.answerTextField resignFirstResponder];
    
    if (self.isOther) {
        self.isOther = NO;
        [self.safetyReminderView.reminderButton setTitle:@"您的身份证后四位是？" forState:UIControlStateNormal];
        [self.safetyReminderView.reminderButton1 setTitle:@"您的出生地在哪？" forState:UIControlStateNormal];
        
    }else{
        self.isOther = YES;
        [self.safetyReminderView.reminderButton setTitle:@"您的出生地在哪？" forState:UIControlStateNormal];
        [self.safetyReminderView.reminderButton1 setTitle:@"您的身份证后四位是？" forState:UIControlStateNormal];

    }
    
    
    [self reminderButtonAction];
}


- (void)completeButtonAction:(UIButton *)sender
{
    if (self.isForgetPassword) {
        [self goToResetPassword];
    }else{
        
        int a = 1;
        if ([self.safetyReminderView.reminderButton.titleLabel.text isEqualToString:@"您的身份证后四位是？"]) {
            
            if ([[HandyWay shareHandyWay] isValidateID:self.safetyReminderView.answerTextField.text]) {
                
            }else{
                a--;
                [SVProgressHUD showErrorWithStatus:@"答案格式不对!"];
            }
        }
        
        if (a == 1) {
            [self networkingRequest];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


#pragma mark - network
//注册
- (void)networkingRequest
{
    int a;
    if ([self.safetyReminderView.reminderButton.titleLabel.text isEqualToString:@"您的身份证后四位是？"]) {
        a = 1;
    }else{
        a = 2;
    }
    
    [self.dic setValue:@(a) forKey:@"questionNo"];
    [self.dic setValue:self.safetyReminderView.answerTextField.text forKey:@"answer"];
    [self.dic setValue:@"yes" forKey:@"agreement"];
    
    //mail问题
    if ([self.dic[@"email"] isKindOfClass:[NSNull class]]) {
        
    }else{
        [self.dic setValue:[self.dic valueForKey:@"email"] forKey:@"mail"];
    }
    
    NSLog(@"%@" , self.dic);
    [CMAPI postUrl:API_USER_REGISTER Param:self.dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            PYLog(@"%@" , detailDict);
            
            //保存用户信息
            [[HandyWay shareHandyWay] setUserInfoWithDic:detailDict];
            
            [CMData initDatabase];
            
            [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"] animated:NO completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

//重置密码
- (void)goToResetPassword
{
    int a;
    if ([self.safetyReminderView.reminderButton.titleLabel.text isEqualToString:@"您的身份证后四位是？"]) {
        a = 1;
    }else{
        a = 2;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(a) forKey:@"questionNo"];
    [dic setValue:self.safetyReminderView.answerTextField.text forKey:@"answer"];
    [dic setValue:self.userName forKey:@"mobile"];
    
    ResetPasswordViewController *vc = [ResetPasswordViewController new];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.isOther) {
        return YES;
    }
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 4) {
        return NO;
    }
    return YES;
}


@end
