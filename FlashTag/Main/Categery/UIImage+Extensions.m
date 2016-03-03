//
//  UIImage+Extensions.m
//  NewCut
//
//  Created by 夏雪 on 15/7/17.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation UIImage (Extensions)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

 + (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}


+ (UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

/** 将图片裁剪成圆形的*/
+ (UIImage *)clipImageToRoundImage:(UIImage *)oldImage
{
    
    CGSize newSize = oldImage.size;
    UIImage *tempImage = [UIImage scaleToSize:oldImage size:newSize];
 
     //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    
    
    CGRect circleRect = CGRectMake(0, 0, newSize.width, newSize.height);
    CGContextAddEllipseInRect(ctf, circleRect);
    
    CGContextClip(ctf);
    
    [tempImage drawInRect:circleRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片上下文
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 图片裁截(有外环)
 */
+ (UIImage *)clipImage:(UIImage *)oldImage bound:(CGFloat)magain
{
   
    
    CGSize oldSize = oldImage.size;
    CGSize newSize = CGSizeMake((oldSize.width + 2 * magain), (oldSize.height + 2 * magain));
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    
    CGFloat cicleRadius = oldSize.height * 0.5 + magain;
    CGContextAddArc(ctf, cicleRadius, cicleRadius, cicleRadius, 0, M_PI *2, 0);
    CGContextFillPath(ctf);
    
    CGFloat radius = oldSize.height * 0.5;
    CGContextAddArc(ctf, cicleRadius, cicleRadius, radius, 0, M_PI *2, 0);
    
    CGContextClip(ctf);
    
    CGPoint point = {magain,magain};
    [oldImage drawAtPoint:point];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height *0.5];
}

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
@end
