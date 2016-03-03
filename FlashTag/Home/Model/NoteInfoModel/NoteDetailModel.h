//
//  NoteDetailModel.h
//  FlashTag
//
//  Created by py on 15/9/21.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NoteInfoModel.h"

@interface NoteDetailModel : NoteInfoModel

@property(nonatomic,copy)NSString *marks;
@property(nonatomic,copy)NSString *markAttribute;
@property(nonatomic,assign)BOOL isCollect;
@property(nonatomic,copy)NSString *role;
@end
