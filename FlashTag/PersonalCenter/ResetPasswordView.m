//
//  ResetPasswordView.m
//  FlashTag
//
//  Created by MyOS on 15/9/14.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  重置密码界面

#import "ResetPasswordView.h"

@implementation ResetPasswordView

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
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(10), fDeviceWidth, kCalculateV(88.5))];
    view1.backgroundColor = PYColor(@"ffffff");
    view1.layer.masksToBounds = YES;
    view1.layer.borderWidth = kCalculateH(0.5);
    view1.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self addSubview:view1];

    //密码
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), 0, kCalculateH(kButtonWidth), kCalculateV(44))];
    self.password.placeholder = @"密码";
    self.password.secureTextEntry = YES;
    [self.password setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.password setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    [view1 addSubview:self.password];
    
    
    UIView *threeDivideLine = [[UIView alloc]initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(self.password.frame), kCalculateH(kButtonWidth), kCalculateV(0.5))];
    threeDivideLine.backgroundColor = PYColor(@"cccccc");
    [view1 addSubview:threeDivideLine];
    
    //再次输入密码
    self.againPassword = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(threeDivideLine.frame), kCalculateH(kButtonWidth), kCalculateV(44))];
    self.againPassword.placeholder = @"再次输入密码";
    self.againPassword.secureTextEntry = YES;
    [self.againPassword setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.againPassword setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    [view1 addSubview:self.againPassword];
    
    
    
    //下一步
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextButton.frame = CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(view1.frame) + kCalculateV(30), kCalculateH(290), kCalculateV(39));
    [self.nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(15)];
    [self.nextButton setBackgroundColor:PYColor(@"5db5f3")];
    self.nextButton.layer.cornerRadius = 8;
    
    [self addSubview:self.nextButton];

}

@end
