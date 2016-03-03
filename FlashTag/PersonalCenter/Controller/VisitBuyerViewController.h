//
//  VisitBuyerViewController.h
//  FlashTag
//
//  Created by MyOS on 15/8/31.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  访问买家页面

#import <UIKit/UIKit.h>
#import "ButtonView.h"

#import "VisitBuyerView.h"

typedef void (^returnBackFunction)(NSString *);

@interface VisitBuyerViewController : UIViewController

@property (nonatomic, copy) returnBackFunction returnBackBlock;

@property(nonatomic , strong)VisitBuyerView *VisitBuyerView;


@property(nonatomic , copy)NSString *userId;


@property (nonatomic, strong) ButtonView *buttonView;


@property(nonatomic , strong)UIButton *leftTopButton;
@property(nonatomic , strong)UIButton *userHeardButton;
@property(nonatomic , strong)UILabel *nameLabel;
@property(nonatomic , strong)UIButton *hotButton;
@property(nonatomic , strong)UIButton *attentionButton;
@property(nonatomic , strong)UIButton *fansButton;

@property(nonatomic , strong)UIImageView *topView1;

@property(nonatomic , strong)UIButton *chatButton;
@property(nonatomic , strong)UIButton *addButton;


@end
