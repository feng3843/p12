//
//  JingXuanUserModel.h
//  FlashTag
//
//  Created by MyOS on 15/10/20.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JingXuanUserModel : NSObject


-(instancetype)initWithDictionary:(NSDictionary *)dic;

/// 用户昵称
@property(nonatomic,copy)NSString *userDisplayName;
/// 用户id
@property(nonatomic,copy)NSString *userId;
/// 该用户的帖子数量
@property(nonatomic,copy)NSString *noteCount;
/// 该用户的粉丝数量
@property(nonatomic,copy)NSString *followeds;


@property(nonatomic , copy)NSString *isAttention;
@property(nonatomic , copy)NSString *role;

@end
