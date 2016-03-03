//
//  CollectionTwoCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
// 代购页面

#import "CollectionTwoCell.h"

@implementation CollectionTwoCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        
        //帖子图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-30)];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imgView];
        
        //商品详情
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imgView.frame) + 5, CGRectGetWidth(self.frame)-10, 60)];
        self.text.numberOfLines = 0;
        self.text.font = [UIFont systemFontOfSize:12];
        self.text.textColor = PYColor(@"#888888");
        self.text.backgroundColor = [UIColor whiteColor];
        self.text.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.text];
        
        
        self.countOfSale = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame), frame.size.width-kCalculateH(15), kCalculateV(30))];
        self.countOfSale.textColor = PYColor(@"#888888");
        self.countOfSale.font = [UIFont systemFontOfSize:12];
        self.countOfSale.textAlignment=NSTextAlignmentRight;
        [self addSubview:self.countOfSale];
        
    }
    return self;
}

@end
