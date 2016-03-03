//
//  LoginView.m
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  登录注册页面

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
//    [self setSegment];
    [self setLoginView];
    [self setRigisterView];

}

//- (void)setSegment
//{
//    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"登录", @"注册"]];
//    self.segment.frame = CGRectMake(0, 0, 150, 40);
//    // 设置默认选择下标为0
//    self.segment.selectedSegmentIndex = 0;
//
//}

- (void)setLoginView
{
    self.loginView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.loginView.backgroundColor = PYColor(@"f8f8f8");
    [self addSubview:self.loginView];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(10), fDeviceWidth, kCalculateV(88.5))];
    view1.backgroundColor = PYColor(@"ffffff");
    view1.layer.masksToBounds = YES;
    view1.layer.borderWidth = kCalculateH(0.5);
    view1.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self.loginView addSubview:view1];
    
    //账户
    self.loginUserName = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(15), 0, kCalculateH(kButtonWidth), kCalculateV(44))];
    self.loginUserName.textColor = PYColor(@"222222");
    self.loginUserName.font = [UIFont systemFontOfSize:kCalculateH(13)];
//    self.loginUserName.placeholder = @"邮箱/手机号";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:@"邮箱/手机号"];
    NSDictionary *attrdict = @{
                               NSForegroundColorAttributeName : [UIColor redColor],
                               NSFontAttributeName : [UIFont systemFontOfSize:kCalculateH(13)]
                               };
    [att addAttributes:attrdict range:NSMakeRange(0, att.length)];
    self.loginUserName.attributedPlaceholder= att;
//    [self.loginUserName setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
//    [self.loginUserName setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *twoDivideLine = [[UIView alloc]initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(self.loginUserName.frame), kCalculateH(kButtonWidth), kCalculateV(0.5))];
    twoDivideLine.backgroundColor = PYColor(@"cccccc");
    
    //密码
    self.loginPassword = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(twoDivideLine.frame), kCalculateH(kButtonWidth), kCalculateV(44))];
    self.loginPassword.placeholder = @"密码";
    self.loginPassword.secureTextEntry = YES;
    [self.loginPassword setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.loginPassword setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    
    [view1 addSubview:self.loginUserName];
    [view1 addSubview:twoDivideLine];
    [view1 addSubview:self.loginPassword];
    
    
    //登录
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.frame = CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(view1.frame) + kCalculateV(20), kCalculateH(290), kCalculateV(39));
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:PYColor(@"ffffff") forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
    [self.loginButton setBackgroundColor:PYColor(@"5db5f3")];
    self.loginButton.layer.cornerRadius = 4;
    
    //忘记密码
    self.forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.forgetPasswordButton.frame = CGRectMake(kCalculateH(320 - 85), CGRectGetMaxY(self.loginButton.frame) + kCalculateV(10), kCalculateH(70), kCalculateV(30));
    [self.forgetPasswordButton setTitleColor:PYColor(@"505659") forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    
    [self.loginView addSubview:self.forgetPasswordButton];
    [self.loginView addSubview:self.loginButton];
    
    //第三方登录
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(self.loginButton.frame) + kCalculateV(120), kCalculateH(kButtonWidth), kCalculateV(0.5))];
    view.backgroundColor = PYColor(@"cccccc");
    [self.loginView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(114), CGRectGetMaxY(view.frame) - kCalculateV(15), kCalculateH(91), kCalculateV(28))];
    label.text = @"第三方登录";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kCalculateH(14)];
    label.textColor = PYColor(@"505659");
    label.backgroundColor = PYColor(@"f8f8f8");
    [self.loginView addSubview:label];
    
    CGFloat buttonSize = kCalculateH(55);
    
    self.qqButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.qqButton.frame = CGRectMake(kCalculateH(41), CGRectGetMaxY(view.frame) + kCalculateV(35), buttonSize, buttonSize);
    [self.qqButton setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    self.qqButton.layer.masksToBounds = YES;
    self.qqButton.layer.cornerRadius = buttonSize/2;
    [self.loginView addSubview:self.qqButton];
    
    UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.qqButton.frame), CGRectGetMaxY(self.qqButton.frame) + kCalculateV(12), CGRectGetWidth(self.qqButton.frame), kCalculateV(12))];
    [self.loginView addSubview:qqLabel];
    qqLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    qqLabel.textColor = PYColor(@"222222");
    qqLabel.text = @"QQ";
    qqLabel.textAlignment = NSTextAlignmentCenter;

    
    self.weiXinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weiXinButton.frame = CGRectMake(CGRectGetMaxX(self.qqButton.frame) + kCalculateH(40), CGRectGetMinY(self.qqButton.frame), buttonSize, buttonSize);
    [self.weiXinButton setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    self.weiXinButton.layer.masksToBounds = YES;
    self.weiXinButton.layer.cornerRadius = buttonSize/2;
    [self.loginView addSubview:self.weiXinButton];
    
    UILabel *weiXinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.weiXinButton.frame), CGRectGetMaxY(self.weiXinButton.frame) + kCalculateV(12), CGRectGetWidth(self.weiXinButton.frame), kCalculateV(12))];
    [self.loginView addSubview:weiXinLabel];
    weiXinLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    weiXinLabel.textColor = PYColor(@"222222");
    weiXinLabel.text = @"微信";
    weiXinLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.weiBoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weiBoButton.frame = CGRectMake(CGRectGetMaxX(self.weiXinButton.frame) + kCalculateH(40), CGRectGetMinY(self.qqButton.frame), buttonSize, buttonSize);
    [self.weiBoButton setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    self.weiBoButton.layer.masksToBounds = YES;
    self.weiBoButton.layer.cornerRadius = buttonSize/2;
    [self.loginView addSubview:self.weiBoButton];
    
    UILabel *weiBoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.weiBoButton.frame), CGRectGetMaxY(self.weiBoButton.frame) + kCalculateV(12), CGRectGetWidth(self.weiBoButton.frame), kCalculateV(12))];
    [self.loginView addSubview:weiBoLabel];
    weiBoLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    weiBoLabel.textColor = PYColor(@"222222");
    weiBoLabel.text = @"微博";
    weiBoLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)setRigisterView
{
    self.rigisterView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:self.rigisterView];
    self.rigisterView.backgroundColor = PYColor(@"f8f8f8");
    self.rigisterView.hidden = YES;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(10), fDeviceWidth, kCalculateV(133))];
    view1.backgroundColor = PYColor(@"ffffff");
    view1.layer.masksToBounds = YES;
    view1.layer.borderWidth = kCalculateH(0.5);
    view1.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self.rigisterView addSubview:view1];

    //账户
    self.rigisterUserName = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), 0, kCalculateH(kButtonWidth), kCalculateV(44))];
    self.rigisterUserName.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.rigisterUserName.textColor = PYColor(@"222222");
    self.rigisterUserName.placeholder = @"邮箱/手机号";
    [self.rigisterUserName setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.rigisterUserName setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    [view1 addSubview:self.rigisterUserName];
    
    UIView *twoDivideLine = [[UIView alloc]initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(self.rigisterUserName.frame), kCalculateH(kButtonWidth), kCalculateV(0.5))];
    twoDivideLine.backgroundColor = PYColor(@"cccccc");
    [view1 addSubview:twoDivideLine];

    //密码
    self.rigisterPassword = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(twoDivideLine.frame), kCalculateH(kButtonWidth), kCalculateV(44))];
    self.rigisterPassword.placeholder = @"密码";
    self.rigisterPassword.secureTextEntry = YES;
    [self.rigisterPassword setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.rigisterPassword setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    [view1 addSubview:self.rigisterPassword];

    UIView *threeDivideLine = [[UIView alloc]initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(self.rigisterPassword.frame), kCalculateH(kButtonWidth), kCalculateV(0.5))];
    threeDivideLine.backgroundColor = PYColor(@"cccccc");
    [view1 addSubview:threeDivideLine];

    
    //再次输入密码
    self.againPassword = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(threeDivideLine.frame), kCalculateH(kButtonWidth), kCalculateV(44))];
    self.againPassword.placeholder = @"再次输入密码";
    self.againPassword.secureTextEntry = YES;
    [self.againPassword setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.againPassword setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    [view1 addSubview:self.againPassword];


    
    //代购服务
    self.getServeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getServeButton.frame = CGRectMake(kCalculateH(15), CGRectGetMaxY(view1.frame) + kCalculateV(15), kCalculateH(16), kCalculateH(16));
    [self.getServeButton setBackgroundImage:[UIImage imageNamed:@"btn_registered_normal_choose"] forState:UIControlStateNormal];
    [self.getServeButton setBackgroundImage:[UIImage imageNamed:@"btn_registered_press_choose"] forState:UIControlStateSelected];
    self.getServeButton.layer.masksToBounds = YES;
    self.getServeButton.layer.cornerRadius = 1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.getServeButton.frame) + kCalculateH(6), CGRectGetMinY(self.getServeButton.frame), 200, CGRectGetHeight(self.getServeButton.frame))];
    label.text = @"提供海淘代购服务";
    label.font = [UIFont systemFontOfSize:kCalculateH(13)];
    label.textAlignment = NSTextAlignmentLeft;
    
    //下一步
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextButton.frame = CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(view1.frame) + kCalculateV(61), kCalculateH(290), kCalculateV(39));
    [self.nextButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:PYColor(@"ffffff") forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
    [self.nextButton setBackgroundColor:PYColor(@"5db5f3")];
    self.nextButton.layer.cornerRadius = 4;
    
    
    [self.rigisterView addSubview:self.getServeButton];
    [self.rigisterView addSubview:label];
    [self.rigisterView addSubview:self.nextButton];

    
    //支付宝账号
    
    self.AlipayBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame) + kCalculateV(45), fDeviceWidth, kCalculateV(44))];
    self.AlipayBgView.backgroundColor = PYColor(@"ffffff");
    self.AlipayBgView.layer.masksToBounds = YES;
    self.AlipayBgView.layer.borderWidth = kCalculateH(0.5);
    self.AlipayBgView.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self.rigisterView addSubview:self.AlipayBgView];
    
    self.AlipayUserName = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), 0, kCalculateH(kButtonWidth), kCalculateV(44))];
    self.AlipayUserName.textColor = PYColor(@"222222");
    self.AlipayUserName.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.AlipayUserName.placeholder = @"请输入支付宝账户名";
    [self.AlipayUserName setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.AlipayUserName setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    [self.AlipayBgView addSubview:self.AlipayUserName];
    
    self.AlipayBgView.hidden = YES;

}



@end
