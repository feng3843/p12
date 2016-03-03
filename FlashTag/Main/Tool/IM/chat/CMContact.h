//
//  CMContact.h
//  StartPage
//
//  Created by andy on 14/10/26.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMContact : NSObject

@property (strong,nonatomic) NSString* strContactID;//id
@property (strong,nonatomic) NSString* strOrgID;//组织机构代码
@property (strong,nonatomic) NSString* strPinyin;//拼音
@property (strong,nonatomic) NSString* strName;//名字
@property (strong,nonatomic) NSString* strJob;//职位
@property (strong,nonatomic) NSString* strEmail;//Email
@property (strong,nonatomic) NSString* strTelePhone;//电话
@property (strong,nonatomic) NSString* strMotion;//心情
@property (strong,nonatomic) NSString* strAvatar;//头像
@property (strong,nonatomic) NSString* strNickName;//昵称
@property (strong,nonatomic) NSString* strBirth;//生日
@property (strong,nonatomic) NSString* strGender;//性别
@property (strong,nonatomic) NSString* strAddress;//地址

@property (strong,nonatomic) NSString* strCorpName;//公司
@property (strong,nonatomic) NSString* strCorpEmail;//电话
@property (strong,nonatomic) NSString* strCorpIntro;//公司介绍
@property (strong,nonatomic) NSString* strGroupID;//联系人分组
@property (strong,nonatomic) NSString* strVC;//版本号

@property int64_t readMsgTimestamp;//已读消息时间戳
@property int64_t maxMsgTimestamp;//最新消息时间戳

@end

//联系人分组
@interface CMContactGroup : NSObject

@property (strong,nonatomic) NSString* strGroupID;
@property (strong,nonatomic) NSString* strOrgID;
@property (strong,nonatomic) NSString* strName;
@end

