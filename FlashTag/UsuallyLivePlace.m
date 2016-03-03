//
//  UsuallyLivePlace.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "UsuallyLivePlace.h"

@implementation UsuallyLivePlace

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.country = dic[@"country"];
        self.locateAddress = dic[@"locateAddress"];
        self.province = dic[@"province"];
        self.city = dic[@"city"];
    }
    return self;
}

@end
