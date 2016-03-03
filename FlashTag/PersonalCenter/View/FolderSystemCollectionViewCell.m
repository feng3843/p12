//
//  FolderSystemCollectionViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/17.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "FolderSystemCollectionViewCell.h"

@implementation FolderSystemCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        self.backgroundColor = PYColor(@"ffffff");
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = kCalculateH(10);
        self.layer.borderWidth = kCalculateH(0.5);
        self.layer.borderColor = PYColor(@"d0d0d0").CGColor;
    }
    return self;
}

- (void)addSubviews
{
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(7), 0, self.bounds.size.width, kCalculateV(25))];
    _topLabel.textColor = PYColor(@"000000");
    _topLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    [self.contentView addSubview:_topLabel];
    
    self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(3), kCalculateV(25), self.bounds.size.width - kCalculateH(6), kCalculateV(132))];
    self.bottomImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
    _bottomImageView.clipsToBounds  = YES;
    _bottomImageView.contentMode =  UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_bottomImageView];
    
    self.bottomSmallImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(3), CGRectGetMaxY(self.bottomImageView.frame) + kCalculateH(2), kCalculateH(45), kCalculateV(48))];
    self.bottomSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
    [self.contentView addSubview:_bottomSmallImageView1];
    
    self.bottomSmallImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bottomSmallImageView1.frame) + kCalculateH(2), CGRectGetMinY(self.bottomSmallImageView1.frame), kCalculateH(45), kCalculateV(48))];
    self.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
    [self.contentView addSubview:_bottomSmallImageView2];
    
    self.bottomSmallImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bottomSmallImageView2.frame) + kCalculateH(2), CGRectGetMinY(self.bottomSmallImageView1.frame), kCalculateH(45), kCalculateV(48))];
    self.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
    [self.contentView addSubview:_bottomSmallImageView3];
    
}

- (UILabel *)reminderLabel
{
    if (!_reminderLabel) {
        self.reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - kCalculateH(6))*3/5, kCalculateV(140), (self.bounds.size.width - kCalculateH(6))*2/5 - 2, kCalculateV(15))];
        _reminderLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _reminderLabel.layer.masksToBounds = YES;
        _reminderLabel.layer.cornerRadius = kCalculateH(4);
        _reminderLabel.font = [UIFont systemFontOfSize:kCalculateH(10)];
        _reminderLabel.textColor = PYColor(@"ffffff");
        _reminderLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_reminderLabel];
    }
    return _reminderLabel;
}

@end
