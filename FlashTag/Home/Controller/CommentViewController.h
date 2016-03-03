//
//  CommentViewController.h
//  FlashTag
//
//  Created by py on 15/9/23.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  评论

#import <UIKit/UIKit.h>

 typedef void (^CommentCount)(NSString *);
@interface CommentViewController : UIViewController

@property(nonatomic,copy)NSString *noteId;
@property(nonatomic,copy)NSString *noteOwnerId;
@property(nonatomic)BOOL isNoHead;
@property (nonatomic, copy) CommentCount commentCount;
@end
