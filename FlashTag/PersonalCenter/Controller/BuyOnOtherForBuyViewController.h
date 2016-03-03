//
//  BuyOnOtherForBuyViewController.h
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购页面买

#import <UIKit/UIKit.h>

typedef enum {
    BuyOnOtherForBuyTypeDefault,//普通卖家－买界面   抽象出来 表示 一个是三个表
    BuyOnOtherForBuyTypeSelf//我的代购                          一个是两个表
}BuyOnOtherForBuyType;

@interface BuyOnOtherForBuyViewController : UIViewController

@property (nonatomic)BuyOnOtherForBuyType type;

@end
