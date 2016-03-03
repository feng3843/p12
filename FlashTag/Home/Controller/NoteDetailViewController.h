//
//  NoteDetailViewController.h
//  FlashTag
//
//  Created by 夏雪 on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  帖子详情

#import <UIKit/UIKit.h>
#import "NoteInfoView.h"
#import "NoteVIewController.h"

typedef void (^returnBackFunction)(NSString *);
@interface NoteDetailViewController : NoteVIewController
@property (nonatomic, copy) returnBackFunction returnBackBlock;
@end
