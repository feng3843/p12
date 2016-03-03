//
//  NoteInfoModel.m
//  FlashTag
//
//  Created by 夏雪 on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NoteInfoModel.h"
#import "MJExtension.h"
@implementation NoteInfoModel

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"postTime"]) {
        if (oldValue == nil)   return @"";
        
        NSTimeInterval time=[oldValue doubleValue] ;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time / 1000];
        // NSLog(@"date:%@",[detaildate description]);
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        return currentDateStr;
        
        
        
    }
    return oldValue;
}
@end
