//
//  NoteCommentView.h
//  FlashTag
//
//  Created by py on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteCommentModel;
@interface NoteCommentView : UITableViewCell

//@property(nonatomic ,weak)UILabel *allComment;
//@property(nonatomic,weak)UIImageView *iconImage;
//@property(nonatomic,weak)UILabel *userDisplayName;
//@property(nonatomic ,weak)UILabel *reply;
//@property(nonatomic ,weak)UILabel *targetUserName;
//@property(nonatomic ,weak)UILabel *commentTime;
//
//@property(nonatomic ,weak)UILabel *comment;
//@property(nonatomic,weak)UIView *bottomLine;
@property(nonatomic ,assign)BOOL isFirst;
@property(nonatomic ,strong)NoteCommentModel *commentModel;
//@property(nonatomic ,assign)BOOL isLast;
@end
