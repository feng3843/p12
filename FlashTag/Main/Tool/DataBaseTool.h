//
//  DataBaseTool.h
//  FlashTag
//
//  Created by py on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  

#import <Foundation/Foundation.h>

@interface DataBaseTool : NSObject
/** 有mark的时候*/
+ (BOOL)addNotoInfo:(NSString *)noteId withImagePath:(NSString *)path withMarks:(NSString *)marks withMarkAttibutes:(NSString *)markAttributes IsInsert:(BOOL)isInsert;
///** 没有mark的时候*/
//+ (BOOL)addNotoInfo:(NSString *)noteId withImagePath:(NSString *)path  IsInsert:(BOOL)isInsert;
+(NSArray *)getNoteIofo:(NSString *)noteId;
@end
