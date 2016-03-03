//
//  LoginView.h
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  登录注册页面

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property(nonatomic , strong)UIButton *rigisterButton;
@property(nonatomic , strong)UISegmentedControl *segment;

//登陆页面按钮
@property(nonatomic , strong)UIView *loginView;
@property(nonatomic , strong)UITextField *loginUserName;
@property(nonatomic , strong)UITextField *loginPassword;
@property(nonatomic , strong)UIButton *forgetPasswordButton;
@property(nonatomic , strong)UIButton *loginButton;
@property(nonatomic , strong)UIButton *weiBoButton;
@property(nonatomic , strong)UIButton *qqButton;
@property(nonatomic , strong)UIButton *weiXinButton;

//注册页面按钮
@property(nonatomic , strong)UIView *rigisterView;
@property(nonatomic , strong)UITextField *rigisterUserName;
@property(nonatomic , strong)UITextField *rigisterPassword;
@property(nonatomic , strong)UITextField *againPassword;
@property(nonatomic , strong)UIButton *getServeButton;
@property(nonatomic , strong)UIButton *nextButton;
//输入支付宝账号

@property(nonatomic , strong)UITextField *AlipayUserName;
@property(nonatomic , strong)UIView *AlipayBgView;


@end
