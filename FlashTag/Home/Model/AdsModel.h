//
//  AdsModel.h
//  FlashTag
//
//  Created by py on 15/9/16.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  广告精选模型

#import <Foundation/Foundation.h>

@interface AdsModel : NSObject
/**
    itemId = 3,
    itemTitle = 美食,
	itemDesc = 很好吃的排骨，活动超低促销中。微卤采用42味中草药及香料，精卤18道工序，不含任何防腐剂，绝对保证现做现卖，让你好吃的停不下来。微的口味
 */
/** 广告id*/
@property(nonatomic,copy)NSString *itemId;
/** 广告标题*/
@property(nonatomic,copy)NSString *itemTitle;
/** 广告帖子*/
@property(nonatomic,copy)NSString *itemDesc;

@end
