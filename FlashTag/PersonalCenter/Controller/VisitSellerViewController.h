//
//  VisitSellerViewController.h
//  22222222222222222
//
//  Created by MyOS on 15/8/29.
//  Copyright (c) 2015年 MyOS. All rights reserved.
//  访问卖家页面

#import <UIKit/UIKit.h>
#import "ButtonView.h"

#import "VisitSellerView.h"

typedef void (^returnBackFunction)(NSString *);

@interface VisitSellerViewController : UIViewController

@property (nonatomic, copy) returnBackFunction returnBackBlock;

@property(nonatomic , strong)VisitSellerView *visitSellerView;

@property(nonatomic , copy)NSString *userId;


@property (nonatomic, strong) ButtonView *buttonView;


@property(nonatomic , strong)UIButton *leftTopButton;
@property(nonatomic , strong)UIButton *userHeardButton;
@property(nonatomic , strong)UILabel *nameLabel;
@property(nonatomic , strong)UIButton *hotButton;
@property(nonatomic , strong)UIButton *attentionButton;
@property(nonatomic , strong)UIButton *fansButton;

@property(nonatomic , strong)UILabel *placeLabel;

@property(nonatomic , strong)UIImageView *topView1;

@property(nonatomic , strong)UIButton *chatButton;
@property(nonatomic , strong)UIButton *addButton;


@end
