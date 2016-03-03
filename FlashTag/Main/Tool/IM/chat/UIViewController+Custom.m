//
//  UIViewController+Custom.m
//  StartPage
//
//  Created by andy on 14/10/26.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import "UIViewController+Custom.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extensions.h"
#import "CMData.h"
#import "CMAPI.h"
#import "LKBadgeView.h"
#import "AppDelegate.h"
#import "CMTool.h"

#define TEXT_COLOR [UIColor colorWithHexString:@"d7d7d7"]

@implementation UIViewController (Custom)

- (void)setCustomTitle:(NSString *)title
{
    [self setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width*2/5, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:19];
        // titleView.textColor = [UIColor colorWithHexString:@"898e91"];
        titleView.textAlignment = NSTextAlignmentCenter;
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}
- (void)createCloseButton
{
    //创建关闭按钮，替代默认返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0.0, 0.0, 23.0, 23.0);
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)gotoRoot
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end

@implementation UITableViewController (Custom)

- (void)setCustomTitle:(NSString *)title
{
    [self setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width*2/5, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:19];
        // titleView.textColor = [UIColor colorWithHexString:@"898e91"];
        titleView.textAlignment = NSTextAlignmentCenter;
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)goback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoRoot
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
