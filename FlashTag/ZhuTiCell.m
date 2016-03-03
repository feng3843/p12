//
//  ZhuTiCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "ZhuTiCell.h"

@implementation ZhuTiCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat phoneWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = (219.0 / 320)*([UIScreen mainScreen].bounds.size.width);
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, phoneWidth, self.frame.size.height)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, phoneWidth, height)];
        self.pic.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.pic];
        
        UIImageView *mengCeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, phoneWidth, height)];
        mengCeng.image = [UIImage imageNamed:@"bg_spcials_big"];
        [self.pic addSubview:mengCeng];
        
        self.nameLa = [[UILabel alloc] initWithFrame:self.pic.frame];
        self.nameLa.textAlignment = NSTextAlignmentCenter;
        self.nameLa.textColor = [UIColor whiteColor];
        self.nameLa.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [self.contentView addSubview:self.nameLa];
        
        self.deta = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.pic.frame), backView.frame.size.width-20, backView.frame.size.height - CGRectGetMaxY(self.pic.frame))];
        self.deta.numberOfLines = 0;
        self.deta.font = [UIFont systemFontOfSize:14];
        self.deta.backgroundColor = PYColor(@"#ffffff");
        self.deta.textColor = PYColor(@"#515151");
        [self.contentView addSubview:self.deta];
        
    }
    return self;
}


- (UIView *)userView
{
    if (!_userView) {
        self.userView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, fDeviceWidth, kCalculateV(44))];
        _userView.backgroundColor = PYColor(@"f5f5f5");
        _userView.layer.masksToBounds = YES;
        _userView.layer.borderWidth = 0.5;
        _userView.layer.borderColor = PYColor(@"cccccc").CGColor;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(10), 0, kCalculateH(60), kCalculateV(44))];
        label.font = [UIFont systemFontOfSize:kCalculateH(12)];
        label.textColor = PYColor(@"999999");
        label.text = @"推荐用户";
        [_userView addSubview:label];
        
        for (int i = 0; i < 6; i++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(70) + i*kCalculateH(37), kCalculateH(6), kCalculateH(32), kCalculateH(32))];
            imageV.layer.masksToBounds = YES;
            imageV.layer.cornerRadius = kCalculateH(16);
            imageV.tag = 1000+i;
            
            [_userView addSubview:imageV];
        }
        
        UIImageView *next = [[UIImageView alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(39), kCalculateV(10), kCalculateH(24), kCalculateV(24))];
        next.image = [UIImage imageNamed:@"ic_search_tag"];
        [_userView addSubview:next];
        
        [self.contentView addSubview:_userView];
    }
    
    return _userView;
}

@end
