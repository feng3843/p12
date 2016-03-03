//
//  BuyDetailViewController.h
//  FlashTag
//
//  Created by MyOS on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购详情

#import <UIKit/UIKit.h>
#import "OrderCell.h"

@interface BuyDetailViewController : UIViewController

@property(nonatomic) OrderFlowLayout* flowLayout;

@property(nonatomic)NSMutableDictionary* dic;

@property(nonatomic)NSString* flg;

@property(nonatomic)NSString* status;

@end
