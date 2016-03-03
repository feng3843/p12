//
//  NoteCommentModel.h
//  FlashTag
//
//  Created by py on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  帖子的评论

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface NoteCommentModel : NSObject
/** 评论人名字*/
@property(nonatomic,copy)NSString *userName;
/** 评论人的用户id*/
@property(nonatomic,copy)NSString *userId;
///** 评论人的用户昵称*/
//@property(nonatomic,copy)NSString *userDisplayName;
/** 评论记录的id*/
@property(nonatomic,copy)NSString *commentId;
/** 评论时间*/
@property(nonatomic,copy)NSString *commentTime;
/** 评论内容*/
@property(nonatomic,copy)NSString *commentContent;
///** 被回复的对象*/
//@property(nonatomic,copy)NSString *targetUser;
/** 被评论人名字*/
@property(nonatomic,copy)NSString *targetUserName;
/** 被评论人id*/
@property(nonatomic,copy)NSString *targetUserId;
@property(nonatomic,copy)NSString *noteOwnerId;

@end
