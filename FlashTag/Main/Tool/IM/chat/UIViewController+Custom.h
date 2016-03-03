//
//  UIViewController+Custom.h
//  StartPage
//
//  Created by andy on 14/10/26.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Custom)

//设置窗口的标题，可以设置字体
- (void)setCustomTitle:(NSString *)title;
- (void)createCloseButton;
- (void)gotoRoot;
@end

@interface UITableViewController (Custom)

//设置窗口的标题，可以设置字体
- (void)setCustomTitle:(NSString *)title;
- (void)gotoRoot;
@end
