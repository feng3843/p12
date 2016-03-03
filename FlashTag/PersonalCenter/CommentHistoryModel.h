//
//  CommentHistoryModel.h
//  FlashTag
//
//  Created by MyOS on 15/9/15.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentHistoryModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property(nonatomic , copy)NSString *commentTime;
@property(nonatomic , copy)NSString *content;
@property(nonatomic , copy)NSString *noteId;
@property(nonatomic , copy)NSString *noteOwnerId;

@end
