//
//  CommentView.m
//  FlashTag
//
//  Created by MyOS on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  评论过的

#import "CommentView.h"

@implementation CommentView

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight - 64)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.tableView];
}

@end
