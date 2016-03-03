//
//  UIImage+Extensions.h
//  NewCut
//
//  Created by 夏雪 on 15/7/17.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

/** 根据颜色画图片*/
+ (UIImage *)imageWithColor:(UIColor *)color ;

/** 保存图片*/
+ (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath ;

/** 加载图片*/
+ (UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath ;

/** 将图片裁剪成圆形的*/
+ (UIImage *)clipImageToRoundImage:(UIImage *)oldImage;
+ (UIImage *)clipImage:(UIImage *)oldImage bound:(CGFloat)magain;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
