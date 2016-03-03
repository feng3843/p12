//
//  NewFansModel.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NewFansModel.h"

@implementation NewFansModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.role = dic[@"role"];
        self.noteCount = dic[@"noteCount"];
        self.isFriend = dic[@"isFriend"];
        self.followeds = dic[@"followeds"];
        self.userId = dic[@"userId"];
        self.userDisplayName = dic[@"userDisplayName"];
    }
    return self;
}

@end
