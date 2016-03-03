//
//  UserModel.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
/***热卖度*/
@property (nonatomic, copy) NSString *popularity;
/***是否关注*/
@property (nonatomic, copy) NSString *followed;
/***用户Id*/
@property (nonatomic, copy) NSString *userId;
/***帖子拥有者的用户昵称*/
@property (nonatomic, copy) NSString *userDisPlayName;
/***该用户所在地与本用户常住地址的距离*/
@property (nonatomic, copy) NSString *distance;
/**用户类型*/
@property (nonatomic, copy) NSString *role;
/**用户等级*/
@property (nonatomic, copy) NSString *levle;



@end
