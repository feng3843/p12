//
//  SetView.m
//  FlashTag
//
//  Created by MyOS on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  设置

#import "SetView.h"

@implementation SetView

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
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
}
@end
