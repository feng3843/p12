//
//  UserAdviceView.m
//  FlashTag
//
//  Created by MyOS on 15/9/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "UserAdviceView.h"

@implementation UserAdviceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PYColor(@"e7e7e7");
        [self addSubviews];
    }
    return self;
}


- (void)addSubviews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(10), kCalculateH(290), kCalculateV(180))];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    
    self.reminderText = [[UITextView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(10), kCalculateH(290), kCalculateV(180))];
    self.reminderText.text = @"请输入您的建议";
    self.reminderText.textColor = [UIColor lightGrayColor];
    self.reminderText.font = [UIFont systemFontOfSize:kCalculateH(15)];
    self.reminderText.layer.cornerRadius = 4;
    [self addSubview:self.reminderText];
    
    self.contentText = [[UITextView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(10), kCalculateH(290), kCalculateV(180))];
    self.contentText.font = [UIFont systemFontOfSize:kCalculateH(15)];
    self.contentText.layer.cornerRadius = 4;
    self.contentText.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentText];
    
    
    self.completeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.completeButton.frame = CGRectMake(kCalculateH(kBJ), CGRectGetMaxY(self.contentText.frame) + kCalculateV(20), kCalculateH(290), kCalculateV(39));
    [self.completeButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.completeButton setTitleColor:PYColor(@"ffffff") forState:UIControlStateNormal];
    self.completeButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
    [self.completeButton setBackgroundColor:PYColor(@"5db5f3")];
    self.completeButton.layer.cornerRadius = 4;
    [self addSubview:self.completeButton];
}



@end
