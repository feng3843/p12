//
//  UserInfoTableViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  用户信息头像cell

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

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
    CGFloat imageSize = kCalculateH(60);
    self.userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(75), kCalculateV(10), imageSize, imageSize)];
    self.userHeadImageView.layer.masksToBounds = YES;
    self.userHeadImageView.layer.cornerRadius = imageSize/2;
    self.userHeadImageView.image = [UIImage imageNamed:@"ic_head"];
    
    [self.contentView addSubview:self.userHeadImageView];
}
@end
