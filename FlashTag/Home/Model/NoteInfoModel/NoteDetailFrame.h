//
//  NoteInfoFrame.h
//  FlashTag
//
//  Created by 夏雪 on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NoteDetailModel;
@interface NoteDetailFrame : NSObject

@property(nonatomic ,strong)NoteDetailModel *noteInfo;

/** 帖子照片*/
@property (nonatomic, assign, readonly) CGRect noteImageF;
/** 帖子描述*/
@property (nonatomic, assign, readonly) CGRect descNoteF;
/** 标签*/
@property (nonatomic, assign, readonly) CGRect tagImageF;
@property (nonatomic, assign, readonly) CGRect tagOneBtnF;
@property (nonatomic, assign, readonly) CGRect tagTwoBtnF;
@property (nonatomic, assign, readonly) CGRect tagThreeBtnF;
@property (nonatomic, assign, readonly) CGRect tagFourBtnF;
/** 发布时间*/
@property (nonatomic, assign, readonly) CGRect publishTimeF;
/** 浏览量*/
@property (nonatomic, assign, readonly) CGRect browseCountF;
/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
