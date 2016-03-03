//
//  NSDate+Extensions.h
//  YHT
//
//  Created by puyun on 15/2/13.
//  Copyright (c) 2015年 puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(NSDateExtensions)


-(NSString*)GetString_FormatString:(NSString*)formatstring;
//添加天、月、年
-(NSDate*)addDays:(int)days Months:(int)months Years:(int)years;
//添加天数
-(NSDate*)addDays:(int)days;
//添加月数
-(NSDate*)addMonths:(int)months;
//添加年数
-(NSDate*)addYears:(int)years;

-(NSDate*)addMinutes:(int)minutes Hours:(int)hours;

/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;
- (NSDate *)dateWithYMDHMS;
/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

@end
