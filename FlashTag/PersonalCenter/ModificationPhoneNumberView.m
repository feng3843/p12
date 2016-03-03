//
//  ModificationPhoneNumberView.m
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  修改号页面

#import "ModificationPhoneNumberView.h"

@implementation ModificationPhoneNumberView

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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kCalculateV(49))];
    view.backgroundColor = PYColor(@"ffffff");
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = kCalculateH(0.5);
    view.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self addSubview:view];

    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(15), 0, kCalculateH(290), kCalculateV(49))];
    [self.textField setValue:[UIFont systemFontOfSize:kCalculateH(14)] forKeyPath:@"_placeholderLabel.font"];
    [self.textField setValue:PYColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [view addSubview:self.textField];

    
}

@end
