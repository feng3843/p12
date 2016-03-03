//
//  LibCM.m
//  FlashTag
//
//  Created by LA－PC on 15/9/16.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "LibCM.h"
#import "CMAPI.h"
#import "CMData.h"
#import "NSString+Extensions.h"

@implementation LibCM
//LA  添加  根据用户ID获取用户头像
+(NSString*)getUserAvatarByUserID:(NSString*)userid
{
    
    NSString *str=@"";
    if (userid) {
        str=[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg",[CMData getCommonImagePath],userid];
        
    }
    return str;
}

//LA  添加  根据用户id和帖子id获取帖子头像
+(NSString*)getPostImgWithUserID:(NSString*)userid PostID:(NSString*)postid
{
    NSString* str=@"";
    NSString* uid=@"";
    if(userid.length==0)
    return @"";
    if(userid.length==1)
        uid=[NSString stringWithFormat:@"0%@",userid];
    if(userid.length>=2)
        uid=[userid SubsRight:2];
    if(postid)
        str=[NSString stringWithFormat:@"%@/%@/note%@_1.jpg",[CMData getCommonImagePath],uid,postid];
    
    return str;
}

//LA  添加  根据货位id获取货位图片
+(NSString*)getHuoweiImgWithID:(NSString*)hwID
{
    NSString* str=@"";
    if(hwID)
        str=[NSString stringWithFormat:@"%@/shops/shops%@.jpg",[CMData getCommonImagePath],hwID];
    return str;
}

@end
