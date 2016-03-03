//
//  ConfirmBuyViewController.h
//  FlashTag
//
//  Created by py on 15/9/15.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  确认代购

#import <UIKit/UIKit.h>

typedef enum {
//    BuyTypeDefault,
    BuyTypeApply,
    BuyTypeConfirm
}BuyType;

typedef enum {
    BuyUserTypeDefault,
    BuyUserTypeSeller,
    BuyUserTypeBuyer
}BuyUserType;

@interface ConfirmBuyViewController : UIViewController

@property BuyUserType userType;
@property BuyType type;

@property NSString* strID;
@property NSString* strOwnerID;
//代购商品信息
@property NSString* strImage;
@property NSString* strContent;

@property NSString* strPrice;

@property NSInteger maxNum;

@end
