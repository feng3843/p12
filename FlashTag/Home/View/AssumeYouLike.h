//
//  AssumeYouLike.h
//  FlashTag
//
//  Created by py on 15/8/30.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  猜你喜欢

#import <UIKit/UIKit.h>
#import "NoteInfoModel.h"

@protocol AssumeYouLikeDelegate <NSObject>

@optional
- (void)noteClick:(NSString *)noteId withUserId:(NSString *)userId;


// 评论
- (void)CommentBtnClick:(NSString *)noteId withUserId:(NSString *)userId;

@end
@interface AssumeYouLike : UITableViewCell
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic ,strong)NoteInfoModel *NoteInfoModelFirst;
@property(nonatomic ,strong)NoteInfoModel *NoteInfoModelSec;
@property(nonatomic,weak)id<AssumeYouLikeDelegate> delegate;
@end
