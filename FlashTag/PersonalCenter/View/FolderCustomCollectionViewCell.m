//
//  FolderCustomCollectionViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/17.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "FolderCustomCollectionViewCell.h"

@implementation FolderCustomCollectionViewCell


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

    self.midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(3), kCalculateV(25), self.bounds.size.width - kCalculateH(6), kCalculateV(104))];
    self.midImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.midImageView.clipsToBounds = YES;
    self.midImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
    _midImageView.contentMode = UIViewContentModeCenter;
    _midImageView.clipsToBounds  = YES;
    _midImageView.contentMode =  UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_midImageView];
    
    self.midSmallImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(3), CGRectGetMaxY(self.midImageView.frame) + kCalculateH(2), kCalculateH(45), kCalculateV(48))];
    self.midSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
//    self.midSmallImageView1.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_midSmallImageView1];
    
    self.midSmallImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.midSmallImageView1.frame) + kCalculateH(2), CGRectGetMinY(self.midSmallImageView1.frame), kCalculateH(45), kCalculateV(48))];
    self.midSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
//    self.midSmallImageView2.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_midSmallImageView2];
    
    
    self.midSmallImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.midSmallImageView2.frame) + kCalculateH(2), CGRectGetMinY(self.midSmallImageView1.frame), kCalculateH(45), kCalculateV(48))];
    self.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
//    self.midSmallImageView3.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_midSmallImageView3];

    
    self.midReminderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - kCalculateH(6))*3/5, kCalculateV(112), (self.bounds.size.width - kCalculateH(6))*2/5 - 2, kCalculateV(15))];
    _midReminderLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    _midReminderLabel.layer.masksToBounds = YES;
    _midReminderLabel.layer.cornerRadius = kCalculateH(4);
    _midReminderLabel.font = [UIFont systemFontOfSize:kCalculateH(10)];
    _midReminderLabel.textColor = PYColor(@"ffffff");
    _midReminderLabel.textAlignment = NSTextAlignmentCenter;    [self.contentView addSubview:_midReminderLabel];
    
    
    self.bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _bottomButton.frame = CGRectMake((self.bounds.size.width - kCalculateH(136))/2, CGRectGetMaxY(self.midSmallImageView1.frame) + kCalculateV(2.5), kCalculateH(136), kCalculateV(25));
    _bottomButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    _bottomButton.layer.masksToBounds = YES;
    _bottomButton.layer.cornerRadius = kCalculateH(6);
    _bottomButton.layer.borderWidth = 1;
    _bottomButton.layer.borderColor = PYColor(@"e1e1e1").CGColor;
    [_bottomButton setTitleColor:PYColor(@"acacac") forState:UIControlStateNormal];
    [self.contentView addSubview:_bottomButton];
    
}

@end
