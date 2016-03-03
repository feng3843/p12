//
//  LittleCollectionViewCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
// 小collectionCell

#import "LittleCollectionViewCell.h"
#import "Masonry.h"

@implementation LittleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor grayColor];
        self.picView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.picView];
        
        UIImageView *mengCeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-kCalculateV(40), self.frame.size.width, kCalculateV(40))];
        mengCeng.image = [UIImage imageNamed:@"bg_spcials_small"];
        [self.picView addSubview:mengCeng];
        mengCeng.alpha = 0.5;
        
        NSInteger littleWidth = [UIScreen mainScreen].bounds.size.width / 2 - 1;
        NSInteger littleHeight = (88.0/159)*littleWidth;
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, littleHeight - 10 - 20+4, self.frame.size.width, 20)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = PYColor(@"#ffffff");
        self.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
        
        
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

@end
