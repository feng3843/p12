//
//  InviteView.m
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  输入邀请码界面

#import "InviteView.h"

@implementation InviteView

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

    //输入邀请码
    self.inviteCode = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), 0, kCalculateH(kButtonWidth), kCalculateV(44))];
    self.inviteCode.textColor = PYColor(@"222222");
    self.inviteCode.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.inviteCode.placeholder = @"输入邀请码";
    [self.inviteCode setValue:[UIFont systemFontOfSize:kCalculateH(13)] forKeyPath:@"_placeholderLabel.font"];
    [self.inviteCode setValue:PYColor(@"9fa8af") forKeyPath:@"_placeholderLabel.textColor"];
    [view1 addSubview:self.inviteCode];

    //下一步
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextButton.frame = CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(view1.frame) + kCalculateV(30), kCalculateH(290), kCalculateV(39));
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:PYColor(@"ffffff") forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
    [self.nextButton setBackgroundColor:PYColor(@"5db5f3")];
    self.nextButton.layer.cornerRadius = 4;
    
    [self addSubview:self.nextButton];

}


@end
