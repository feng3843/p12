//
//  NSDate+Extensions.m
//  YHT
//
//  Created by puyun on 15/2/13.
//  Copyright (c) 2015年 puyun. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate(NSDateExtensions)


-(NSString*)GetString_FormatString:(NSString*)formatstring
{
    NSDateFormatter* df= [[NSDateFormatter alloc]init];
    [df setDateFormat:formatstring];
    NSString* str= [df stringFromDate:self];
    return str;
}


-(NSDate*)addDays:(int)days Months:(int)months Years:(int)years
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:days];
    [comps setMonth:months];
    [comps setYear:years];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *mDate = [calendar dateByAddingComponents:comps toDate:self options:0];
    return mDate;
}

//添加天数
-(NSDate*)addDays:(int)days
{
    return [self addDays:days Months:0 Years:0];
}

//添加月数
-(NSDate*)addMonths:(int)months
{
    return [self addDays:0 Months:months Years:0];
}

//添加年数
-(NSDate*)addYears:(int)years
{
    return [self addDays:0 Months:0 Years:years];
}

-(NSDate*)addMinutes:(int)minutes Hours:(int)hours
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:hours];
    [comps setMinute:minutes];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *mDate = [calendar dateByAddingComponents:comps toDate:self options:0];
    return mDate;
}

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}
- (NSDate *)dateWithYMDHMS
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
