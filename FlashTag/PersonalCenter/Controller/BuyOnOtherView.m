//
//  BuyOnOtherView.m
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  我的代购页面(买家身份)

#import "BuyOnOtherView.h"

@implementation BuyOnOtherView

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
    CGFloat buttonWidth = 80;
    CGFloat buttonHeight = kCalculateV(36);
    CGFloat qp = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kCalculateV(36))];
    view1.backgroundColor = PYColor(@"ffffff");
    view1.layer.masksToBounds = YES;
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self addSubview:view1];

    
    self.allButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.allButton.frame = CGRectMake((qp - 2 * buttonWidth)/2, 0, buttonWidth, buttonHeight);
    [self.allButton setTitle:@"全部" forState:UIControlStateNormal];
    [self.allButton setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    self.allButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    
    self.refundButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.refundButton.frame = CGRectMake(CGRectGetMaxX(self.allButton.frame), 0, buttonWidth, buttonHeight);
    [self.refundButton setTitle:@"退款" forState:UIControlStateNormal];
    [self.refundButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    self.refundButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    
    [view1 addSubview:self.allButton];
    [view1 addSubview:self.refundButton];
    
    
    [self setAllTableView];
    [self setRefundTableView];

    
}

- (void)setAllTableView
{
    self.allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.allButton.frame), self.bounds.size.width, fDeviceHeight - kCalculateV(36) - 44)];
    self.allTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.allTableView.backgroundColor = PYColor(@"e7e7e7");
    
    [self addSubview:self.allTableView];
}

- (void)setRefundTableView
{
    self.refundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.allButton.frame), self.bounds.size.width, fDeviceHeight - kCalculateV(36) - 44)];
    self.refundTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.refundTableView.backgroundColor = PYColor(@"e7e7e7");
    [self addSubview:self.refundTableView];
    self.refundTableView.hidden = YES;
}


@end
