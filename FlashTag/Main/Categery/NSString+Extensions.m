//
//  NSString+Extensions.m
//  YHT
//
//  Created by puyun on 15/2/12.
//  Copyright (c) 2015年 puyun. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString(NSStringExtensions)


-(NSArray*)Matchs_Left:(NSString*)left Right:(NSString*)right
{
    NSString *regexstr=[NSString stringWithFormat:@"(?<=%@)(.|[\\r\\n])*?(?=%@)",left,right];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexstr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* arr=[regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    return arr;
}

-(NSString*)Match_Left:(NSString*)left Right:(NSString*)right
{
    NSArray * array=[self Matchs_Left:left Right:right];
    if(array.count>0)
    {
        return [self substringWithRange:((NSTextCheckingResult*)array[0]).range];
    }
    else
        return @"";
}

-(NSDate*)GetDate_FormatString:(NSString*)formatstring
{
    NSDateFormatter *df =[[NSDateFormatter alloc]init];
    [df setDateFormat:formatstring];
    NSTimeZone* GTMzone=[NSTimeZone timeZoneForSecondsFromGMT:0];
    [df setTimeZone:GTMzone];
    NSDate*date;
    date =[df dateFromString:self];
    return date;
}


//截取字符串 left<=0?从右边开始截取 right<=0?截取左边
-(NSString*)Subs_Left:(int)left Right:(int)right
{
//    if((left<=0&&right<=0)||(left>0&&right>0))
//    {
//        left=left;
//        right=right;
//    }
    if(left<=0&&right>0)
    {
        left=[self length]-right;
        right=right;
    }
    if(left>0&&right<=0)
    {
        right=left;
        left=0;
    }
    NSRange range=NSMakeRange(left,right);
    NSString* result=[self substringWithRange:range];
    return result;
}

//截取左边长度字符
-(NSString*)SubsLeft:(int)ct
{
    return [self Subs_Left:ct Right:0];
}

//截取右边长度字符
-(NSString*)SubsRight:(int)ct
{
    return [self Subs_Left:0 Right:ct];
}

//从哪截取到哪
-(NSString*)Subs_From:(int)left To:(int)right
{
    return [self Subs_Left:left Right:right];
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
-(NSDictionary *)GetDictionary
{
    if (self != nil) {
        NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic =nil;
        
        dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingMutableContainers
                                                error:&err];
        
        return dic;
        
    }
    else
    {
        return nil;
    }
}





-(NSString*)test
{
    return @"LA扩展方法测试";
}

-(NSString *)get2Subs
{
    int userIDInt = [self intValue];
    NSString *userID = [NSString stringWithFormat:@"%02d", userIDInt];
    
    NSString *userId = [userID SubsRight:2];
    return userId;
}

@end
