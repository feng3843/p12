//
//  ScrollCountryView.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/7.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "ScrollCountryView.h"

@implementation ScrollCountryView

- (instancetype)initWithFrame:(CGRect)frame withCount:(CGFloat)buttonCount {
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonCount=buttonCount;
        self.buttons = [NSMutableArray array];
        self.backgroundColor = [UIColor grayColor];
        self.contentSize = CGSizeMake(100, 20);
        [self configureView];
    }
    return self;
}

- (void)configureView {
    CGFloat buttonWide = self.frame.size.width/5;
    for (int i = 0; i<_buttonCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*buttonWide, 0, buttonWide, self.frame.size.height);
        [button setTitle:@"sdf" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor greenColor];
        [self.buttons addObject:button];
        [self addSubview:button];
    }
    
}

@end
