//
//  NoteModel.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/8.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *noteDesc;//帖子描述
@property (nonatomic, copy) NSString *browseNum;//浏览量
@property (nonatomic, copy) NSString *comments;//评论数
@property (nonatomic, copy) NSString *notePicCount;//帖子照片个数
@property (nonatomic, copy) NSString *likes;//点赞数
@property (nonatomic, copy) NSString *tags;//该帖子所属标签集合
@property (nonatomic, copy) NSString *noteId;//帖子id
@property (nonatomic, copy) NSString *userDisplayName;//帖子拥有者的用户昵称
@property (nonatomic, copy) NSString *userId;//帖子拥有者的用户id
@property (nonatomic, copy) NSString *noteLocation;//发帖地址
@property (nonatomic, copy) NSString *isForSale;//“yes”（代购帖子）“no”（普通帖子）
@property (nonatomic, copy) NSString *isLiked;//该帖子我是否点过赞，“no”（未点赞）或“yes”（点过赞）。如果是游客，返回“no”
@property (nonatomic, copy) NSString *followed;//该帖子所属用户是否被该用户关注了。取值是“yes”或“no”。如果是游客，返回“no”
@property (nonatomic, copy) NSString *postTime;//发帖时间
@property (nonatomic, copy) NSString *dealCount;//交易量（如果是代购的话显示）

@end
