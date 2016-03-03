//
//  NoteModel.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/8.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel


/*
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
 */

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.noteDesc = dic[@"noteDesc"];
        
        if ([dic[@"browseNum"] isKindOfClass:[NSNull class]]) {
            self.browseNum = @"0";
        } else {
            self.browseNum = dic[@"browseNum"];
        }
        
        if ([dic[@"comments"] isKindOfClass:[NSNull class]]) {
            self.comments = @"0";
        } else {
            self.comments = dic[@"comments"];
        };
        
        if ([dic[@"notePicCount"] isKindOfClass:[NSNull class]]) {
            self.notePicCount = @"0";
        } else {
            self.notePicCount = dic[@"notePicCount"];
        };
        

        if ([dic[@"likes"] isKindOfClass:[NSNull class]]) {
            self.likes = @"0";
        } else {
            self.likes = dic[@"likes"];
        };
        
        self.tags = dic[@"tags"];
        self.noteId = dic[@"noteId"];
        self.userDisplayName = dic[@"userDisplayName"];
        self.userId = dic[@"userId"];
        self.noteLocation = dic[@"noteLocation"];
        self.isForSale = dic[@"isForSale"];
        self.isLiked = dic[@"isLiked"];
        self.followed = dic[@"followed"];
        self.postTime = dic[@"postTime"];
        self.dealCount = dic[@"dealCount"];
        
    }
    return self;
}

@end
