//
//  FansCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/5.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell


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
    
    CGFloat imageSize = 40;
    self.userHeardImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, imageSize, imageSize)];
    self.userHeardImage.layer.masksToBounds = YES;
    self.userHeardImage.layer.cornerRadius = imageSize/2;
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHeardImage.frame) + 10, 16, 150, 14)];
    _userName.font = [UIFont systemFontOfSize:14];
    _userName.textColor = PYColor(@"#222222");
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userName.frame), CGRectGetMaxY(self.userName.frame)+5, CGRectGetWidth(self.userName.frame), 11)];
    self.infoLabel.font = [UIFont systemFontOfSize:11];
    self.infoLabel.textColor = PYColor(@"#999999");
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(with - 50, 12, 35, 35)];
    [self.leftImageView.layer setMasksToBounds:YES];
    [self.leftImageView.layer setCornerRadius:4];
    self.leftImageView.layer.borderWidth = 1.0;
    self.leftImageView.layer.borderColor = PYColor(@"cccccc").CGColor;

    
    [self addSubview:self.userHeardImage];
    [self addSubview:self.userName];
    [self addSubview:self.infoLabel];
    [self addSubview:self.leftImageView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
