//
//  NoteAddComment.h
//  FlashTag
//
//  Created by py on 15/8/30.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NoteAddCommentDelegate <NSObject>

@optional
-(void)addComment;

@end
@interface NoteAddComment : UITableViewCell

@property(nonatomic,weak)id <NoteAddCommentDelegate>delegate;
@end
