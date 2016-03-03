//
//  UserProtocolViewController.m
//  FlashTag
//
//  Created by MyOS on 15/10/16.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()

@property(nonatomic , strong)UIWebView *webView;

@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.title = @"买咩用户协议";
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];

    [self setContentWithWeb];
    
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setContentWithWeb
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
    self.webView.scrollView.bounces = NO;
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"user_agreement" ofType:@"html"];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];

}

@end
