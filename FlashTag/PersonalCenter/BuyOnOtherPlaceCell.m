//
//  BuyOnOtherPlaceCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/7.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购页面货位cell

#import "BuyOnOtherPlaceCell.h"

#define kBbj 15

@implementation BuyOnOtherPlaceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        
        self.backgroundColor = PYColor(@"ffffff");
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = PYColor(@"cccccc").CGColor;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addSubviews
{
    CGFloat postImageSize = kCalculateH(60);
    CGFloat detailLabelWidth = kCalculateH(150);
    self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(15), postImageSize, postImageSize)];
    self.postImageView.layer.masksToBounds = YES;
    self.postImageView.layer.cornerRadius = kCalculateH(8);
    self.postImageView.image = [UIImage imageNamed:@"test2.jpg"];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.postImageView.frame) + kCalculateH(10), kCalculateV(18), detailLabelWidth, kCalculateV(12))];
    self.detailLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.detailLabel.textColor = PYColor(@"515151");
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.detailLabel.frame), kCalculateV(34), detailLabelWidth, kCalculateV(12))];
    self.timeLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.timeLabel.textColor = PYColor(@"515151");
    
//    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.detailLabel.frame), kCalculateV(55), kCalculateH(30), kCalculateV(12))];
//    pLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
//    pLabel.textColor = PYColor(@"999999");
//    pLabel.text = @"支付:";
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.detailLabel.frame), kCalculateV(55), 100, kCalculateV(12))];
    self.priceLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(12)];
    self.priceLabel.textColor = PYColor(@"222222");
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(65)-30, kCalculateV(40), kCalculateH(50)+30, kCalculateV(20))];
    self.stateLabel.textColor = PYColor(@"f24949");
    self.stateLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.stateLabel.textAlignment=NSTextAlignmentRight;
    
    UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(90), fDeviceWidth, kCalculateV(10))];
    divideView.backgroundColor = PYColor(@"e7e7e7");
    divideView.layer.masksToBounds = YES;
    divideView.layer.borderColor = PYColor(@"cccccc").CGColor;
    divideView.layer.borderWidth = 0.5;
    
    [self.contentView addSubview:self.postImageView];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.timeLabel];
//    [self.contentView addSubview:pLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:divideView];
}

@end
