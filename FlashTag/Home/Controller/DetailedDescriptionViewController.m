//
//  DetailedDescriptionViewController.m
//  FlashTag
//
//  Created by py on 15/9/5.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  详情描述

#import "DetailedDescriptionViewController.h"
#import "PYAllCommon.h"
#define btnColor PYColor(@"3385cb")
@interface DetailedDescriptionViewController ()<UITextViewDelegate>
@property (weak, nonatomic)  UITextView *textView;
@property (weak, nonatomic) UILabel *promptLable;

@end

@implementation DetailedDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:self.view.frame];
    
    textView.font = PYSysFont(13 *rateW);
    self.textView = textView;
    self.textView.delegate = self;
    [self.view addSubview:textView];
    // Do any additional setup after loading the view.
    UILabel *promptLable = [[UILabel alloc]initWithFrame:CGRectMake(2 *rateW,64, fDeviceWidth, 30)];
    promptLable.text = @"分享您的使用心得吧！";
    promptLable.font = PYSysFont(13 *rateW);
    promptLable.textColor = PYColor(@"999999");
    promptLable.numberOfLines = 0;
    self.promptLable = promptLable;
    [self.view addSubview:promptLable];
    
    UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
//    [completeBtn setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    completeBtn.titleLabel.font = PYSysFont(17 *rateH);
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [completeBtn setTitleColor:btnColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    if (![self.noteDesc isEqualToString:@"分享您的使用心得吧！"]) {
           self.textView.text = self.noteDesc;
        self.promptLable.hidden = YES;
    }
  
}


- (void)setNoteDesc:(NSString *)noteDesc
{
    _noteDesc = noteDesc;
 
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.promptLable.hidden = NO;
    }else
    {
        self.promptLable.hidden = YES;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - completeBtnClick完成按钮
- (void)completeBtnClick
{
    NSString *text = self.textView.text;
    
    [PYNotificationCenter postNotificationName:DEFAULT_NOTEDESC_NOTIFICATION object:nil userInfo:@{DEFAULT_ADDNOTEDESC_TAGS : text}];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
