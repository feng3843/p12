//
//  BuyDetailSection3TableViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购详情分区3cell

#import "BuyDetailSection3TableViewCell.h"

@implementation BuyDetailSection3TableViewCell

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
    self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightButton.frame = CGRectMake(fDeviceWidth - kCalculateH(86), kCalculateV(10), kCalculateH(71), kCalculateV(35));
    self.rightButton.layer.borderColor = PYColor(@"999999").CGColor;
    self.rightButton.layer.borderWidth = 1;
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.cornerRadius = kCalculateH(6);
    
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    [self.rightButton setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.rightButton];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.leftButton.frame = CGRectMake(fDeviceWidth - kCalculateH(86)*2, kCalculateV(10), kCalculateH(71), kCalculateV(35));
    self.leftButton.layer.borderColor = PYColor(@"999999").CGColor;
    self.leftButton.layer.borderWidth = 1;
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.layer.cornerRadius = kCalculateH(6);
    
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    [self.leftButton setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.leftButton];
    
}
@end
