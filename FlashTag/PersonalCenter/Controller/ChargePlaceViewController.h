//
//  ChargePlaceViewController.h
//  FlashTag
//
//  Created by MyOS on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  收费货位页面

#import <UIKit/UIKit.h>

#import "ChargePlaceView.h"

@interface ChargePlaceViewController : UIViewController

@property (nonatomic , strong)ChargePlaceView *chargePlaceView;
@property NSInteger emptyCount;

@end
