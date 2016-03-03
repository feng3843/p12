//
//  ScrollCountryView.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/7.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollCountryView : UIScrollView

@property (nonatomic, assign) CGFloat buttonCount;
@property (nonatomic, strong) NSMutableArray *buttons;

- (instancetype)initWithFrame:(CGRect)frame withCount:(CGFloat)buttonCount;

@end
