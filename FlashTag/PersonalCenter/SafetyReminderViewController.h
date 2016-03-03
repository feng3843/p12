//
//  SafetyReminderViewController.h
//  FlashTag
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  安全提示页面

#import <UIKit/UIKit.h>

@interface SafetyReminderViewController : UIViewController

@property(nonatomic , strong)NSMutableDictionary *dic;

//忘记密码
@property(nonatomic , assign)BOOL isForgetPassword;
@property(nonatomic , copy)NSString *userName;

@end
