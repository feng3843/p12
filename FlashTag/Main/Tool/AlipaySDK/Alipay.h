//
//  Alipay.h
//  AliPayDemo
//
//  Created by uncommon on 2015/09/29.
//  Copyright © 2015年 ffTest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

@interface Alipay : NSObject

#pragma mark- 支付方式1。使用时机：需要返回值的情况

/// 应用注册scheme,在AlixPayDemo-Info.plist定义URL types
+(NSString *)getAppScheme;

/**
 @brief 获取订单参数字符串
 @param orderID 订单号
 @param price 金额
 @return 订单参数字符串
 */
+(NSString *)getOrderString:(NSString *)pOrderID price:(NSString *)pPrice;

#pragma mark- 支付方式2。使用时机：不需要返回值

/**
 @brief 直接支付，不需要返回值的情况下使用。
 @param orderID 订单号
 @param price 金额
 */
+(void)alipay:(NSString *)pOrderID price:(NSString *)pPrice;

//#pragma mark- 获取支付所需字符串

/**
 *
 * @brief 设置支付信息.
 * @return 设置成功YES，失败NO.
 * @author: 田非凡 date: 2015年6月9日 上午11:15:53
 *
 */
//+(BOOL) initPayInfo;

@end
