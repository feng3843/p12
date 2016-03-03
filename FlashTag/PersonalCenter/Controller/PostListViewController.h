//
//  PostListViewController.h
//  FlashTag
//
//  Created by MyOS on 15/10/13.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  文件夹下帖子列表

#import <UIKit/UIKit.h>

#import "PostListView.h"

@interface PostListViewController : UIViewController

@property(nonatomic , strong)PostListView *rootView;

@property(nonatomic , copy)NSString *itemID;
@property(nonatomic , copy)NSString *userId;

@property(nonatomic , copy)NSString *itemID111;
@property(nonatomic , copy)NSString *itemID222;


@end
