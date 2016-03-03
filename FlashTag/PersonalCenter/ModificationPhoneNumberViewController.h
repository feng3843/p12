//
//  ModificationPhoneNumberViewController.h
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  修改号页面

#import <UIKit/UIKit.h>

@interface ModificationPhoneNumberViewController : UIViewController

//判断是哪种情况进入本页面，做不同处理
//手机用户修改手机号
@property(nonatomic , assign)BOOL isPhoneUserChangePhoneNumber;
//手机用户填写邮箱号
@property(nonatomic , assign)BOOL isPhoneUserWriteEmail;
//手机用户修改邮箱号
@property(nonatomic , assign)BOOL isPhoneUserChangeEmail;
//邮箱用户填写手机号
@property(nonatomic , assign)BOOL isEmailUserWritePhoneNumber;
//邮箱用户修改手机号
@property(nonatomic , assign)BOOL isEmailUserChangePhoneNumber;
//修改昵称
@property(nonatomic , assign)BOOL isChangeUserName;
//修改支付宝号
@property(nonatomic , assign)BOOL isChangeAlipayNumber;

@end
