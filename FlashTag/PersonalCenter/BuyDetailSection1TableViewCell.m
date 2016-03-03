//
//  BuyDetailSection1TableViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购详情分区1cell

#import "BuyDetailSection1TableViewCell.h"

@implementation BuyDetailSection1TableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubviews];
        self.backgroundColor = PYColor(@"ffffff");
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = PYColor(@"cccccc").CGColor;
    }
    return self;
}

- (void)addSubviews
{
    self.indentNumber = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(15), fDeviceWidth - 2*kCalculateH(15), kCalculateV(12))];
    self.indentNumber.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.indentNumber.textColor = PYColor(@"999999");
    
    self.AlipayIndentNumber = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(self.indentNumber.frame) + kCalculateV(6), fDeviceWidth - 2*kCalculateH(15), kCalculateV(12))];
    self.AlipayIndentNumber.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.AlipayIndentNumber.textColor = PYColor(@"999999");
    
    self.indentTime = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(self.AlipayIndentNumber.frame) + kCalculateV(6), fDeviceWidth - 2*kCalculateH(15), kCalculateV(12))];
    self.indentTime.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.indentTime.textColor = PYColor(@"999999");
    
    self.finishTime = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(self.indentTime.frame) + kCalculateV(6), fDeviceWidth - 2*kCalculateH(15), kCalculateV(12))];
    self.finishTime.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.finishTime.textColor = PYColor(@"999999");
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(self.finishTime.frame) + kCalculateV(6), kCalculateH(60), kCalculateV(12))];
    label.text = @"代购状态:";
    label.font = [UIFont systemFontOfSize:kCalculateH(12)];
    label.textColor = PYColor(@"999999");
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMaxY(self.finishTime.frame) + kCalculateV(6), kCalculateH(250), kCalculateV(12))];
    self.stateLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.stateLabel.textColor = PYColor(@"f24949");
    
    [self.contentView addSubview:self.indentNumber];
    [self.contentView addSubview:self.AlipayIndentNumber];
    [self.contentView addSubview:self.indentTime];
    [self.contentView addSubview:self.finishTime];
    [self.contentView addSubview:label];
    [self.contentView addSubview:self.stateLabel];
}
@end
