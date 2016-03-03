//
//  AppDelegate.m
//  FlashTag
//
//  Created by 夏雪 on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "AppDelegate.h"
#import "PYAllCommon.h"
#import <BaiduMapAPI/BMapKit.h>
#import <AlipaySDK/AlipaySDK.h>

#import "LoginViewController.h"
#import "FirstViewController.h"
#import "PYHttpTool.h"

#import <AVOSCloud/AVOSCloud.h>

#define SHARE_APP_KEY @"a776d1b96f20"
//请替换成自己的id和key 这样可以控制台中看到数据变化 https://cn.avoscloud.com/applist.html
#define AVOSCloudAppID  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AVOSCloudAppID"]
#define AVOSCloudAppKey [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AVOSCloudAppKey"]

@interface AppDelegate ()<WeiboSDKDelegate,QQApiInterfaceDelegate,BMKLocationServiceDelegate , BMKGeoCodeSearchDelegate>
{
    NSTimer *connectionTimer;
    BOOL done;
}
@property(nonatomic,strong)BMKMapManager* mapManager;
/** 定位*/
@property(nonatomic,strong) BMKLocationService* locService;
@property(nonatomic ,strong) CLLocation* location;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self.window makeKeyAndVisible];
    
    [CMData initDatabase];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersions = [defaults stringForKey:@"lastVersions"];
    NSString *newVersions = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
    if ([newVersions isEqualToString:lastVersions]) {
        
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
//        self.window.rootViewController = nav;
        
    }else{
        
        NSLog(@"第一次");
        
        FirstViewController *vc = [FirstViewController new];
        self.window.rootViewController = vc;
    
        //储存新版本号
        [defaults setObject:newVersions forKey:@"lastVersions"];
        [defaults synchronize];
    }
    
    _mapManager=[[BMKMapManager alloc]init];
    BOOL ret=[_mapManager start:@"kEXybh1Fs7z4vQMLRx6npgxe" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    {
        //设置AVOSCloud
        [AVOSCloud setApplicationId:AVOSCloudAppID
                          clientKey:AVOSCloudAppKey];
        
        //统计应用启动情况
        [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    }
    //分享
    {
        [ShareSDK registerApp:SHARE_APP_KEY];
        
        //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台 （注意：2个方法只用写其中一个就可以）
        [ShareSDK  connectSinaWeiboWithAppKey:@"1218792546"
                                    appSecret:@"4015c0712ecdb0a96a0643254fe07de6"
                                  redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                  weiboSDKCls:[WeiboSDK class]];
        //
        //添加QQ应用  注册网址  http://mobile.qq.com/api/
        [ShareSDK connectQQWithQZoneAppKey:@"1104771985"
                         qqApiInterfaceCls:[QQApiInterface class]
                           tencentOAuthCls:[TencentOAuth class]];
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104771985" andDelegate:self];
        _tencentOAuth.redirectURI = @"https://itunes.apple.com/us/app/mai-mie/id1045358844?l=zh&ls=1&mt=8";
        _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
        
        //微信登陆的时候需要初始化
        [ShareSDK connectWeChatWithAppId:@"wx0e5c0643c061d8e4"
                               appSecret:@"5a529368a4ceb6b85446533549fa58f8"
                               wechatCls:[WXApi class]];
    }
    
    //等待1秒进入首页
    connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    do{
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
    }while (!done);
    
    return YES;
}

-(void)timerFired:(NSTimer *)timer
{
    done=YES;
}

#pragma mark SHARE


- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    BOOL result = [ShareSDK handleOpenURL:url
                        wxDelegate:self]||[QQApi handleOpenURL:url]||[TencentOAuth HandleOpenURL:url]||[QQApiInterface handleOpenURL:url delegate:self]||[WeiboSDK handleOpenURL:url delegate:self];
    return result;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL result = [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self]||[QQApi handleOpenURL:url]||[TencentOAuth HandleOpenURL:url]||[QQApiInterface handleOpenURL:url delegate:self]||[WeiboSDK handleOpenURL:url delegate:self];
    
    if (!result) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            //你的跳转代码
        }];
    }
    
    return result;
}

#pragma mark WEIBO
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
}

#pragma mark QQ
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req
{
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp
{
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
}

- (void)tencentDidLogin
{
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        [_tencentOAuth getUserInfo];
    }
    else
    {
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
    }
    else
    {
    }
}

-(void)tencentDidNotNetWork
{
}

- (void)tencentDidLogout
{
}

-(void)getUserInfoResponse:(APIResponse *)response
{
    NSDictionary* userInfo = [response jsonResponse];
//    uData.nickName = [userInfo objectForKey:@"nickname"];
//    uData.name = [_tencentOAuth openId];
//    uData.userImage = [userInfo objectForKey:@"figureurl_qq_2"];
    [HandyWay shareHandyWay].headUrl = [userInfo objectForKey:@"figureurl_qq_2"];
    [CMData setUserImage:[HandyWay shareHandyWay].headUrl];
    //处理收到的数据
    NSDictionary *param = @{
                            @"openId":[_tencentOAuth openId],
                            @"userDisplayName":[userInfo objectForKey:@"nickname"],
                            @"photo":[userInfo objectForKey:@"figureurl_qq_2"],
                            @"type":@"qq"};
    NSLog(@"%@" , param);
    
    [CMAPI postUrl:API_USER_LOGORREG Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            PYLog(@"__________________________%@" , detailDict);
            
            //保存用户信息
            [[HandyWay shareHandyWay] setUserInfoWithDic:detailDict];
            
            [CMData initDatabase];
            
//            UIViewController* vc = self.window.rootViewController;
//            if ([vc isKindOfClass:[UINavigationController class]]) {
//                
//            }
//            else if ([vc isKindOfClass:[UITabBarController class]])
//            {
//                UITabBarController* tbvc = (UITabBarController*)vc;
//                vc = tbvc.selectedViewController;
//            }
            // 上传头像
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithString:[userInfo objectForKey:@"figureurl_qq_2"]]]];
            UIImage *image = [UIImage imageWithData:data];
              [self updateImage:image];
//            [vc presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"] animated:NO completion:nil];
            // 定位 如果为空就定位
            if([[[detailDict objectForKey:@"result"] objectForKey:@"emptyAddress"] isEqualToString:@"no"])
            {
                CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
                
                if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
                    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败,您可以在设置->隐私->定位服务中开启定位。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [view show];
                    
                }else
                {
                    [self BMKlocation];
                }

            }
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}
/**
 *  第三方登录上传图像
 */
- (void)updateImage:(UIImage *)image
{
    PYFormData* formData = [[PYFormData alloc] init];
    formData.name = @"avatarN";
    formData.filename = @"avatarN";
    formData.mimeType = @"image/jpg";
    formData.data = UIImageJPEGRepresentation(image, 1);
    //    PYLog(@"%@",[CMData getCommonImagePath]) ;
    //    PYLog(@"%@",[CMData getUserId]);
    [CMAPI postWithURL:API_USER_MODIFYInfo params:@{@"type":@"userIcon",@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken]} formDataArray:@[formData] Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed)
        {
            //            [SVProgressHUD showSuccessWithStatus:@"头像上传成功！"];
        }else
        {
            //            PYLog(@"%@",detailDict);
        }
    }];
}

#pragma mark - 定位
- (void)BMKlocation
{
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [BMKLocationService setLocationDistanceFilter:100.f];
    _locService=[[BMKLocationService alloc]init];
    _locService.delegate=self;
    [_locService startUserLocationService];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.location=userLocation.location;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint =self.location.coordinate;
    BMKGeoCodeSearch* _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate=self;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
     
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.location
                       completionHandler:^(NSArray *placemarks, NSError *error){
                           NSString *item;
                           for (CLPlacemark *place in placemarks) {
                               item=[NSString stringWithFormat:@"%@",place.country];
                               break;
                               //  item=[NSString stringWithFormat:@"%@\n\r国家代码：%@",item,place.ISOcountryCode];
                           }
                           if (!item) {
                               return;
                           }
                           NSString * coordinate = [NSString stringWithFormat:@"%f,%f",self.location.coordinate.longitude,self.location.coordinate.latitude];
                           //                           item=[NSString
                           NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"localAddress",@"city":result.addressDetail.city,@"country":item, @"province":result.addressDetail.province,@"coordinate":coordinate};
                           
                           [CMAPI postUrl:API_USER_MODIFYInfo Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
                               if (succeed) {
                                   
//                                   [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
//                                   [self networkingRequestForSeller];
                                   
                               }else{
//                                   [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
                               }
                           }];
         }];
        
    }
    else {
        //        NSLog(@"抱歉，未找到结果");
        [SVProgressHUD showErrorWithStatus:@"抱歉，未找到结果"];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 停止下载图片
    [[SDWebImageManager sharedManager] cancelAll];
    
   
   [[SDImageCache sharedImageCache] clearDisk];
}
@end
