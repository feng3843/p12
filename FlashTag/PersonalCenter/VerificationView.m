//
//  VerificationView.m
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  输入验证码界面

#import "VerificationView.h"

@implementation VerificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PYColor(@"e7e7e7");
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(30), kCalculateH(300), kCalculateV(12))];
    self.remindLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.remindLabel.textColor = PYColor(@"999999");
    [self addSubview:self.remindLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(51), fDeviceWidth, kCalculateV(49))];
    view.backgroundColor = PYColor(@"ffffff");
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = kCalculateH(0.5);
    view.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self addSubview:view];
    
    UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), 0, kCalculateH(45), kCalculateV(49))];
    yLabel.text = @"验证码";
    yLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    yLabel.textColor = PYColor(@"000000");
    [view addSubview:yLabel];

    
    //输入验证码
    self.verificationCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yLabel.frame), 0, kCalculateH(165), kCalculateV(49))];
    self.verificationCode.placeholder = @"验证码(区分大小写)";
    [self.verificationCode setValue:[UIFont systemFontOfSize:kCalculateH(14)] forKeyPath:@"_placeholderLabel.font"];
    [self.verificationCode setValue:PYColor(@"cccccc") forKeyPath:@"_placeholderLabel.textColor"];
    [view addSubview:self.verificationCode];
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.verificationCode.frame), kCalculateV(18), kCalculateH(1), kCalculateV(13))];
    hView.backgroundColor = PYColor(@"dbdbdb");
    [view addSubview:hView];
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.timeButton.frame = CGRectMake(CGRectGetMaxX(hView.frame), 0, kCalculateH(80), kCalculateV(49));
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    [self.timeButton setTitleColor:PYColor(@"cccccc") forState:UIControlStateNormal];
    [view addSubview:self.timeButton];

    //同意协议
    self.agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.agreementButton.frame = CGRectMake(kBJ, CGRectGetMaxY(view.frame) + kCalculateV(15), kCalculateH(16), kCalculateH(16));
    [self.agreementButton setBackgroundImage:[UIImage imageNamed:@"btn_registered_normal_choose"] forState:UIControlStateNormal];
    [self.agreementButton setBackgroundImage:[UIImage imageNamed:@"btn_registered_press_choose"] forState:UIControlStateSelected];
    self.agreementButton.layer.masksToBounds = YES;
    self.agreementButton.layer.cornerRadius = 1;
    
    UILabel *protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.agreementButton.frame) + kCalculateV(6), CGRectGetMinY(self.agreementButton.frame), kCalculateH(35), CGRectGetHeight(self.agreementButton.frame))];
    protocolLabel.text = @"阅读";
    protocolLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    protocolLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.userProtocol = [UIButton buttonWithType:UIButtonTypeSystem];
    self.userProtocol.frame = CGRectMake(CGRectGetMaxX(protocolLabel.frame), CGRectGetMinY(protocolLabel.frame), kCalculateH(85), CGRectGetHeight(protocolLabel.frame));
    self.userProtocol.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.userProtocol.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [self.userProtocol setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [self.userProtocol setTitleColor:PYColor(@"498ad4") forState:UIControlStateNormal];
    
    //注册
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextButton.frame = CGRectMake(kBJ, CGRectGetMaxY(self.agreementButton.frame) + kCalculateV(20), kCalculateH(kButtonWidth), kCalculateV(39));
    [self.nextButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(15)];
    [self.nextButton setBackgroundColor:[UIColor lightGrayColor]];
    self.nextButton.layer.cornerRadius = 8;
    self.nextButton.userInteractionEnabled = NO;

    [self addSubview:self.agreementButton];
    [self addSubview:protocolLabel];
    [self addSubview:self.userProtocol];
    [self addSubview:self.nextButton];
}

@end
