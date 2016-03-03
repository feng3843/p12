//
//  NewCommentModel.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCommentModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property (nonatomic, copy) NSString *noteId;
@property (nonatomic, copy) NSString *commentUserId;
@property (nonatomic, copy) NSString *noteOwnerId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *targetName;
@property (nonatomic, copy) NSString *commentTime;
@property (nonatomic, copy) NSString *targetUserId;
@property (nonatomic, copy) NSString *userDisplayName;
@property (nonatomic, copy) NSString *role;


@end
