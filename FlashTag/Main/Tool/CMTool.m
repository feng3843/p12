//
//  CMTool.m
//  CM
//
//  Created by 付晨鸣 on 14/12/23.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import "CMTool.h"
#import "CMAPI.h"
#import "UIImageView+WebCache.h"
#include "sys/types.h"
#include "sys/sysctl.h"
#import "Base64.h"
#import "UIColor+Extensions.h"

#import "AppDelegate.h"

#import "PYAllCommon.h"
#import <Accelerate/Accelerate.h>
#import "UIView+AutoLayout.h"

@implementation CMTool

+ (NSString*)getIdByTimeStamp{
    NSDate *date = [NSDate date];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss,SSS"];
    NSString* dateStr = [dateFormat stringFromDate:date];

    return [dateStr MD5EncodedString];
}

+ (NSString*)currentTimeStamp{
    NSDate *date = [NSDate date];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    NSString* dateStr = [dateFormat stringFromDate:date];

    return dateStr;
}
+ (NSString*)getBranceVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BranceVersion"];
}

+ (NSString*) doDevicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);

    if ([platform isEqualToString:@"iPhone1,1"]) {

        platform = @"iPhone";

    } else if ([platform isEqualToString:@"iPhone1,2"]) {

        platform = @"iPhone 3G";

    } else if ([platform isEqualToString:@"iPhone2,1"]) {

        platform = @"iPhone 3GS";

    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {

        platform = @"iPhone 4";

    } else if ([platform isEqualToString:@"iPhone4,1"]) {

        platform = @"iPhone 4S";

    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {

        platform = @"iPhone 5";

    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {

        platform = @"iPhone 5C";

    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {

        platform = @"iPhone 5S";

    }else if ([platform isEqualToString:@"iPod4,1"]) {

        platform = @"iPod touch 4";

    }else if ([platform isEqualToString:@"iPod5,1"]) {

        platform = @"iPod touch 5";

    }else if ([platform isEqualToString:@"iPod3,1"]) {

        platform = @"iPod touch 3";

    }else if ([platform isEqualToString:@"iPod2,1"]) {

        platform = @"iPod touch 2";

    }else if ([platform isEqualToString:@"iPod1,1"]) {

        platform = @"iPod touch";

    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {

        platform = @"iPad 3";

    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {

        platform = @"iPad 2";

    }else if ([platform isEqualToString:@"iPad1,1"]) {

        platform = @"iPad 1";

    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {

        platform = @"ipad mini";
        
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        
        platform = @"ipad 3";
        
    }
    
    return platform;
}

+ (MFMailComposeViewController*) getEmailSign:(NSString*)email NeedSign:(BOOL)needSign
{
    MFMailComposeViewController* mailViewController = [[MFMailComposeViewController alloc] init];
    [mailViewController setToRecipients:[[NSArray alloc]initWithObjects:email, nil]];

    [mailViewController setSubject:@""];
    NSString *strMessage = nil;
    if(needSign)
    {
        NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        NSString* appIntro = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppIntro"];
        NSString* appDownloadPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppDownloadPath"];

        strMessage = @"<br><br><p>本邮件通过‘%@’APP发送</p><p>----------------------------------</p>\
        <p>%@</p>\
        <p><img src='data:image/png;base64,%@'><a href='%@'>去AppStore下载</a></p>";
        UIImage *appicon = [UIImage imageNamed:@"noBound"];
        NSData *imageData = UIImagePNGRepresentation(appicon);
        strMessage = [NSString stringWithFormat:strMessage,appName,appIntro,[imageData base64EncodedString],appDownloadPath];
    }
    else
    {
        strMessage = @"";
    }

    [mailViewController setMessageBody:strMessage isHTML:YES];

    mailViewController.navigationBar.tintColor = [UIColor colorWithHexString:@"09bb07"];
    return mailViewController;
}

// 获取时间范围
+ (NSString*) dateScopeFrom:(NSString*) dateStrFrom DateTo:(NSString*) dateStrTo
{
    NSString* fromDate = [CMTool dateStringToOtherDateString:dateStrFrom DateFormatterFrom:@"yyyy-MM-dd hh:mm:ss" DateFormatterTo:@"yyyy.M.d"];
    NSString* toDate = [CMTool dateStringToOtherDateString:dateStrFrom DateFormatterFrom:@"yyyy-MM-dd hh:mm:ss" DateFormatterTo:@"yyyy.M.d"];
    if (fromDate&&[fromDate isEqualToString:toDate]) {
        return [NSString stringWithFormat:@"%@-%@",[CMTool dateStringToOtherDateString:dateStrFrom DateFormatterFrom:@"yyyy-MM-dd hh:mm:ss" DateFormatterTo:@"yyyy.M.d hh:mm"],[CMTool dateStringToOtherDateString:dateStrTo DateFormatterFrom:@"yyyy-MM-dd hh:mm:ss" DateFormatterTo:@"hh:mm"]];
    }else{
        return [NSString stringWithFormat:@"%@-%@",[CMTool dateStringToOtherDateString:dateStrFrom DateFormatterFrom:@"yyyy-MM-dd hh:mm:ss" DateFormatterTo:@"yyyy.M.d hh:mm"],[CMTool dateStringToOtherDateString:dateStrTo DateFormatterFrom:@"yyyy-MM-dd hh:mm:ss" DateFormatterTo:@"yyyy.M.d hh:mm"]];
    }
}
+ (NSString*) dateScopeFrom2:(NSString*) dateStrFrom DateTo:(NSString*) dateStrTo
{
    return [NSString stringWithFormat:@"%@——%@",[CMTool dateStringToOtherDateString:dateStrFrom DateFormatterFrom:@"yyyy-MM-dd" DateFormatterTo:@"yyyy/M/d"],[CMTool dateStringToOtherDateString:dateStrTo DateFormatterFrom:@"yyyy-MM-dd" DateFormatterTo:@"yyyy/M/d"]];

}

+ (NSDate*) dateScopeFrom:(NSString*)dateStr DateFormatter:(NSString*) dateFormatter
{
    NSArray* array = [dateStr componentsSeparatedByString:@"——"];
    if(array.count <1){
        return nil;
    }
    NSDateFormatter* dateFormatterFrom = [[NSDateFormatter alloc] init];
    [dateFormatterFrom setDateFormat:dateFormatter];
    return [dateFormatterFrom dateFromString:[array objectAtIndex:0]];
}

+ (NSDate*) dateScopeTo:(NSString*)dateStr DateFormatter:(NSString*) dateFormatter
{
    NSArray* array = [dateStr componentsSeparatedByString:@"——"];
    if(array.count <1){
        return nil;
    }
    NSDateFormatter* dateFormatterTo = [[NSDateFormatter alloc] init];
    [dateFormatterTo setDateFormat:dateFormatter];
    return [dateFormatterTo dateFromString:[array objectAtIndex:1]];
}

+(UIImage*)setImageFileName:(NSString*)fileName ImageCate:(NSString*)imageCate
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
    BOOL isDirectory = YES;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!isDirectory&&fileExists)
    {
        return [UIImage imageWithContentsOfFile:filePath];
    }
    else
    {
        return [UIImage imageNamed:imageCate];
    }
}


+ (void)setImageUrl:(NSString*)url ByImageName:(NSString*)imageName InImageView:(UIImageView*)imageView ImageCate:(NSString*)imageCate completed:(void(^)(UIImage *image,NSString* strImageName))completed
{
//    [imageView setImage:[UIImage imageNamed:imageCate]];
//    
//    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_LOADING] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//        if(image){
//            //DDLogVerbose(@"图片加载成功！");
//            completed(image,imageName);
//        }else{
//           // DDLogVerbose(@"图片加载失败：%@",error);
//            completed([UIImage imageNamed:imageCate],imageName);
//        }
//    }];
}

+(void)setImage:(UIImageView*) imageView FileName:(NSString*)fileName ImageCate:(NSString*)imageCate ImageUrl:(NSString*)imageUrl
{
//    [imageView setImage:[UIImage imageNamed:DEFAULT_IMAGE_LOADING]];
//
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
//    BOOL isDirectory = YES;
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
//    if (!isDirectory&&fileExists)
//    {
//        imageView.image = [UIImage imageWithContentsOfFile:filePath];
//    }
//    else
//    {
//        if (fileName && ![@"" isEqualToString:fileName])
//        {
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",CMRES_BaseURL,imageUrl, fileName]] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_LOADING] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//                if(image){
//                   // DDLogVerbose(@"图片加载成功！");
//                    NSData *imageData = UIImageJPEGRepresentation(image, 100);
//                    [imageData writeToFile:filePath atomically:YES];
//                }else{
//                   // DDLogVerbose(@"图片加载失败：%@",error);
//                    [imageView setImage:[UIImage imageNamed:imageCate]];
//                }
//            }];
//        }
//        else{
//            imageView.image = [UIImage imageNamed:imageCate];
//        }
//    }
}

// Duplicate UIView
+ (id)duplicate:(id)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

+ (BOOL) validateTel: (NSString *) candidate
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:candidate] == YES)
        || ([regextestcm evaluateWithObject:candidate] == YES)
        || ([regextestct evaluateWithObject:candidate] == YES)
        || ([regextestcu evaluateWithObject:candidate] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}

+ (NSDate*)dateWithDateString:(NSString*)dateStr
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];

    // This is for check the output
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"]; // Here you can change your require output date format EX. @"EEE, MMM d YYYY"
    //    dateStr = [dateFormat stringFromDate:date];

    return date;
}

//+ (NSString*)timeAgoWithDateString:(NSString*)dateStr
//{
//    NSDate *date = [self dateWithDateString:dateStr];
//
//    return [date timeAgo];
//}
+ (NSDate*)dateWithDateDetailLongString:(NSString*)dateStr
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date = [dateFormat dateFromString:dateStr];

    // This is for check the output
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"]; // Here you can change your require output date format EX. @"EEE, MMM d YYYY"
    //    dateStr = [dateFormat stringFromDate:date];

    return date;
}

//+ (NSString*)timeAgoWithDateDetailLongString:(NSString*)dateStr
//{
//    NSDate *date = [self dateWithDateDetailLongString:dateStr];
//
//    return [date timeAgo];
//}

// 把时间从格式From转成格式To
+ (NSString*) dateStringToOtherDateString:(NSString*)dateStr DateFormatterFrom:(NSString *)from DateFormatterTo:(NSString *)to;
{
    NSDateFormatter* dateFormatterFrom = [[NSDateFormatter alloc] init];
    NSDateFormatter* dateFormatterTo = [[NSDateFormatter alloc] init];
    [dateFormatterFrom setDateFormat:from];
    [dateFormatterTo setDateFormat:to];
    return [dateFormatterTo stringFromDate:[dateFormatterFrom dateFromString:dateStr]];
}

+ (NSString*) dic2str:(NSDictionary*) dic
{
    //NSDictionary转换为Data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //Data转换为JSON
    NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}
+ (NSDictionary*) str2dic:(NSString*) str
{
    if (!str||[@"" isEqualToString:str]) {
        return nil;
    }
    NSData* resultData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingAllowFragments error:nil];
    return  resultDic;
}

+ (CGFloat) reflushContentView:(UITextView*)textView
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineHeightMultiple = 20.f;
    paragraphStyle.maximumLineHeight = 25.f;
    paragraphStyle.minimumLineHeight = 15.f;
    //    paragraphStyle.firstLineHeadIndent = 25.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;

    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:76./255. green:75./255. blue:71./255. alpha:1]
                                  };
    textView.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:attributes];

    NSString* content = textView.text;
    UIFont* font = textView.font;
    if(!font)
    {
        font = [UIFont systemFontOfSize:15];
    }
    //根据字体来确定内容的最大高度
    CGSize sizeToFit = [content sizeWithFont:font constrainedToSize:CGSizeMake(textView.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat contentheight = (float)sizeToFit.height * 1.7;

//    CGRect rect = [content boundingRectWithSize:CGSizeMake(textView.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    //设置内容显示控件高度
    CGRect contentFrame = textView.frame;
    contentFrame.size.height = contentheight > contentFrame.size.height? contentheight: contentFrame.size.height;

    textView.translatesAutoresizingMaskIntoConstraints = YES;
    [textView setFrame:contentFrame];
    textView.font = [UIFont systemFontOfSize:15];

    [textView setNeedsLayout];
    return contentFrame.size.height;
}

+ (CGFloat) reflushContentLabel:(UILabel*)label
{
    NSString* string = label.text;
    UIFont* font = label.font;
    UIColor* color = label.textColor;
    CGRect frame = label.frame;
    if(!string)
    {
        string = @"";
    }
    if(!font)
    {
        font = [UIFont systemFontOfSize:15];
    }

    [label setNumberOfLines:0];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];

    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:allRange];

//    NSRange destRange = [string rangeOfString:tagStr];
//    [attrStr addAttribute:NSForegroundColorAttributeName
//                    value:HEXCOLOR(0x009cdd)
//                    range:destRange];

    CGFloat titleHeight;
//    NSUInteger lines = [self numberOfLinesOfText:string];
//    titleHeight = lines*22;
//    [label setNumberOfLines:lines];
//    frame.size.height = titleHeight+2;
//    [label setFrame:frame];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    titleHeight = ceilf(rect.size.height)+2;
    frame.size.height = titleHeight;
    [label setFrame:frame];
    return titleHeight;
}

+ (CGFloat) reflushContentButton:(UIButton*)button
{
    NSString* string = button.titleLabel.text;
    UIFont* font = button.titleLabel.font;
    UIColor* color = button.titleLabel.textColor;
    CGRect frame = button.titleLabel.frame;
    if(!font)
    {
        font = [UIFont systemFontOfSize:15];
    }

    [button.titleLabel setNumberOfLines:1];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];

    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:allRange];

    //    NSRange destRange = [string rangeOfString:tagStr];
    //    [attrStr addAttribute:NSForegroundColorAttributeName
    //                    value:HEXCOLOR(0x009cdd)
    //                    range:destRange];

    CGFloat titleWidth;
    //    NSUInteger lines = [self numberOfLinesOfText:string];
    //    titleHeight = lines*22;
    //    [label setNumberOfLines:lines];
    //    frame.size.height = titleHeight+2;
    //    [label setFrame:frame];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    titleWidth = ceilf(labelsize.width)*1.1;
    labelsize.width = titleWidth;
    frame.size = labelsize;
    button.translatesAutoresizingMaskIntoConstraints = YES;
    [button setFrame:frame];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return titleWidth;
}

#pragma mark - Message text

+ (NSUInteger)maxCharactersPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 13 : 109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text
{
    return (text.length / [self maxCharactersPerLine]) + 1;
}

+ (NSUInteger)numberOfLinesOfText:(NSString*) text
{
    return [self numberOfLinesForMessage:text];
}

+ (void) callPhoneNumber:(NSString*) phoneNUmber
{
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNUmber]]];
}



+(UIImage*)screenShots
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }

    CGContextRef context = UIGraphicsGetCurrentContext();

    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];

            CGContextRestoreGState(context);
        }
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    //    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);

    return image;
}

//判断网络连接状态
+(BOOL) isConnectionAvailable
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"www.baidu.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    } else {
        return TRUE;
    }
}
// log NSSet with UTF8
// if not ,log will be \Uxxx
+ (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

//#pragma mark RED_POINT
//+(void) removeRedPointAtTabItem:(int)tabitemIndex InTabNums:(int)tabitemNum
//{
//    UITabBarController *tabBarController = (UITabBarController*)[[[UIApplication sharedApplication] delegate] window].rootViewController.presentedViewController;
//    UITabBar *tabBar = tabBarController.tabBar;
//    UIView* redP = nil;
//    //X：tabitemIndex*SCREEN_WIDTH/tabitemNum+DEFAULT_TABITEM_ADD_X*SCREEN_WIDTH/tabitemNum/DEFAULT_TABITEM_WIDTH
//    //X*tabitemNum*DEFAULT_TABITEM_WIDTH-DEFAULT_TABITEM_ADD_X*SCREEN_WIDTH：tabitemIndex*SCREEN_WIDTH*DEFAULT_TABITEM_WIDTH
//    for (UIView* view in tabBar.subviews) {
//        if ([view isKindOfClass:[PYRedPoint class]]) {
//            CGFloat x = view.frame.origin.x;
//            int tabIndex = (x*DEFAULT_TABITEM_WIDTH*tabitemNum - DEFAULT_TABITEM_ADD_X*SCREEN_WIDTH)/SCREEN_WIDTH/DEFAULT_TABITEM_WIDTH;
//            if (tabitemIndex == tabIndex) {
//                redP = view;
//                break;
//            }
//        }
//    }
//    [redP removeFromSuperview];
//}

- (UIImage *)accelerateBlurWithImage:(UIImage *)image
{
    NSInteger boxSize = (NSInteger)(10 * 5);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer, rgbOutBuffer;
    vImage_Error error;
    
    void *pixelBuffer, *convertBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    convertBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    rgbOutBuffer.width = CGImageGetWidth(img);
    rgbOutBuffer.height = CGImageGetHeight(img);
    rgbOutBuffer.rowBytes = CGImageGetBytesPerRow(img);
    rgbOutBuffer.data = convertBuffer;
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    
    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    void *rgbConvertBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    vImage_Buffer outRGBBuffer;
    outRGBBuffer.width = CGImageGetWidth(img);
    outRGBBuffer.height = CGImageGetHeight(img);
    outRGBBuffer.rowBytes = 3;
    outRGBBuffer.data = rgbConvertBuffer;
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    const uint8_t mask[] = {2, 1, 0, 3};
    
    vImagePermuteChannels_ARGB8888(&outBuffer, &rgbOutBuffer, mask, kvImageNoFlags);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(rgbOutBuffer.data,
                                             rgbOutBuffer.width,
                                             rgbOutBuffer.height,
                                             8,
                                             rgbOutBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    
    free(pixelBuffer);
    free(convertBuffer);
    free(rgbConvertBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (NSArray*)getRefreshingImages
{
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
        [refreshingImages addObject:image];
    }
    
    return [refreshingImages copy];
}

+(void)moveAnimationInSuperView:(UIView*)superView ShowTime:(CGFloat)showTime MoveTime:(CGFloat)moveTime
{
    NSArray*arrayImage = [CMTool getRefreshingImages];
    NSInteger count = arrayImage.count;
    CGFloat width = CGRectGetWidth(superView.frame);
    CGFloat height = CGRectGetHeight(superView.frame);
    UIImageView* imageBGView = [[UIImageView alloc] initWithFrame:superView.frame];
    [imageBGView setImage:[UIImage imageNamed:@"loading_bg_circle"]];
    [superView addSubview:imageBGView];
    UIView* infrontView = [[UIView alloc] initWithFrame:CGRectMake(-width*count, 0, width*(count+1), height)];
    infrontView.userInteractionEnabled = NO;
    NSMutableArray*arrayMutable = [NSMutableArray arrayWithCapacity:count];
    int j = 0;
    for (int i = 0;i<= count ;i++) {
        UIView* imageSuperView = [[UIImageView alloc] initWithFrame:CGRectMake((count - i)*width, 0, width, height)];
        imageSuperView.userInteractionEnabled = NO;
        UIImageView* imageView = [[UIImageView alloc] init];
        j = i+1;
        if (i == count)
        {
            j = 1;
        }
        else
        {
            // 平移动画
            CABasicAnimation *a1 = [CABasicAnimation animation];
            CGPoint position = infrontView.layer.position;
            position.x = width*i;
            a1.fromValue = [NSValue valueWithCGPoint:position];
            a1.keyPath = @"transform.translation.x";
            position.x += width;
            a1.toValue = [NSValue valueWithCGPoint:position];
            a1.beginTime = i*(showTime + moveTime) + showTime;
            a1.duration = moveTime;
            a1.fillMode = kCAFillModeForwards;
            [arrayMutable addObject:a1];
            
            //            [UIView setAnimationRepeatAutoreverses:YES];
            //            [UIView animateWithDuration:moveTime delay:(i*(showTime + moveTime) + showTime) options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //                infrontView.layer.position = CGPointMake(infrontView.layer.position.x + width, infrontView.layer.position.y);
            //            } completion:^(BOOL finished) {
            //            }];
        }
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",j]]];
        [imageSuperView addSubview:imageView];
        [imageView autoCenterInSuperview];
        [infrontView addSubview:imageSuperView];
    }
    [superView addSubview:infrontView];
    
    CAAnimationGroup* groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = [arrayMutable copy];
    
    //设置组动画的时间
    groupAnima.duration = count*(showTime + moveTime);
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    groupAnima.repeatCount = MAXFLOAT;
    
    [infrontView.layer addAnimation:groupAnima forKey:@"position"];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        NSString* str = @"➋➌➍➎➏➐➑➒";
        NSRange range;
        range = [str rangeOfString:substring];
        if (range.length > 0)
        {
            return;
        }
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    returnValue =YES;
                }else if (ls == 0xfe0f)
                {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue =YES;
                }else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}

@end
