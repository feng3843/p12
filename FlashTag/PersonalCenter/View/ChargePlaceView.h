//
//  ChargePlaceView.h
//  FlashTag
//
//  Created by MyOS on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  收费货位页面

#import <UIKit/UIKit.h>
#import "ButtonView.h"

@interface ChargePlaceView : UIView

//@property(nonatomic , strong)UIButton *allButton;
//@property(nonatomic , strong)UIButton *idleButton;
//@property(nonatomic , strong)UIButton *dueButton;

@property (nonatomic, strong) ButtonView *buttonView;

@property(nonatomic , strong)UISegmentedControl *segment;
@property(nonatomic , strong)UIScrollView *showScrollView;

@property(nonatomic , strong)UICollectionView *allCollectionView;
@property(nonatomic , strong)UICollectionView *idleCollectionView;
@property(nonatomic , strong)UICollectionView *dueCollectionView;

@end
