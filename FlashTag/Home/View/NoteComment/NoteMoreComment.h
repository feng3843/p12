//
//  NoteMoreComment.h
//  FlashTag
//
//  Created by py on 15/8/30.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteMoreCommentDelegate <NSObject>

@optional
/** 加载更多评论*/
- (void)LoadMoreComment;

@end
@interface NoteMoreComment : UITableViewCell{
    UIButton *moreBtn;
}
@property(nonatomic,weak)id<NoteMoreCommentDelegate> delegate;
-(void)setHidden4MoreBtn:(BOOL)hidden;
@end
