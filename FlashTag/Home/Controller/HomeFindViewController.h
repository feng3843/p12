//
//  HomeFindViewController.h
//  FlashTag
//
//  Created by 夏雪 on 15/8/27.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  首页发现

#import <UIKit/UIKit.h>
#import "NoteVIewController.h"

typedef enum {
    HomeTypeAttention,//首页 关注
    HomeTypeFind//首页 发现
}HomeType;

@interface HomeFindViewController : NoteVIewController

@property HomeType type;

@end
