//
//  AlipayDemo.m
//  AliPayDemo
//
//  Created by uncommon on 2015/09/30.
//  Copyright © 2015年 ffTest. All rights reserved.
//

#import "AlipayDemo.h"
#import "Alipay.h"

#import <AlipaySDK/AlipaySDK.h>

///支付宝支付Demo。实际应用中，可任意选择其中一种方式。
@implementation AlipayDemo

///支付方式1。使用时机：需要返回值的情况
-(void)alipayWay1{
    NSString *orderID=@"123456";
    NSString *price=@"0.01";
    
    //orderString 订单参数列表
    NSString *orderString = [Alipay getOrderString:orderID price:price];
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

///支付方式2。使用时机：不需要返回值
-(void)alipayWay2{
    NSString *orderID=@"123456";
    NSString *price=@"0.01";
    
    [Alipay alipay:orderID price:price];
}

#pragma mark- 支付宝钱包进行支付时，使用如下方式处理支付结果
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    
//    //跳转支付宝钱包进行支付，处理支付结果
//    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        NSLog(@"result = %@",resultDic);
//    }];
//    
//    return YES;
//}

@end
