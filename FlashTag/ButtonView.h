//
//  ButtonView.h
//  KVOAndNSNotificationCenter
//
//  Created by 黄黄双全 on 15/9/25.
//  Copyright (c) 2015年 黄黄双全. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UIView

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, assign) CGFloat wide;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) int index;


- (instancetype)initWithFrame:(CGRect)frame andTwoButtonArr:(NSArray *)array;
- (instancetype)initWithFrame:(CGRect)frame andButtonArr:(NSArray *)array;

- (instancetype)initWithFrame:(CGRect)frame andLoginButtonArr:(NSArray *)array;

- (void)btn1Action:(UIButton *)sender;
- (void)btn2Action:(UIButton *)sender;
- (void)btn3Action:(UIButton *)sender;
@end
