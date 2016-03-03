//
//  NewZanModel.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewZanModel : NSObject

- (instancetype) initWithDictionary:(NSDictionary *)dic;
/**点赞时间*/
@property (nonatomic, copy) NSString *time;
/**记录在数据库中的自增id*/
@property (nonatomic, copy) NSString *aid;
/**帖子的id*/
@property (nonatomic, copy) NSString *noteId;
/**用户昵称*/
@property (nonatomic, copy) NSString *nikeName;
/**用户id*/
@property (nonatomic, copy) NSString *userId;
/**用户类型*/
@property (nonatomic, copy) NSString *role;

@end
