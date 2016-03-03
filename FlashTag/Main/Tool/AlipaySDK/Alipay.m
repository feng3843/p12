//
//  Alipay.m
//  AliPayDemo
//
//  Created by uncommon on 2015/09/29.
//  Copyright © 2015年 ffTest. All rights reserved.
//

#import "Alipay.h"
#import "Order.h"
#import "Alipay.h"
#import "DataSigner.h"
#import "ToolsClass.h"

@implementation Alipay
NSString *partner=@"";
NSString *seller=@"";
NSString *rsaPrivate=@"";

#pragma mark- 支付方式1。使用时机：需要返回值的情况

+(NSString *)getAppScheme{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    return @"FlashTag";
}

+(NSString *)getOrderString:(NSString *)pOrderID price:(NSString *)pPrice{
    if (!pOrderID||pOrderID==nil) {
        [SVProgressHUD showInfoWithStatus:@"订单号不可为空"];
        return nil;
    }
    if (!pPrice||pPrice==nil) {
        [SVProgressHUD showInfoWithStatus:@"金额不可为空"];
        return nil;
    }
    if (![ToolsClass isPureNumber:pPrice]) {
        [SVProgressHUD showInfoWithStatus:@"金额不是纯数字"];
        return nil;
    }
    
    if (![Alipay initPayInfo]) {
        return nil;
    }
    
    NSString *orderSpec = [self getOrderSpec:pOrderID price:pPrice];
    NSString *signedString = [self getSign:orderSpec];
    
    if (signedString == nil) {
        return nil;
    }
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                   orderSpec, signedString, @"RSA"];
    
    return orderString;
}

#pragma mark- 支付方式2。使用时机：不需要返回值

+(void)alipay:(NSString *)pOrderID price:(NSString *)pPrice{
    //orderString 订单参数列表
    NSString *orderString = [Alipay getOrderString:pOrderID price:pPrice];
    //appScheme 应用体系名称
    NSString *appScheme = [Alipay getAppScheme];
    
    if (!orderString || [orderString length] <= 0 ||
        !appScheme || [appScheme length] <= 0) {
        return;
    }
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSString* resultStatus=[resultDic objectForKeyedSubscript:@"resultStatus"];
        
        //如果不是用户取消支付，则进行如下支付结果提示
        if (![resultStatus isEqualToString:@"6001"]) {
            NSString* showStr;
            if ([resultStatus isEqualToString:@"9000"]) {
                showStr=@"支付成功";
            }
            else if ([resultStatus isEqualToString:@"8000"]){
                showStr=@"支付正在处理中，稍后可查看支付结果";
            }
            else if ([resultStatus isEqualToString:@"6002"]){
                showStr=@"支付失败，请检查网络连接";
            }
            else if ([resultStatus isEqualToString:@"4000"]){
                showStr=@"支付失败";
            }
            else{//加入最后一个没有判断的分支，是为了适应支付宝的扩展
                showStr=@"支付失败";
            }
            
            [SVProgressHUD showInfoWithStatus:showStr];
        }
    }];
}

#pragma mark- 获取支付所需字符串

/**
 @brief 获取订单参数字符串
 @return 订单参数字符串
 */
+(NSString*)getOrderSpec:(NSString *)pOrderID price:(NSString *)pPrice{
    // 商品名称
    NSString *subject = [NSString stringWithFormat:@"海淘-%@号订单",pOrderID];
    // 商品描述
    NSString *body = @"海淘";
    // 价格
    NSString *price = pPrice;
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = pOrderID; //订单ID（由商家自行制定）
    order.productName = subject; //商品标题
    order.productDescription = body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[price floatValue]]; //商品价格
    order.notifyURL = CM_AlipayURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    return orderSpec;
}

/**
 @brief 获取根据私钥签名后的订单参数字符串
 */
+(NSString*)getSign:(NSString*)orderSpec{
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(rsaPrivate);
    return [signer signString:orderSpec];
}

#pragma mark- 设置参数

+(BOOL) initPayInfo {
//    //partner和seller获取失败,提示
//    if ((partner && [partner length] == 0 )||
//        (seller && [seller length] == 0) ||
//        (rsaPrivate && [rsaPrivate length] == 0))
//    {
//        //初始化赋值
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?token=%@",CMAPIBaseURL,API_USER_PRPFILE,[CMData getToken]]];//这里暂时先写4 后面修改
//        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//        //解析
//        //todo 接口写好后，改成动态设置那三个的值
//
//    }
    
    //Test use
    partner=@"2088021881656849";
    seller=@"frank@hongyisteelpipe.com";
    rsaPrivate = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBANh+jKs0+Cr0hSXxmrs8VsCxbz/5yKwjoqsupKPdcmBv18UqWtjGxiF4b4a2wawlj8p6swLieWFZYW2IVRJp+XdJ7uYMKYbLdvof6psOcdhxkczeBTlPu1PZrvsknYOjMX2kAQ7WH9j6fqZwLN5iWNlYprAjgp1ARcGNWUHpfZylAgMBAAECgYEAyAe9X18UwVOmRpXCWqd4nJgU626WPH68iSASnRk52eLc4V6uC8c1P62wli78KVuXTQUrq0mnzwuvmm2x9M6X4C4TgWH5Qf7lzFMNrwgZQBCXT25HKUdPe+kCs0cSFll/rbawmghF417G/2/mTNRYPC1pcFsD+yjJQbOuRK7lVm0CQQDsYjFpqxWV3yiVsvEJmzYIHwRslAXFq4hHrvdDHzuc2sr/aH0yAeZzIdwab/ybZXBprsj1zoIn//gS/GO36r2rAkEA6nXSxrbSrr0bHGphGKCJO33eMBz92pzz9sKw7hlHn/gPURw3axGXYG+72esC9BO4Up8DKxBkP2pGNUcsj9We7wJBAKTwSyxBPVmLEgWKi5e5XnVCN1MP4gswinICSvPh+jWTkSuwHBNlsghJ6wvjci54FH0ZgY3Kn5ULjWyqAWaWe+sCQQCJxxNFksnbxWTZHepQ/oWmYCDhRSgn/3Od3mr6gACHEM5va5VlZcD++qn5NRFXPP9kDe1esRM38MuxI1Icc/whAkEAkErMMxh555Dyvm/OT8xnGP33QabqlnsvaDwkJF97ig0LgZyUQeiuLopch6amuSkqFPtO167DVG3fc7BRBOL9DA==";
    
    if ((partner && [partner length] == 0 )||
        (seller && [seller length] == 0) ||
        (rsaPrivate && [rsaPrivate length] == 0)) {
        [SVProgressHUD showInfoWithStatus:@"支付失败！(无法获取支付参数)"];
        
        return NO;
    }
    
    return YES;
}

@end
