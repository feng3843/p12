//
//  JingXuanUserModel.m
//  FlashTag
//
//  Created by MyOS on 15/10/20.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "JingXuanUserModel.h"

@implementation JingXuanUserModel


-(instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.userId = dic[@"id"];
        self.userDisplayName = dic[@"nikeName"];
        self.noteCount = dic[@"noteNum"];
        self.followeds = dic[@"fansNum"];
        self.role = dic[@"role"];
        self.isAttention = dic[@"followed"];
    }
    return self;
}



@end
