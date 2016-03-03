//
//  NewFansModel.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFansModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;
/**该粉丝帖子数量*/
@property (nonatomic, copy) NSString *noteCount;
/**我是否关注了他*/
@property (nonatomic, copy) NSString *isFriend;
/**该粉丝拥有粉丝数量*/
@property (nonatomic, copy) NSString *followeds;
/**该粉丝的用户类型*/
@property (nonatomic, copy) NSString *role;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userDisplayName;

@end
