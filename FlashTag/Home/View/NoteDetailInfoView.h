//
//  NoteDetailInfoView.h
//  FlashTag
//
//  Created by 夏雪 on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  帖子详情介绍

#import <UIKit/UIKit.h>

@protocol NoteDetailInfoViewDelegate <NSObject>

@optional
-(void)tagBtnClickWithTitle:(NSString *)title;

@end
@class NoteDetailFrame;
@interface NoteDetailInfoView : UITableViewCell
@property(nonatomic ,strong)NoteDetailFrame *noteInfoFrame;
@property(nonatomic,weak)id<NoteDetailInfoViewDelegate> delegate;
@end
