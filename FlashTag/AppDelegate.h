//
//  AppDelegate.h
//  FlashTag
//
//  Created by 夏雪 on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
//分享
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, retain)   TencentOAuth *tencentOAuth;
@property (nonatomic, retain)   NSArray* permissions;

@end

