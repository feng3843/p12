//
//  NewFansTableViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/10/12.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NewFansTableViewCell.h"

@implementation NewFansTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addSubviews
{
    CGFloat with = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imageSize = kCalculateV(40);
    self.userHeardImage = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(10), imageSize, imageSize)];
    self.userHeardImage.layer.masksToBounds = YES;
    self.userHeardImage.layer.cornerRadius = imageSize/2;
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHeardImage.frame) + kCalculateH(15), CGRectGetMinY(self.userHeardImage.frame) + kCalculateV(5), 100 *rateW, kCalculateV(15))];
    self.userName.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.userName.textColor = PYColor(@"222222");
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userName.frame), CGRectGetMaxY(self.userName.frame), CGRectGetWidth(self.userName.frame), kCalculateV(16))];
    self.infoLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.infoLabel.textColor = PYColor(@"999999");
    
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.attentionButton.frame = CGRectMake(with - kCalculateH(84), kCalculateV(16), kCalculateH(69), kCalculateV(27));
    self.attentionButton.layer.masksToBounds = YES;
    self.attentionButton.layer.cornerRadius = kCalculateH(4);
    
    [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionButton setTitle:@"已关注" forState:UIControlStateSelected];
    self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.attentionButton.titleLabel.textColor = PYColor(@"ffffff");
    //    self.attentionButton.backgroundColor = PYColor(@"cccccc");
    
    
    [self addSubview:self.userHeardImage];
    [self addSubview:self.userName];
    [self addSubview:self.infoLabel];
    [self addSubview:self.attentionButton];
}



@end
