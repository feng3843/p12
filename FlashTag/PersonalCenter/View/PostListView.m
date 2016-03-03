//
//  PostListView.m
//  FlashTag
//
//  Created by MyOS on 15/10/13.
//  Copyright (c) 2015年 Puyun. All rights reserved.
// 文件夹下帖子列表

#import "PostListView.h"

@implementation PostListView

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
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = PYColor(@"e7e7e7");
    [self addSubview:self.collectionView];
    
}




@end
