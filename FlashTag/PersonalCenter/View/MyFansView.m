//
//  MyFansView.m
//  11111111111111111111
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 MyOS. All rights reserved.
//  我的粉丝页面

#import "MyFansView.h"

@implementation MyFansView


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

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kQPHeight - 64)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = PYColor(@"e7e7e7");
    
    [self addSubview:self.tableView];

}
@end
