//
//  BigCollectionViewCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
// 大collectionCell

#import "BigCollectionViewCell.h"


@implementation BigCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
        self.picView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.picView];
        
        UIImageView *mengCeng = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        mengCeng.image = [UIImage imageNamed:@"bg_spcials_big"];
        [self.picView addSubview:mengCeng];
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kCalculateV(25)];
        

        
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

@end
