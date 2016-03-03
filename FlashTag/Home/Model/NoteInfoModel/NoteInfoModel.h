//
//  NoteInfoModel.h
//  FlashTag
//
//  Created by 夏雪 on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  帖子模型    

#import <Foundation/Foundation.h>

@interface NoteInfoModel : NSObject

/** 帖子拥有者的用户昵称*/
@property(nonatomic ,copy)NSString *userDisplayName;
/** 帖子拥有者的用户id*/
@property(nonatomic,copy)NSString *userId;
/** 发帖地址*/
@property(nonatomic,copy)NSString *noteLocation;
/** 帖子描述*/
@property(nonatomic,copy)NSString *noteDesc;
/** 帖子id*/
@property(nonatomic,copy)NSString *noteId;
/** 浏览量*/
@property(nonatomic ,strong)NSNumber *browseNum;
/** 发帖时间*/
@property(nonatomic,copy)NSString *postTime;
/** 该帖子所属标签集合*/
@property(nonatomic,copy)NSString *tags;
/** 帖子照片数*/
@property(nonatomic ,strong)NSNumber *notePicCount;
/** 点赞数*/
@property(nonatomic ,strong)NSNumber *likes;
/** 评论数*/
@property(nonatomic ,strong)NSNumber *comments;
/** 该帖子所属用户是否被该用户关注了。取值是“yes”或“no”。如果是游客，返回“no”*/
@property(nonatomic,assign)BOOL followed;
/** 是否被浏览过 “yes”浏览过 “no”未浏览过。如果是游客，返回“no”*/
@property(nonatomic,assign)BOOL isLiked;
@property(nonatomic,assign)BOOL isForSale;
@property(nonatomic,copy)NSString *fileId;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *fileType;
/** 交易量*/
@property(nonatomic ,strong)NSNumber *dealCount;
/**
 *  剩下天数
 */
@property(nonatomic,copy)NSString *leftDays;
/**
 *  发帖时间距离现在过了多久
 */
@property(nonatomic,copy)NSString *leftMinutes;
@end
