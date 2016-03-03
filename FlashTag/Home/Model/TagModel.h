//
//  TagModel.h
//  FlashTag
//
//  Created by py on 15/9/17.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//   标签模型

/**
 "tagName" : "音乐",
 "userId" : "78",
 "noteId" : "8"

 */
#import <Foundation/Foundation.h>

@interface TagModel : NSObject

@property(nonatomic,copy)NSString *tagName;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *noteId;
@end
