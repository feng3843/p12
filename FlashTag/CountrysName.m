
//
//  CountrysName.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/20.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "CountrysName.h"

@implementation CountrysName

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.englishName = dic[@"engLishName"];
        self.stateId = dic[@"stateId"];
        self.isHot = dic[@"isHot"];
        self.domain = dic[@"domain"];
        self.chineseName = dic[@"chineseName"];
    }
    return self;
}

@end
