//
//  CommonInterface.h
//  FlashTag
//
//  Created by py on 15/9/20.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  调用公共接口的方法

#import <Foundation/Foundation.h>

@interface CommonInterface : NSObject
/** 调用点赞和取消点赞接口*/
+(void)callingInterfacePraise:(NSDictionary *)param succeed:(void (^)())succeeIsLike;

/** 调用发表评论接口*/
+(void)callingInterfacePostComment:(NSDictionary *)param succeed:(void (^)())succeeComment;

/** 调用用户关注或取消关注*/
+(void)callingInterfaceAttention:(NSDictionary *)param succeed:(void (^)())succeeAttention;

/** 调用用户收藏与取消收藏帖子*/
+(void)callingInterfaceCollectNote:(NSDictionary *)param succeed:(void (^)())succeeCollect;
@end
