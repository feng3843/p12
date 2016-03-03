//
//  LibCM.h
//  FlashTag
//
//  Created by LA－PC on 15/9/16.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibCM : NSObject


//LA  添加  根据用户ID获取用户头像
+(NSString*)getUserAvatarByUserID:(NSString*)userid;

//LA  添加  根据用户id和帖子id获取帖子头像
+(NSString*)getPostImgWithUserID:(NSString*)userid PostID:(NSString*)postid;

//LA  添加  根据货位id获取货位图片
+(NSString*)getHuoweiImgWithID:(NSString*)hwID;

@end
