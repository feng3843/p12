//
//  ModificationPhoneNumberViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  修改号页面

#import "ModificationPhoneNumberViewController.h"
#import "ModificationPhoneNumberView.h"

#import "ModificationForVerificationViewController.h"

#import "UserInfoViewController.h"

@interface ModificationPhoneNumberViewController ()<UITextFieldDelegate>

@property(nonatomic , strong)ModificationPhoneNumberView *modificationPhoneNumberView;

@end

@implementation ModificationPhoneNumberViewController

- (void)loadView
{
    [super loadView];
    self.modificationPhoneNumberView = [[ModificationPhoneNumberView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.modificationPhoneNumberView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断情况
    if (self.isPhoneUserChangePhoneNumber) {
        [self phoneUserChangePhoneNumber];
        
    }else if (self.isPhoneUserWriteEmail){
        [self phoneUserWriteEmail];
        
    }else if (self.isPhoneUserChangeEmail){
        [self phoneUserChangeEmail];
        
    }else if (self.isEmailUserWritePhoneNumber){
        [self emailUserWritePhoneNumber];
        
    }else if (self.isEmailUserChangePhoneNumber){
        [self emailUserChangePhoneNumber];
        
    }else if (self.isChangeUserName){
        
        [self changeUserName];
    }else if (self.isChangeAlipayNumber){
        [self changeAlipayNumber];
    }
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //右侧
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    right.frame = CGRectMake(0, 0, 44, 44);
    [right setTitle:@"保存" forState:UIControlStateNormal];
    [right setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:17];
    [right addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
}

#pragma mark - 手机用户修改手机号
- (void)phoneUserChangePhoneNumber
{
    self.title = @"修改手机号";
    
    self.modificationPhoneNumberView.textField.placeholder = @"手机号";
    self.modificationPhoneNumberView.textField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - 手机用户填写邮箱号
- (void)phoneUserWriteEmail
{
    self.title = @"输入邮箱号";
    
    self.modificationPhoneNumberView.textField.placeholder = @"邮箱号";
}

#pragma mark - 手机用户修改邮箱号
- (void)phoneUserChangeEmail
{
    self.title = @"修改邮箱号";
    
    self.modificationPhoneNumberView.textField.placeholder = @"邮箱号";
}

#pragma mark - 邮箱用户填写手机号
- (void)emailUserWritePhoneNumber
{
    self.title = @"输入手机号";
    
    self.modificationPhoneNumberView.textField.placeholder = @"手机号";
    self.modificationPhoneNumberView.textField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - 邮箱用户修改手机号
- (void)emailUserChangePhoneNumber
{
    self.title = @"修改手机号";
    
    self.modificationPhoneNumberView.textField.placeholder = @"手机号";
    self.modificationPhoneNumberView.textField.keyboardType = UIKeyboardTypeNumberPad;
    
}

#pragma mark - 支付宝
- (void)changeAlipayNumber
{
    self.title = @"修改支付宝帐号";
    
    self.modificationPhoneNumberView.textField.placeholder = @"支付宝号";
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 修改昵称
- (void)changeUserName
{
    self.title = @"修改昵称";
    
    self.modificationPhoneNumberView.textField.delegate = self;
    self.modificationPhoneNumberView.textField.placeholder = @"最多可输入8个汉字或16个字母哦";
    [self.modificationPhoneNumberView.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - 右侧按钮点击事件
- (void)nextAction
{
    if (self.isPhoneUserChangePhoneNumber) {
        
        if ([[HandyWay shareHandyWay] isValidatePhoneNumber:self.modificationPhoneNumberView.textField.text]) {
            
            ModificationForVerificationViewController *vc = [ModificationForVerificationViewController new];
            vc.phoneNumber = self.modificationPhoneNumberView.textField.text;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"格式错误"];
        }

        
    }else if (self.isPhoneUserWriteEmail || self.isPhoneUserChangeEmail){
        NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"mail",@"mail":self.modificationPhoneNumberView.textField.text};
        [self netWorkChangeUserInfoWithParam:param];
        
    }else if (self.isEmailUserWritePhoneNumber || self.isEmailUserChangePhoneNumber){
        
        NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"mobile",@"mobile":self.modificationPhoneNumberView.textField.text};
        [self netWorkChangeUserInfoWithParam:param];
        
    }else if (self.isChangeUserName){
        
        if (![self isValidateName:self.modificationPhoneNumberView.textField.text]) {
            
            [SVProgressHUD showErrorWithStatus:@"格式错误!"];
        }else{
        
        NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"userDisplayName",@"userDisplayName":self.modificationPhoneNumberView.textField.text};
        [self netWorkChangeUserInfoWithParam:param];
            
        }
        
    }else if (self.isChangeAlipayNumber){
        
        if ([[HandyWay shareHandyWay] isValidateEmail:self.modificationPhoneNumberView.textField.text] || [[HandyWay shareHandyWay] isValidatePhoneNumber:self.modificationPhoneNumberView.textField.text]) {
            
            NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"alipayAccount",@"alipayAccount":self.modificationPhoneNumberView.textField.text};
            [self netWorkChangeUserInfoWithParam:param];

        }else{
        
            [SVProgressHUD showErrorWithStatus:@"格式错误!"];
        }
    }
    
}


#pragma mark - network
//修改个人信息
- (void)netWorkChangeUserInfoWithParam:(NSDictionary *)dic
{
    int count = 1;
    
    if ([dic[@"type"] isEqualToString:@"mobile"]) {
        if ([[HandyWay shareHandyWay] isValidatePhoneNumber:self.modificationPhoneNumberView.textField.text]) {
            
        }else{
            count--;
            [SVProgressHUD showErrorWithStatus:@"格式错误"];
        }
    }
    
    if ([dic[@"type"] isEqualToString:@"mail"]) {
        if ([[HandyWay shareHandyWay] isValidateEmail:self.modificationPhoneNumberView.textField.text]) {
            
        }else{
            count--;
            [SVProgressHUD showErrorWithStatus:@"格式错误"];
        }
    }
    
    
    if (count == 1) {
        [CMAPI postUrl:API_USER_MODIFYInfo Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
            if (succeed) {
                if (self.isChangeAlipayNumber) {
                    
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[UserInfoViewController class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                    
                }else{
                    
                    [self.navigationController popViewControllerAnimated:NO];
                }
                
            }else{
                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
            }
        }];

    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
        if([CMTool stringContainsEmoji:string]) return NO;
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length == 1) {
        if ([toBeString isEqualToString:@" "]) {
            return NO;
        }
    }
    
    if (toBeString.length > 0) {
        if ([self isValidateName:toBeString]) {
            return YES;
        }else{
            
            return NO;
        }
    }else{
        return YES;
    }
    
}


- (void)textFieldChanged:(UITextField *)textField
{
    if (textField.text.length >0) {
        if(![self isValidateName:textField.text])
        {
            NSString *memo = [textField.text substringWithRange:NSMakeRange(0, 8)];
            textField.text=memo;
        }
    }
  
}
- (BOOL)isHanZiWithString:(NSString *)str
{
    NSString *emailRegex = @"[\u4E00-\u9FA5]";
    
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:str];
    
}

- (BOOL)isValidateName:(NSString *)str
{
    
    if (str.length > 0) {
        int count = 0;
        for (int i=0; i<str.length; i++) {
            
            NSRange range=NSMakeRange(i,1);
            
            NSString *subString=[str substringWithRange:range];
            
            if ([self isHanZiWithString:subString]) {
                
                count = count + 2;
                
            }else{
                
                count++;
                
            }
            
        }
        
        if (count > 16) {
            return NO;
        }else{
            return YES;
        }

    }else{
        
        return NO;
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
