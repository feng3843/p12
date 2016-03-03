//
//  FolderChargeCollectionViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/17.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "FolderChargeCollectionViewCell.h"

@implementation FolderChargeCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PYColor(@"#ffffff");
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = kCalculateH(10);
        self.layer.borderWidth = kCalculateH(0.5);
        self.layer.borderColor = PYColor(@"#d0d0d0").CGColor;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{

    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(7), 0, self.bounds.size.width, kCalculateV(25))];
    _topLabel.textColor = PYColor(@"#000");
    _topLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    [self.contentView addSubview:_topLabel];

    
    self.midImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - kCalculateH(138))/2, CGRectGetMaxY(self.topLabel.frame), kCalculateH(138), kCalculateV(154))];
    _midImageView.contentMode = UIViewContentModeCenter;
    _midImageView.clipsToBounds  = YES;
    _midImageView.contentMode =  UIViewContentModeScaleAspectFill;

    [self.contentView addSubview:_midImageView];
}

- (UIImageView *)dueImageView
{
    if (!_dueImageView) {
        self.dueImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - kCalculateH(138))/2, CGRectGetMaxY(self.topLabel.frame), kCalculateH(138), kCalculateV(154))];
//        _dueImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _dueImageView.alpha = 0.8;
        
        [self.contentView addSubview:_dueImageView];
    }
    return _dueImageView;
}



- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.midImageView.frame), self.bounds.size.width, kCalculateV(30))];
        _bottomLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_bottomLabel];
    }
    return _bottomLabel;
}


- (UIButton *)bottomButton
{
    if (!_bottomButton) {
        self.bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _bottomButton.frame = CGRectMake((self.bounds.size.width - kCalculateH(136))/2, CGRectGetMaxY(self.midImageView.frame) + kCalculateV(2.5), kCalculateH(136), kCalculateV(25));
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
        _bottomButton.layer.masksToBounds = YES;
        _bottomButton.layer.cornerRadius = kCalculateH(3);
        _bottomButton.layer.borderWidth = kCalculateH(0.5);
        _bottomButton.layer.borderColor = PYColor(@"e1e1e1").CGColor;
        [_bottomButton setTitleColor:PYColor(@"#acacac") forState:UIControlStateNormal];
        [self.contentView addSubview:_bottomButton];
    }
    return _bottomButton;
}

@end
