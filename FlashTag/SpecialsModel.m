//
//  SpecialsModel.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/26.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "SpecialsModel.h"

@implementation SpecialsModel

-(instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.createTime = dic[@"createTime"];
        self.itemId = dic[@"itemId"];
        self.itemDesc = dic[@"itemDesc"];
        self.itemTitle = dic[@"itemTitle"];
    }
    return self;
}

@end
