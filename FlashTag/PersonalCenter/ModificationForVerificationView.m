//
//  ModificationForVerificationView.m
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  修改手机号输入验证码

#import "ModificationForVerificationView.h"

@implementation ModificationForVerificationView

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
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(30), kCalculateH(300), kCalculateV(12))];
    self.label.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.label.textColor = PYColor(@"999999");
    [self addSubview:self.label];
    
    
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
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yLabel.frame), 0, kCalculateH(165), kCalculateV(49))];
    self.textField.placeholder = @"验证码(区分大小写)";
    [self.textField setValue:[UIFont systemFontOfSize:kCalculateH(14)] forKeyPath:@"_placeholderLabel.font"];
    [self.textField setValue:PYColor(@"cccccc") forKeyPath:@"_placeholderLabel.textColor"];
    [view addSubview:self.textField];

    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textField.frame), kCalculateV(18), kCalculateH(1), kCalculateV(13))];
    hView.backgroundColor = PYColor(@"dbdbdb");
    [view addSubview:hView];
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.timeButton.frame = CGRectMake(CGRectGetMaxX(hView.frame), 0, kCalculateH(80), kCalculateV(49));
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    [self.timeButton setTitleColor:PYColor(@"cccccc") forState:UIControlStateNormal];
    [view addSubview:self.timeButton];
    
}
@end
