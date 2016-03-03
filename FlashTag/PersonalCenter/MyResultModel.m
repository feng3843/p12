//
//  MyResultModel.m
//  FlashTag
//
//  Created by uncommon on 2015/09/28.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import "MyResultModel.h"

@implementation MyResultModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.popularity=dic[@"popularity"];
        self.score=dic[@"score"];
        self.level=dic[@"level"];
        self.count=dic[@"count"];
        self.scoreTotal=dic[@"scoreTotal"];
    }
    return self;
}

@end
