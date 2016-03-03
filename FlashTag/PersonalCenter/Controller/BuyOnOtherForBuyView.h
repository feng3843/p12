//
//  BuyOnOtherForBuyView.h
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购页面买

#import <UIKit/UIKit.h>
#import "BuyOnOtherForBuyViewController.h"

@interface BuyOnOtherForBuyView : UIView

@property (nonatomic)BuyOnOtherForBuyType type;

@property(nonatomic , strong)UIButton *allButton;
@property(nonatomic , strong)UIButton *refundButton;
@property(nonatomic , strong)UIButton *placeButton;

@property(nonatomic , strong)UITableView *allTableView;
@property(nonatomic , strong)UITableView *refundTableView;
@property(nonatomic , strong)UITableView *placeTableView;


@end
