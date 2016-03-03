//
//  PingLunCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "PingLunCell.h"

@implementation PingLunCell

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
    CGFloat with = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imageSize = kCalculateV(40);
    self.userHeardImage = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(14), kCalculateV(9), imageSize, imageSize)];
    self.userHeardImage.layer.masksToBounds = YES;
    self.userHeardImage.layer.cornerRadius = imageSize/2;
    
//    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHeardImage.frame) + kCalculateH(10), kCalculateV(16), kCalculateH(80), kCalculateV(14))];
    self.userName = [[UILabel alloc] init];
    _userName.font = [UIFont systemFontOfSize:14];
    [_userName autoresizingMask];
    _userName.textColor = PYColor(@"#222222");
    
    
    self.pingLunLabel = [[UILabel alloc] init];
//                         WithFrame:CGRectMake(CGRectGetMaxX(self.userName.frame), CGRectGetMinY(self.userName.frame), kCalculateH(50), kCalculateV(14))];
    self.pingLunLabel.text = @"评论";
    self.pingLunLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _pingLunLabel.textColor = PYColor(@"#999999");

    
    
    self.infoLabel = [[UILabel alloc] init];
//                         WithFrame:CGRectMake(CGRectGetMinX(self.userName.frame), CGRectGetMaxY(self.userName.frame)+5, CGRectGetWidth(self.userName.frame)+100, 11)];
    self.infoLabel.font = [UIFont systemFontOfSize:11];
    self.infoLabel.textColor = PYColor(@"#a9a9a9");
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(64), CGRectGetMaxY(self.userHeardImage.frame), with - kCalculateH(14)-kCalculateH(64), kCalculateV(38))];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tempView.frame.size.width, tempView.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"bg_comment_dialogue box"];
    [tempView addSubview:imageView];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(7), kCalculateV(14), tempView.frame.size.width, 14)];
//    self.contentLabel.textAlignment = NSTextAlignmentCenter;
//    self.contentLabel.verticalAlignment = VerticalAlignmentMiddle;
    self.contentLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    _contentLabel.textColor = PYColor(@"#000000");
//    _contentLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_comment_dialogue box"]];
    [tempView addSubview:self.contentLabel];
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(with - kCalculateH(50), kCalculateV(9), kCalculateH(35), kCalculateV(35))];
    
    [self.leftImageView.layer setMasksToBounds:YES];
    [self.leftImageView.layer setCornerRadius:4];
    
    
    [self addSubview:self.userHeardImage];
    [self addSubview:self.userName];
    [self addSubview:self.infoLabel];
    [self addSubview:self.leftImageView];
    [self addSubview:self.pingLunLabel];
    [self addSubview:tempView];
}


@end
