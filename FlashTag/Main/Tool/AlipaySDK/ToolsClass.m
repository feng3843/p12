//
//  ToolsClass.m
//  FlashTag
//
//  Created by uncommon on 2015/10/08.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import "ToolsClass.h"

@implementation ToolsClass

//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+(BOOL)isPureNumber:(NSString*)string{
    return ([self isPureInt:string] || [self isPureFloat:string]);
}

@end
