//
//  UITextField+ExtentRange.h
//  CM
//
//  Created by 付晨鸣 on 15/3/28.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;

@end
