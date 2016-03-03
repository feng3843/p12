//
//  ForgetPasswordView.m
//  FlashTag
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  忘记密码界面

#import "ForgetPasswordView.h"

@implementation ForgetPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PYColor(@"f8f8f8");
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(10), fDeviceWidth, kCalculateV(44))];
    view1.backgroundColor = PYColor(@"ffffff");
    view1.layer.masksToBounds = YES;
    view1.layer.borderWidth = kCalculateH(0.5);
    view1.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self addSubview:view1];
    
    
    self.reminderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.reminderButton.frame = CGRectMake(kCalculateH(15), 0, kCalculateH(kButtonWidth), kCalculateV(44));
    [self.reminderButton setTitle:@"使用手机号注册" forState:UIControlStateNormal];
    [self.reminderButton setTitleColor:PYColor(@"5c6870") forState:UIControlStateNormal];
    self.reminderButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
    self.reminderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.reminderButton.frame) - kCalculateH(35), kCalculateV(13), kCalculateH(25), kCalculateV(20))];
    imageView.image = [UIImage imageNamed:@"ic_me_login_question"];
    [self.reminderButton addSubview:imageView];
    
    [view1 addSubview:self.reminderButton];
    
    
    self.reminder1BgView = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(10), fDeviceWidth, kCalculateV(44))];
    self.reminder1BgView.backgroundColor = PYColor(@"ffffff");
    [self addSubview:self.reminder1BgView];
    
    self.reminderButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.reminderButton1.frame = CGRectMake(kCalculateH(15), 0, kCalculateH(kButtonWidth), kCalculateV(44));
    [self.reminderButton1 setTitle:@"使用邮箱注册" forState:UIControlStateNormal];
    [self.reminderButton1 setTitleColor:PYColor(@"5c6870") forState:UIControlStateNormal];
    self.reminderButton1.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
    self.reminderButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.reminder1BgView addSubview:self.reminderButton1];
    self.reminder1BgView.hidden = YES;

        
    self.answerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), fDeviceWidth, kCalculateV(44))];
    self.answerBgView.backgroundColor = PYColor(@"ffffff");
    self.answerBgView.layer.masksToBounds = YES;
    self.answerBgView.layer.borderWidth = kCalculateH(0.5);
    self.answerBgView.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self addSubview:self.answerBgView];
    
    self.answerTextField = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(15), 0, kCalculateH(kButtonWidth), kCalculateV(44))];
    self.answerTextField.placeholder = @"输入注册手机号";
    [self.answerTextField setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.answerTextField setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    [self.answerBgView addSubview:self.answerTextField];
    

    self.completeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.completeButton.frame = CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(self.answerBgView.frame) + kCalculateV(30), kCalculateH(290), kCalculateV(39));
    [self.completeButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.completeButton.titleLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(15)];
    [self.completeButton setBackgroundColor:PYColor(@"5db5f3")];
    self.completeButton.layer.cornerRadius = 8;
    
    [self addSubview:self.completeButton];
}

@end
