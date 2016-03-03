//
//  SafetyReminderView.h
//  FlashTag
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  安全提示页面

#import <UIKit/UIKit.h>

@interface SafetyReminderView : UIView

@property(nonatomic , strong)UIButton *reminderButton;
@property(nonatomic , strong)UITextField *answerTextField;
@property(nonatomic , strong)UIButton *completeButton;

@property(nonatomic , strong)UIButton *reminderButton1;
@property(nonatomic , strong)UIView *answerBgView;
@property(nonatomic , strong)UIView *reminder1BgView;

@end
