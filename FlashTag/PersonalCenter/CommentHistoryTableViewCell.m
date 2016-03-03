//
//  CommentHistoryTableViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "CommentHistoryTableViewCell.h"

@implementation CommentHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = PYColor(@"ffffff");
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    CGFloat imageSize = kCalculateH(35);
    
    CGFloat labelWidth = fDeviceWidth - kCalculateH(10 + 15 + 15) - imageSize;
    self.detaillabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(14), labelWidth, kCalculateV(13))];
    self.detaillabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.detaillabel.textColor = PYColor(@"000000");
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.detaillabel.frame), CGRectGetMaxY(self.detaillabel.frame), labelWidth, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.timeLabel.textColor = PYColor(@"999999");
    
    self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.detaillabel.frame) + kCalculateH(10), kCalculateV(10), imageSize, imageSize)];
    self.postImageView.layer.masksToBounds = YES;
    self.postImageView.layer.cornerRadius = kCalculateH(8);
    
    UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(60), fDeviceWidth, kCalculateV(10))];
    divideView.backgroundColor = PYColor(@"e7e7e7");
    
    [self.contentView addSubview:self.detaillabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.postImageView];
    [self.contentView addSubview:divideView];
}

@end
