//
//  SeaTableViewHeaderView.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/7.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "SeaTableViewHeaderView.h"

@implementation SeaTableViewHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PYColor(@"f4f4f4");
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), 0, 200, kCalculateV(25))];
        _headerLabel.font = [UIFont systemFontOfSize:kCalculateV(13)];
        _headerLabel.textColor = PYColor(@"888888");
        [self addSubview:_headerLabel];
    }
    return self;
}

@end
