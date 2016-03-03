//
//  MessageNavViewController.m
//  FlashTag
//
//  Created by py on 15/10/8.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "MessageNavViewController.h"
#import "CMData.h"
#import "LoginViewController.h"
#import "MessageHomeVC.h"

#import "NotificationTool.h"
@interface MessageNavViewController ()

@end

@implementation MessageNavViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[CMData getToken] isEqualToString:@""]) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self pushViewController:vc animated:YES];
    }else
    {
        MessageHomeVC *vc = [[MessageHomeVC alloc]init];
       [self pushViewController:vc animated:YES];
    }
}




@end
