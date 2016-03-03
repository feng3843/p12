//
//  ScoreRuleModel.h
//  FlashTag
//
//  Created by uncommon on 2015/09/28.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 积分规则
@interface ScoreRuleModel : NSObject

//"id": "8",
//"scoreRuleName": "被关注",
//"score": "5",
//"dayLimit": "1000",
//"state": "1"

///
@property(nonatomic,copy)NSString *scoreRuleName;
///
@property(nonatomic,copy)NSString *score;

@property(nonatomic,copy)NSString *state;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
