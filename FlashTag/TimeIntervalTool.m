//
//  TimeIntervalTool.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/1.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "TimeIntervalTool.h"

@implementation TimeIntervalTool

+ (NSString *)getTimeInterValToNowWithString:(NSString *)timeStr {
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000];
//    NSDate *nowDate = [NSDate date];
//    NSTimeInterval interval = [nowDate timeIntervalSinceDate:date];
    
//    if (interval <= 60) {
//        return @"刚刚";
//    } else if (interval <= 3600) {
//        NSString *str = [NSString stringWithFormat:@"%d分钟前",(int)interval / 60];
//        return str;
//    } else if (interval <= 3600 * 24) {
//        NSString *str = [NSString stringWithFormat:@"%d小时前", (int)interval / 3600];
//        return str;
//    } else if (interval <= 3600 * 24 * 10) {
//        NSString *str = [NSString stringWithFormat:@"%d天前", (int)interval / 3600 / 24];
//        return str;
//    } else {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//创建转换工具对象
//        [formatter setDateFormat:@"M月dd日HH:mm"];//指定转换日期的格式
//        NSString *dateStr = [formatter stringFromDate:date];
//        return dateStr;
//    }
    int interval = [timeStr intValue];
        if (interval <= 0) {
            return @"刚刚";
        } else if (interval <= 60) {
            NSString *str = [NSString stringWithFormat:@"%d分钟前",interval];
            return str;
        }else  if (interval <= 60*24) {
        NSString *str = [NSString stringWithFormat:@"%d小时前", interval/60];
        return str;
    } else {
        NSString *str = [NSString stringWithFormat:@"%d天前", (int)interval / 60 / 24];
        return str;
    }
}

+ (NSString *)getTimeInterVal:(NSString *)timeStr {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr integerValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//创建转换工具对象
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];//指定转换日期的格式
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}


@end
