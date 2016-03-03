//
//  MyResultModel.h
//  FlashTag
//
//  Created by uncommon on 2015/09/28.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 个人成果Model
@interface MyResultModel : NSObject

/// 热度值
@property(nonatomic,copy)NSString *popularity;
/// 现有积分
@property(nonatomic,copy)NSString *score;
/// 热度值对应的热度等级
@property(nonatomic,copy)NSString *level;
/// 还差多少热度值就可以升级
@property(nonatomic,copy)NSString *count;
/// 历史总积分
@property(nonatomic,copy)NSString *scoreTotal;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
