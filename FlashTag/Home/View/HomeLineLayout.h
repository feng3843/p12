//
//  HomeLineLayout.h
//  FlashTag
//
//  Created by 夏雪 on 15/8/27.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HMItemWH 61 *rateW

@class HomeLineLayout;
@protocol HomeLineLayoutDelegate <NSObject>

@optional
- (void)homeLineLayout:(HomeLineLayout *)homeLineLayout didCenterCellItem:(NSInteger)item;
@end

@interface HomeLineLayout : UICollectionViewFlowLayout
@property(nonatomic,weak)id<HomeLineLayoutDelegate> delegate;
@end
