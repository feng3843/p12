//
//  AboutUsView.m
//  FlashTag
//
//  Created by MyOS on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  关于我们

#import "AboutUsView.h"

@implementation AboutUsView

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
    CGFloat imageSize = kCalculateH(80);
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((fDeviceWidth - kCalculateH(80))/2, kCalculateV(26), imageSize, imageSize)];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = kCalculateH(8);
    
    self.versionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.imageView.frame), CGRectGetMaxY(self.imageView.frame) + kCalculateV(10), CGRectGetWidth(self.imageView.frame), kCalculateV(14))];
    self.versionsLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    self.versionsLabel.textColor = PYColor(@"222222");
    self.versionsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kCalculateV(150), fDeviceWidth, kCalculateV(132 - 0.5))];
    self.tableView.scrollEnabled = NO;
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fDeviceHeight - 44 - 52, fDeviceWidth, kCalculateV(12))];
    self.bottomLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.bottomLabel.textColor = PYColor(@"999999");
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.imageView];
    [self addSubview:self.versionsLabel];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomLabel];
}



@end
