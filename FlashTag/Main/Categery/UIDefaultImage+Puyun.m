//
//  UITableView.m
//  FlashTag
//
//  Created by MingleFu on 15/9/29.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#define VIEW_TOP 64
#define VIEW_BOTTOM 44

#define TOP 46
#define JIAN 25

#define IMG_H 97
#define LABEL 15

//#define TOP_OFFSET 5
#define MIDDLE_OFFSET 5

#define LABEL_OFFSET 5

#define TAG 1000000

#import "UIDefaultImage+Puyun.h"
#import "UIView+AutoLayout.h"

@implementation UIImageView (Puyun)

-(void)showDefaultImage:(NSString*)imageName
{
    self.image = [UIImage imageNamed:imageName];
}

-(void)showImage:(NSString*)imagePath DefaultImage:(NSString*)defaultImage
{
    [self sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:defaultImage]];
}

@end

@implementation UIScrollView(Puyun)

-(void)showEmptyList:(NSArray*)array Image:(NSString*)imageName Desc:(NSString*)desc ByCSS:(NoDataCSS)css
{
    [self showEmptyListHaveData:(array&&array.count > 0) Image:imageName Desc:desc ByCSS:css];
}

-(void)showEmptyListHaveData:(BOOL)flag Image:(NSString*)imageName Desc:(NSString*)desc ByCSS:(NoDataCSS)css
{
    UIView* viewY = [self viewWithTag:TAG];
    
    if (viewY) {
        viewY.hidden = YES;
        [viewY removeFromSuperview];
        viewY = nil;
    }
    
    if (flag)
    {
        self.scrollEnabled = YES;
        return;
    }
    else
    {
        self.scrollEnabled = NO;
    }
    
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView* view = [[UIView alloc] init];
    bgView.tag = TAG;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    imageView.image = [UIImage imageNamed:imageName];
    label.text = desc;
    [view addSubview:imageView];
    [view addSubview:label];
    [bgView addSubview:view];
    [self addSubview:bgView];
    
    [bgView autoSetDimensionsToSize:CGSizeMake(CGRectGetWidth(self.frame), fDeviceHeight - VIEW_TOP -VIEW_BOTTOM - MIDDLE_OFFSET * 2)];
    [bgView autoCenterInSuperview];
    
    CGRect frame = label.frame;
    
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, -(CGRectGetWidth(frame) - IMG_H)/2, 0, -(CGRectGetWidth(frame) - IMG_H)/2) excludingEdge:ALEdgeBottom];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:JIAN];
    [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    switch (css) {
        case NoDataCSSTop:
        {
            //            imageView.frame = CGRectZero;
            [view autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView withOffset:TOP];
        }
            break;
        case NoDataCSSMiddle:
        default:
        {
            //            label.frame = CGRectZero;
            [view autoCenterInSuperview];
        }
            break;
    }
}

@end
