//
//  CameraBtn.m
//  FlashTag
//
//  Created by py on 15/9/24.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "CameraBtn.h"

@implementation CameraBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect  rect = CGRectMake(0, 0, contentRect.size.width - 12 *rateW - 5 *rateW, contentRect.size.height);
    return rect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    

    CGRect  rect = CGRectMake(contentRect.size.width - 12 *rateW - 5 *rateW, 0, 12 *rateW, contentRect.size.height);
    return rect;
}
@end
