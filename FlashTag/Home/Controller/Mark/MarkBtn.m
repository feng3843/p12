//
//  MarkBtn.m
//  FlashTag
//
//  Created by py on 15/9/24.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "MarkBtn.h"

@implementation MarkBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
      return CGRectMake(0,37*rateH, contentRect.size.width, contentRect.size.height -  32 *rateH);

}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
     return CGRectMake((contentRect.size.width - 32 *rateH) * 0.5, 0, 32 *rateH, 32 *rateH);
}
@end
