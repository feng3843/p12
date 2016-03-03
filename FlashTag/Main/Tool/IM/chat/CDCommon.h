//
//  CDCommon.h
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/29/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#ifndef AVOSChatDemo_CDCommon_h
#define AVOSChatDemo_CDCommon_h

#import <AVOSCloud/AVOSCloud.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define NOTIFICATION_MESSAGE_UPDATED @"NOTIFICATION_MESSAGE_UPDATED"
#define NOTIFICATION_SESSION_UPDATED @"NOTIFICATION_SESSION_UPDATED"


//底部tabbar索引
#define TABAR_CHAT 0
#define TABAR_CONTACT 1
#define TABAR_INFO 2
#define TABAR_PROJECT 3
#define TABAR_ACTIVITY 4

#endif
