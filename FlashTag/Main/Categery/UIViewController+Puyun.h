//
//  UIViewController+Puyun.h
//  StartPage
//
//  Created by andy on 14/10/26.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteInfoModel.h"
#import "NSString+Extensions.m"

@interface UIViewController (Puyun)

- (void)initialNavigationContorllor;
//设置窗口的标题，可以设置字体
- (void)setCustomTitle:(NSString *)title;
- (void)createCloseButton;
- (void)createBackButton;
- (void)createBackButtonWithBarItem:(NSString*)title;
- (void)createBackButtonWithTitle:(NSString*)title;
- (void) createOrgListButton:(BOOL)isShowRedPoint;
- (void)goback:(id)sender;
- (void)gotoRoot;
- (void)shareImage:(id)sender Model:(NoteInfoModel*)model InController:(id<UIAlertViewDelegate>)delagate;
- (void)noLogin;
@end

@interface UIScrollView (Puyun)

@end

@interface UITableViewController (Puyun)
//- (void)initialNavigationContorllor;
//设置窗口的标题，可以设置字体
- (void)setCustomTitle:(NSString *)title;
- (void)createBackButton;
- (void)goback:(id)sender;
- (void)gotoRoot;
@end
