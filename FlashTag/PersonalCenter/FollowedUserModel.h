//
//  FollowedUserModel.h
//  FlashTag
//
//  Created by uncommon on 2015/09/25.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/// 关注model（可以是我关注的人，也可以是关注我的人）
@interface FollowedUserModel : NSObject

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
