//
//  UIView+Extension.m
//  SeaAmoy
//
//  Created by 夏雪 on 15/8/26.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "UIView+Extension.h"
#import "SDImageView+SDWebCache.h"

@implementation UIView (Extension)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{ 
    return self.frame.origin;
}
@end

@implementation UIImageView (Extension)

- (void)getGSImageWithDegree:(CGFloat)degree
{
    [self getGSImageWithDegree:degree ByUserId:[CMData getUserId]];
}

- (void)getGSImageWithDegree:(CGFloat)degree ByUserId:(NSString*)userId
{
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , userId]]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            image = [UIImage imageNamed:@"img_default_me_user"];
        }
        CIContext *context = [CIContext contextWithOptions:nil];
        //        CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
        CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
        // create gaussian blur filter
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:degree] forKey:@"inputRadius"];
        // blur image
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        self.image = [UIImage imageWithCGImage:cgImage];
    }];
}

@end
