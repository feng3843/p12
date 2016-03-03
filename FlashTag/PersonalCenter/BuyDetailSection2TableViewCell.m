//
//  BuyDetailSection2TableViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购详情分区2cell

#import "BuyDetailSection2TableViewCell.h"

@implementation BuyDetailSection2TableViewCell

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
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(15), 120, kCalculateV(12))];
    pLabel.text = @"代购总额:";
    pLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    pLabel.textColor = PYColor(@"999999");
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(15) - 150, kCalculateV(15), 150, kCalculateV(12))];
    self.priceLabel.textColor = PYColor(@"f24949");
    self.priceLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(pLabel.frame) + kCalculateV(6), 120, kCalculateV(12))];
    sLabel.text = @"-积分";
    sLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    sLabel.textColor = PYColor(@"999999");
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(15) - 150, CGRectGetMaxY(pLabel.frame) + kCalculateV(6), 150, kCalculateV(12))];
    self.scoreLabel.textColor = PYColor(@"f24949");
    self.scoreLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    
    UIView *divideLine = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(60), fDeviceWidth - 2*kCalculateH(15), kCalculateV(0.5))];
    divideLine.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *lLabel = [[UILabel alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(185), CGRectGetMaxY(divideLine.frame), kCalculateH(90), kCalculateV(40))];
    lLabel.text = @"实付款:";
    lLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    lLabel.textColor = PYColor(@"222222");
    lLabel.textAlignment = NSTextAlignmentRight;
    
    self.lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lLabel.frame), CGRectGetMinY(lLabel.frame), kCalculateH(80), kCalculateV(40))];
    self.lastLabel.textColor = PYColor(@"f24949");
    self.lastLabel.font = [UIFont systemFontOfSize:kCalculateH(17)];
    self.lastLabel.textAlignment = NSTextAlignmentRight;
    
    
    [self.contentView addSubview:pLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:sLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:divideLine];
    [self.contentView addSubview:lLabel];
    [self.contentView addSubview:self.lastLabel];
}

@end
