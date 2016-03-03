//
//  HotTableViewCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/5.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCell];
    }
    return self;
}

- (void)configureCell {
    CGFloat jiange = ((fDeviceWidth-kCalculateH(30))-((kCalculateH(65))*4))/3.0;
    self.firstView = [[HotTagView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(15), kCalculateH(65), kCalculateV(65))];
    self.secondView = [[HotTagView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_firstView.frame)+jiange, kCalculateV(15), kCalculateH(65), kCalculateV(65))];
    self.thirdView = [[HotTagView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_secondView.frame)+jiange, kCalculateV(15), kCalculateH(65), kCalculateV(65))];
    self.fourthView = [[HotTagView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_thirdView.frame)+jiange, kCalculateV(15), kCalculateH(65), kCalculateV(65))];

    [self addSubview:_firstView];
    [self addSubview:_secondView];
    [self addSubview:_thirdView];
    [self addSubview:_fourthView];
}

@end
