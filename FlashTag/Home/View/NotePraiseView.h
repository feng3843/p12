//
//  NotePraiseView.h
//  FlashTag
//
//  Created by py on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotePraiseView : UITableViewCell
/** 点赞数*/
@property(nonatomic ,strong)NSNumber *likes;
/** 评论数*/
@property(nonatomic ,strong)NSNumber *comments;
@property(nonatomic ,strong)NSMutableArray *notePraisedUser;
@end
