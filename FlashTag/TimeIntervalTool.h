//
//  TimeIntervalTool.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/1.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TimeIntervalTool : NSObject

+ (NSString *)getTimeInterValToNowWithString:(NSString *)timeStr;

+ (NSString *)getTimeInterVal:(NSString *)timeStr;

@end
