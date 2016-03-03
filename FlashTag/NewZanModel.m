//
//  NewZanModel.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NewZanModel.h"

@implementation NewZanModel

- (instancetype) initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.role = dic[@"role"];
        self.time = dic[@"time"];
        self.aid = dic[@"id"];
        self.noteId = dic[@"noteId"];
        self.nikeName = dic[@"userDisplayName"];
        self.userId = dic[@"userId"];
    }
    return self;
}

@end
