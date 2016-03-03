//
//  BuyDetailView.m
//  FlashTag
//
//  Created by MyOS on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购详情

#import "BuyDetailView.h"

@implementation BuyDetailView

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight - 44)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    [self addSubview:self.tableView];
}

@end
