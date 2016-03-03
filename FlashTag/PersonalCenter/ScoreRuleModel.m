//
//  ScoreRuleModel.m
//  FlashTag
//
//  Created by uncommon on 2015/09/28.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import "ScoreRuleModel.h"

@implementation ScoreRuleModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self=[super init];
    if (self) {
        self.scoreRuleName=dictionary[@"scoreRuleName"];
        self.score=dictionary[@"score"];
        self.state=dictionary[@"state"];
    }
    return self;
}

@end
