//
//  BuyOnOtherModel.h
//  FlashTag
//
//  Created by MyOS on 15/9/17.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyOnOtherModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property(nonatomic , copy)NSString *tradeId;
@property(nonatomic , copy)NSString *buyer;
@property(nonatomic , copy)NSString *sellerId;
@property(nonatomic , copy)NSString *noteId;
@property(nonatomic , copy)NSString *noteDesc;
@property(nonatomic , copy)NSString *money;
@property(nonatomic , copy)NSString *status;
@property(nonatomic , copy)NSString *backApplyTime;
@property(nonatomic , copy)NSString *backEndTime;
@property(nonatomic , copy)NSString *isValidate;

@property(nonatomic , copy)NSString *reminder;

@end
