//
//  NewCommentModel.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NewCommentModel.h"

@implementation NewCommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.role = dic[@"role"];
        self.noteId = dic[@"noteId"];
        self.commentUserId = dic[@"commentUserId"];
        self.noteOwnerId = dic[@"noteOwnerId"];
        self.content = dic[@"content"];
        self.aid = dic[@"id"];
        self.targetName = dic[@"targetName"];
        self.commentTime = dic[@"commentTime"];
        self.targetUserId = dic[@"targetUserId"];
        self.userDisplayName = dic[@"userDisplayName"];
    }
    return self;
}

@end
