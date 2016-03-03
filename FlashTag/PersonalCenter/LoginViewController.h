//
//  LoginViewController.h
//  FlashTag
//
//  Created by MyOS on 15/9/1.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  登录注册页面

#import <UIKit/UIKit.h>

#import "ButtonView.h"
#import "LoginView.h"

@interface LoginViewController : UIViewController
{
    ShareType type;
}
@property (nonatomic, strong) ButtonView *buttonView;

@property(nonatomic , strong)LoginView *rootView;

@property(nonatomic , strong)NSDictionary *userInfo;



@property(nonatomic , assign)BOOL isChangePhoneNumber;
@property(nonatomic , assign)BOOL isChangeAlipayNumber;

@end
