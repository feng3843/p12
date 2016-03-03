//
//  NoteInfoView.h
//  SeaAmoy
//
//  Created by 夏雪 on 15/8/27.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//   帖子信息

#import <UIKit/UIKit.h>
#import "NoteInfoModel.h"

typedef enum {
    HomeCellTypeMiddleBottom,//首页 关注 cell
    HomeCellTypeTopMiddleBottom//首页 发现 cell
}HomeCellType;

@protocol NoteInfoViewDelegate <NSObject>
@optional
-(void)CommentBtnClick:(NSString *)noteId withUserId:(NSString *)userId;
-(void)moreBtnClick:(NoteInfoModel*)model;
@end
@interface NoteInfoView : UITableViewCell
@property(nonatomic ,strong)NoteInfoModel *model;
@property(nonatomic,weak)id<NoteInfoViewDelegate> delegate;
@property (nonatomic) HomeCellType type;
@end
