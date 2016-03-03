//
//  CMData.h
//  NewCut
//
//  Created by py on 15-7-18.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "CMDefault.h"
#import "CMContact.h"


static NSString *strDatabasePath;

@interface CMData : NSObject

#pragma mark DATABASE
// 初始化数据库
+ (void)initDatabase;

#pragma mark DATABASE_TOOL
//DEFAULT @"0"
+ (NSString*) getStringInDefByKey:(NSString*)key;

+ (NSString*) getStringInDefByKey:(NSString*)key Default:(NSString*) strDefault;

// 查询登录返回的token

+(void)setToken:(NSString *)token;
+(void)setVersion:(NSString*)Version;
+(void)setUserId:(NSString *)userId;
+(void)setUserName:(NSString *)name;
+(void)setPassword:(NSString *)password;
+(void)setUserImage:(NSString *)imagePath;

+(void)setLoginType:(BOOL )type;
+(BOOL)getLoginType;

+(NSString *) getToken;
// 查询登录返回的memId
+ (NSString*)getMemId;
+(NSString*) getVersion;
+(NSString*) getUserName;
+(NSString *) getUserId;
+(NSString *) getUserImage;
+(NSString*)getPassword;
//int userId
+(int)getUserIdForInt;
//用户类型
+(int)getUserType;

/** 图片路径*/
+(void)setCommomImagePath:(NSString *)imagePath;
+(NSString*)getCommonImagePath;

/** 发布帖子id*/
+(void)setPublishNoteId:(NSString *)noteId;
+(NSString *)getPublishNoteId;

//修改ReadTime
+ (void)updateReadTime:(int64_t)readTime ContactID:(NSString *)strContactID;
//保存联系人
+ (BOOL)saveContacts:(NSMutableArray*) contactArray OrgId:(NSString*) orgid;
//查询联系人
+ (CMContact*)queryContactById:(NSString *)contactId;

@end
