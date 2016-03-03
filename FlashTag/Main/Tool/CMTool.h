//
//  CMTool.h
//  CM
//
//  Created by 付晨鸣 on 14/12/23.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MD5.h"

@interface CMTool : NSObject

#pragma mark 获取数据
+ (NSString*)getIdByTimeStamp;
+ (NSString*)currentTimeStamp;
+ (NSString*)getBranceVersion;

//获取设备型号
+ (NSString*) doDevicePlatform;
+ (MFMailComposeViewController*) getEmailSign:(NSString*)email NeedSign:(BOOL)needSign;
// 获取时间范围
+ (NSString*) dateScopeFrom:(NSString*) dateStrFrom DateTo:(NSString*) dateStrTo;
+ (NSString*) dateScopeFrom2:(NSString*) dateStrFrom DateTo:(NSString*) dateStrTo;
//获取时间范围的头与尾
+ (NSDate*) dateScopeFrom:(NSString*)dateStr DateFormatter:(NSString*) dateFormatter;
+ (NSDate*) dateScopeTo:(NSString*)dateStr DateFormatter:(NSString*) dateFormatter;

+ (UIImage*)setImageFileName:(NSString*)fileName ImageCate:(NSString*)imageCate;
+ (void)setImageUrl:(NSString*)url ByImageName:(NSString*)imageName InImageView:(UIImageView*)imageView ImageCate:(NSString*)imageCate completed:(void(^)(UIImage *image,NSString* strImageName)) completed;
// 异步加载图片
+ (void)setImage:(UIImageView*)imageView FileName:(NSString*)fileName ImageCate:(NSString*)imageCate ImageUrl:(NSString*)imageUrl;
#pragma mark Duplicate
+ (id)duplicate:(id)view;

#pragma mark 数据验证
//验证手机
+ (BOOL) validateTel: (NSString *) candidate;
//验证邮箱
+ (BOOL) validateEmail: (NSString *) candidate;
//判断网络连接状态
+(BOOL) isConnectionAvailable;

#pragma mark 数据格式转换

// 把时间从字符串转成NSDate类型
+ (NSDate*)dateWithDateString:(NSString*)dateStr;

// 把时间转成离当前时间的相对时间
//+ (NSString*)timeAgoWithDateString:(NSString*)dateStr;

// 把时间从字符串转成NSDate类型
+ (NSDate*)dateWithDateDetailLongString:(NSString*)dateStr;

// 把时间转成离当前时间的相对时间
//+ (NSString*)timeAgoWithDateDetailLongString:(NSString*)dateStr;

// 把时间从格式From转成格式To
+ (NSString*) dateStringToOtherDateString:(NSString*)dateStr DateFormatterFrom:(NSString*) from DateFormatterTo:(NSString*) to;


//字典与字符串之间的转换
+ (NSString*) dic2str:(NSDictionary*) dic;
+ (NSDictionary*) str2dic:(NSString*) str;

#pragma mark 重新计算UITextView高度
+ (CGFloat) reflushContentView:(UITextView*)textView;
#pragma mark 重新计算UIButton高度
+ (CGFloat) reflushContentButton:(UIButton*)button;
#pragma mark 重新计算UILabel高度
+ (CGFloat) reflushContentLabel:(UILabel*)label;

+ (NSUInteger)numberOfLinesOfText:(NSString*) text;

#pragma mark CALL
+ (void) callPhoneNumber:(NSString*) phoneNUmber;

+ (NSString *)logDic:(NSDictionary *)dic;
//截屏
+(UIImage*)screenShots;



//+(void) removeRedPointAtTabItem:(int)tabitemIndex InTabNums:(int)tabitemNum;

- (UIImage *)accelerateBlurWithImage:(UIImage *)image;

+ (NSArray*)getRefreshingImages;

+(void)moveAnimationInSuperView:(UIView*)superView ShowTime:(CGFloat)showTime MoveTime:(CGFloat)moveTime;
+ (BOOL)stringContainsEmoji:(NSString *)string;
@end
