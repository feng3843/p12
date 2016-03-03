//
//  UserAdviceViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "UserAdviceViewController.h"
#import "UserAdviceView.h"

@interface UserAdviceViewController ()<UITextViewDelegate>

@property(nonatomic , strong)UserAdviceView *rootView;

@end

@implementation UserAdviceViewController

- (void)loadView
{
    [super loadView];
    
    self.rootView = [[UserAdviceView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.rootView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    self.rootView.contentText.delegate = self;
    self.rootView.reminderText.delegate = self;
    
    [self.rootView.completeButton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
}


- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - textView代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == self.rootView.contentText) {
        
        self.rootView.reminderText.hidden = YES;
    }
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([self.rootView.contentText.text isEqualToString:@""]) {
        
        self.rootView.reminderText.hidden = NO;
    } else{
        self.rootView.reminderText.hidden = YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)completeAction
{
    if (self.rootView.contentText.text.length > 0) {
        [self networkRequest];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)networkRequest
{
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"cont":self.rootView.contentText.text};
    
    [CMAPI postUrl:API_USER_ADVICE Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"提交");
            [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
    
}


@end
