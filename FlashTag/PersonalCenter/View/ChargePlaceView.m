//
//  ChargePlaceView.m
//  FlashTag
//
//  Created by MyOS on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  收费货位页面

#import "ChargePlaceView.h"

@implementation ChargePlaceView

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
    //
//    //topView
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, 40)];
//    [self addSubview:view];
    
    //segment
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"全部", @"闲置", @"已到期"]];
    self.segment.frame = CGRectMake(0, 0, fDeviceWidth, kCalculateV(36));
    self.segment.selectedSegmentIndex = 0;
    [self addSubview:self.segment];
    //修改成button
    CGRect frame = CGRectMake(0, 0, fDeviceWidth, kCalculateV(36));
    self.buttonView = [[ButtonView alloc] initWithFrame:frame andButtonArr:@[@"全部", @"闲置", @"已到期"]];
    _buttonView.btn1.selected = YES;
    [self addSubview:_buttonView];
    
    
    //展示帖子底部serollView
    self.showScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame), fDeviceWidth, kQPHeight - 64 - kCalculateV(36))];
    self.showScrollView.contentSize = CGSizeMake(3 * fDeviceWidth, self.showScrollView.frame.size.height);
    self.showScrollView.pagingEnabled = YES;
    self.showScrollView.bounces = NO;
    self.showScrollView.showsHorizontalScrollIndicator = NO;
    self.showScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.showScrollView];
    
    //约束
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kCalculateH(144), kCalculateV(210));
    layout.sectionInset = UIEdgeInsetsMake(kCalculateH(10), kCalculateH(10), kCalculateH(10), kCalculateH(10));
    //设置item之间的最小间距
    layout.minimumInteritemSpacing = kCalculateH(10);
    //设置行与行之间的最小间距
    layout.minimumLineSpacing = kCalculateH(10);
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.itemSize = CGSizeMake((fDeviceWidth - kCalculateH(30))/2, kCalculateV(210));
    layout1.sectionInset = UIEdgeInsetsMake(kCalculateH(10), kCalculateH(10), kCalculateH(10), kCalculateH(10));
    //设置item之间的最小间距
    layout1.minimumInteritemSpacing = kCalculateH(10);
    //设置行与行之间的最小间距
    layout1.minimumLineSpacing = kCalculateH(10);
    
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.itemSize = CGSizeMake((fDeviceWidth - kCalculateH(30))/2, kCalculateV(210));
    layout2.sectionInset = UIEdgeInsetsMake(kCalculateH(10), kCalculateH(10), kCalculateH(10), kCalculateH(10));
    //设置item之间的最小间距
    layout2.minimumInteritemSpacing = kCalculateH(10);
    //设置行与行之间的最小间距
    layout2.minimumLineSpacing = kCalculateH(10);
    
    
    //全部页面
    self.allCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, self.showScrollView.frame.size.height) collectionViewLayout:layout];
    self.allCollectionView.backgroundColor = PYColor(@"e7e7e7");
    [self.showScrollView addSubview:self.allCollectionView];
    
    //闲置页面
    self.idleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(fDeviceWidth, 0, fDeviceWidth, self.showScrollView.frame.size.height) collectionViewLayout:layout1];
    self.idleCollectionView.backgroundColor = PYColor(@"e7e7e7");
    [self.showScrollView addSubview:self.idleCollectionView];
    
    //过期页面
    self.dueCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2 * fDeviceWidth, 0, fDeviceWidth, self.showScrollView.frame.size.height) collectionViewLayout:layout2];
    self.dueCollectionView.backgroundColor = PYColor(@"e7e7e7");
    [self.showScrollView addSubview:self.dueCollectionView];

}

@end
