//
//  ZhuanGuiCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "ZhuanGuiCell.h"

@implementation ZhuanGuiCell

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        CGFloat phoneWhite = [UIScreen mainScreen].bounds.size.width;
//        CGFloat phoneHeight = [UIScreen mainScreen].bounds.size.height;
        
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor =[UIColor whiteColor];
        CGFloat height = (219.0 / 320)*([UIScreen mainScreen].bounds.size.width);
        
        self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, phoneWhite, height)];
        [backView addSubview:self.pic];
        
        UIImageView *mengCeng = [[UIImageView alloc] initWithFrame:self.pic.bounds];
        mengCeng.image = [UIImage imageNamed:@"bg_spcials_big"];
        [self.pic addSubview:mengCeng];
        mengCeng.alpha = 0.5;
        
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height+19, phoneWhite-20, 20)];
        self.titleLabel.text = @"品牌介绍";
        self.titleLabel.textColor = PYColor(@"#515151");
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [backView addSubview:_titleLabel];
        
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height+19+20+13, phoneWhite-20, frame.size.height-height-60)];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.textColor = PYColor(@"#515151");
        [backView addSubview:self.detailLabel];
        [self addSubview:backView];
    }
    return self;
}

@end
