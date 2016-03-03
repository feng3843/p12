//
//  FreePlaceView.m
//  FlashTag
//
//  Created by MyOS on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  免费货位页面

#import "FreePlaceView.h"

@implementation FreePlaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}


- (void)addSubviews
{
    //约束
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kCalculateH(144), kCalculateV(210));
    layout.sectionInset = UIEdgeInsetsMake(kCalculateH(10), kCalculateH(10), kCalculateH(10), kCalculateH(10));
    //设置item之间的最小间距
    layout.minimumInteritemSpacing = kCalculateH(10);
    //设置行与行之间的最小间距
    layout.minimumLineSpacing = kCalculateH(10);
    
    //页面
    self.allCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:layout];
    self.allCollectionView.backgroundColor = PYColor(@"e7e7e7");
    [self addSubview:self.allCollectionView];
    
}


@end
