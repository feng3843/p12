//
//  VerificationView.h
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  输入验证码界面

#import <UIKit/UIKit.h>

@interface VerificationView : UIView

@property(nonatomic , strong)UILabel *remindLabel;

@property(nonatomic , strong)UITextField *verificationCode;

@property(nonatomic , strong)UIButton *timeButton;
@property(nonatomic , strong)UIButton *agreementButton;

@property(nonatomic , strong)UIButton *userProtocol;

@property(nonatomic , strong)UIButton *nextButton;

@end
