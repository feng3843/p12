//
//  CountrysName.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/20.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountrysName : NSObject

- (instancetype)initWithDic:(NSDictionary *)dic;

@property (nonatomic, copy) NSString *englishName;
@property (nonatomic, copy) NSString *stateId;
@property (nonatomic, copy) NSString *isHot;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *chineseName;

@end
