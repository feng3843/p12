//
//  ModificationForVerificationViewController.h
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  修改手机号输入验证码

#import <UIKit/UIKit.h>

@interface ModificationForVerificationViewController : UIViewController

@property(nonatomic , copy)NSString *phoneNumber;
@property(nonatomic , copy)NSString *verificationCode;

//忘记密码输验证码用到
@property(nonatomic , copy)NSString *verificationCodeWithForget;

@end
