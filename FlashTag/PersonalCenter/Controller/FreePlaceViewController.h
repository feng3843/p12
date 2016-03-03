//
//  FreePlaceViewController.h
//  FlashTag
//
//  Created by MyOS on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  免费货位页面

#import <UIKit/UIKit.h>
#import "FreePlaceView.h"

@interface FreePlaceViewController : UIViewController

@property(nonatomic , strong)FreePlaceView *freePlaceView;

@property(nonatomic , copy)NSString *itemID;
//空的
@property(nonatomic , assign)int postCount;

@end
