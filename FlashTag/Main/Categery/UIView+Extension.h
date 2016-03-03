//
//  UIView+Extension.h
//  SeaAmoy
//
//  Created by 夏雪 on 15/8/26.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@end

@interface UIImageView (Extension)

- (void)getGSImageWithDegree:(CGFloat)degree;

- (void)getGSImageWithDegree:(CGFloat)degree ByUserId:(NSString*)userId;

@end