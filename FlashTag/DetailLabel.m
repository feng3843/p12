//
//  DetailLabel.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/15.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "DetailLabel.h"

@implementation DetailLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.detailLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.textColor = PYColor(@"515151");
        _detailLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

@end
