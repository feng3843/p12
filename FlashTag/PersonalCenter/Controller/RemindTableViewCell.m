//
//  RemindTableViewCell.m
//  CustomRemindView
//
//  Created by MyOS on 15/9/1.
//  Copyright (c) 2015年 MyOS. All rights reserved.
//

#import "RemindTableViewCell.h"

@implementation RemindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(16), kCalculateV(10), kCalculateV(35), kCalculateV(35))];
    self.leftImage.backgroundColor = PYColor(@"e7e7e7");
    [self.contentView addSubview:self.leftImage];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImage.frame) + kCalculateH(13), 0, 180, kCalculateV(55))];
    self.label.font = [UIFont systemFontOfSize:kCalculateH(15)];
    self.label.textColor = PYColor(@"222222");
    [self.contentView addSubview:self.label];
    
    self.divideLine = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(16), kCalculateV(53.5), kCalculateH(280 - 32), kCalculateV(0.5))];
    self.divideLine.backgroundColor = PYColor(@"d9d9d9");
    [self.contentView addSubview:self.divideLine];
}





@end
