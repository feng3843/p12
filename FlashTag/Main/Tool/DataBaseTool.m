//
//  DataBaseTool.m
//  FlashTag
//
//  Created by py on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "DataBaseTool.h"
#import "FMDB.h"
@implementation DataBaseTool



static FMDatabase *_db;
+ (void)initialize
{
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"FlashTag.sqlite"];
    NSLog(@"%@",file);
    _db = [FMDatabase databaseWithPath:file];
    if (!_db.open)  return;
    // 创建表
    // 帖子表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_note_info(id integer PRIMARY KEY ,userId text not NULL, noteDesc text ,noteFristImage text not NULL,noteSecondImage text ,noteThirdImage text,noteFourImage text ,noteMark text ,noteMarkAttributes text,tags text ,imageCount integer not NULL)"];
   
}

/** 有mark的时候*/
+ (BOOL)addNotoInfo:(NSString *)noteId withImagePath:(NSString *)path withMarks:(NSString *)marks withMarkAttibutes:(NSString *)markAttributes IsInsert:(BOOL)isInsert
{
    NSString *newMark = nil;
    NSString *newMarkAttributes = nil;
    
    if (isInsert) {
        newMark =[NSString stringWithFormat:@"1:%@",marks];
        newMarkAttributes = [NSString stringWithFormat:@"1:%@",markAttributes];
        
        return  [_db executeUpdateWithFormat:@"INSERT INTO t_note_info(noteId,noteFristImage, noteMark,noteMarkAttributes,imageCount) VALUES(%@,%@,%@,%@,%d);",noteId,path,newMark,newMarkAttributes,1];
    }
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT imageCount,noteMark,noteMarkAttributes FROM t_note_info WHERE noteId = %@;",noteId];
    [set next];
    // 已经有第一张照片了
        NSString *oldMark = [set stringForColumn:@"noteMark"];
        NSString *oldMarkAttributes = [set stringForColumn:@"noteMarkAttributes"];

    if ([set intForColumn:@"imageCount"] == 1) {
        if (oldMark.length > 0) {
            newMark =[NSString stringWithFormat:@"%@,2:%@",oldMark,marks];
            newMarkAttributes = [NSString stringWithFormat:@"%@,2:%@",oldMarkAttributes,markAttributes];
        }else
        {
            newMark =[NSString stringWithFormat:@"2:%@",marks];
            newMarkAttributes = [NSString stringWithFormat:@"2:%@",markAttributes];

        }
        
        return [_db executeUpdateWithFormat:@"UPDATE t_note_info SET noteSecondImage = %@ ,noteMark = %@, noteMarkAttributes = %@ ,imageCount = %d where noteId = %@",path,newMark, newMarkAttributes ,2,noteId];
    }else if ([set intForColumn:@"imageCount"] == 2 )
    {
        if (oldMark.length > 0) {
            newMark =[NSString stringWithFormat:@"%@,3:%@",oldMark,marks];
            newMarkAttributes = [NSString stringWithFormat:@"%@,3:%@",oldMarkAttributes,markAttributes];
        }else
        {
            newMark =[NSString stringWithFormat:@"3:%@",marks];
            newMarkAttributes = [NSString stringWithFormat:@"3:%@",markAttributes];
            
        }
        return [_db executeUpdateWithFormat:@"UPDATE t_note_info SET noteThirdImage = %@ ,noteMark = %@, noteMarkAttributes = %@ ,imageCount = %d where noteId = %@",path,newMark, newMarkAttributes ,3,noteId];
    }
        if (oldMark.length > 0) {
        newMark =[NSString stringWithFormat:@"%@,4:%@",oldMark,marks];
        newMarkAttributes = [NSString stringWithFormat:@"%@,4:%@",oldMarkAttributes,markAttributes];
    }else
    {
        newMark =[NSString stringWithFormat:@"4:%@",marks];
        newMarkAttributes = [NSString stringWithFormat:@"4:%@",markAttributes];
        
    }
        return [_db executeUpdateWithFormat:@"UPDATE t_note_info SET noteFourImage = %@ ,noteMark = %@, noteMarkAttributes = %@ ,imageCount = %d where noteId = %@",path,newMark, newMarkAttributes ,4,noteId];
    

}

///** 没有mark的时候*/
//+ (BOOL)addNotoInfo:(NSString *)noteId withImagePath:(NSString *)path  IsInsert:(BOOL)isInsert
//{
// 
//    
//    if (isInsert) {
//        
//        return  [_db executeUpdateWithFormat:@"INSERT INTO t_note_info(noteId,noteFristImage, imageCount) VALUES(%@,%@,%d);",noteId,path,1];
//    }
//    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT imageCount FROM t_note_info WHERE noteId = %@;",noteId];
//    [set next];
//    // 已经有第一张照片了
//    
//    if ([set intForColumn:@"imageCount"] == 1) {
//      
//        
//        return [_db executeUpdateWithFormat:@"UPDATE t_note_info SET noteSecondImage = %@ ,imageCount = %d where noteId = %@",path ,2,noteId];
//    }else if ([set intForColumn:@"imageCount"] == 2 )
//    {
//      
//        return [_db executeUpdateWithFormat:@"UPDATE t_note_info SET noteThirdImage = %@  ,imageCount = %d where noteId = %@",path,3,noteId];
//    }
//   
//    return [_db executeUpdateWithFormat:@"UPDATE t_note_info SET noteFourImage = %@ ,imageCount = %d where noteId = %@",path,4,noteId];
//}

+(NSArray *)getNoteIofo:(NSString *)noteId
{
    
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT noteDesc, noteFristImage,noteSecondImage,noteThirdImage,noteFourImage,noteMark,noteMarkAttributes,tags FROM t_note_info WHERE noteId = %@;",noteId];
    [set next];
    NSMutableArray *resultArray = [NSMutableArray array];
    [resultArray addObject:[set stringForColumn:@"noteDesc"] == nil?@"":[set stringForColumn:@"noteDesc"]];
    [resultArray addObject:[set stringForColumn:@"noteFristImage"] == nil?@"":[set stringForColumn:@"noteFristImage"]];
    [resultArray addObject:[set stringForColumn:@"noteSecondImage"] == nil?@"":[set stringForColumn:@"noteSecondImage"]];
    [resultArray addObject:[set stringForColumn:@"noteThirdImage"] == nil?@"":[set stringForColumn:@"noteThirdImage"]];
    [resultArray addObject:[set stringForColumn:@"noteFourImage"] == nil?@"":[set stringForColumn:@"noteFourImage"]];
    [resultArray addObject:[set stringForColumn:@"noteMark"] == nil?@"":[set stringForColumn:@"noteMark"]];
    [resultArray addObject:[set stringForColumn:@"noteMarkAttributes"] == nil?@"":[set stringForColumn:@"noteMarkAttributes"]];
      [resultArray addObject:[set stringForColumn:@"tags"] == nil?@"":[set stringForColumn:@"tags"]];
    return resultArray;
    
}
@end
