//
//  VisitSellerView.m
//  22222222222222222
//
//  Created by MyOS on 15/8/29.
//  Copyright (c) 2015年 MyOS. All rights reserved.
//  访问卖家页面

#import "VisitSellerView.h"


@implementation VisitSellerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCollectionView];
    }
    return self;
}

- (void)addCollectionView
{
    
    //约束
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kCalculateH(144), kCalculateV(210));
    layout.sectionInset = UIEdgeInsetsMake(kCalculateH(10), kCalculateH(10), kCalculateH(10), kCalculateH(10));
    //设置item之间的最小间距
    layout.minimumInteritemSpacing = kCalculateH(10);
    //设置行与行之间的最小间距
    layout.minimumLineSpacing = kCalculateH(10);
    //设置分区页眉（header）大小
    layout.headerReferenceSize = CGSizeMake(fDeviceWidth, kCalculateV(271));
    
    //帖子页面
    self.postCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kQPHeight) collectionViewLayout:layout];
    self.postCollectionView.backgroundColor = PYColor(@"e7e7e7");
    [self addSubview:self.postCollectionView];
    
}




@end
