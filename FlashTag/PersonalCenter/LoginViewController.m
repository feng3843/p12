//
//  LoginViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/1.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  登录注册页面

#import "LoginViewController.h"

#import "MD5.h"
#import "HomeFindViewController.h"

#import "InviteViewController.h"
#import "VerificationViewController.h"
#import "ForgetPasswordViewController.h"
#import "ModificationPhoneNumberViewController.h"
#import "PYHttpTool.h"
@interface LoginViewController ()<BMKLocationServiceDelegate , BMKGeoCodeSearchDelegate>
/** 定位*/
@property(nonatomic,strong) BMKLocationService* locService;
@property(nonatomic ,strong) CLLocation* location;

@end

@implementation LoginViewController

- (void)loadView
{
    [super loadView];
    
    self.rootView = [[LoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.rootView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    // segment添加点击事件（界面切换）
//    [self.rootView.segment addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    // 添加到导航条上
//    self.navigationItem.titleView = self.rootView.segment;
    
    //修改才成button
    CGRect frame = CGRectMake(0, 0, fDeviceWidth/3.0, 17);
    self.buttonView = [[ButtonView alloc] initWithFrame:frame andLoginButtonArr:@[@"登录", @"注册"]];
    _buttonView.btn1.selected = YES;
    self.navigationItem.titleView = _buttonView;
    [_buttonView.btn1 addTarget:self action:@selector(btn1ActionInLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView.btn2 addTarget:self action:@selector(btn2ActionInLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(10, 10, 18, 18);
    [left setBackgroundImage:[UIImage imageNamed:@"ic_me_closelogin"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];

    
    [self addAction];
    
}

- (void)addAction
{
    [self.rootView.forgetPasswordButton addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootView.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootView.weiBoButton addTarget:self action:@selector(weiBoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootView.qqButton addTarget:self action:@selector(qqAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootView.weiXinButton addTarget:self action:@selector(weiXinAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootView.getServeButton addTarget:self action:@selector(getServeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)forgetPasswordAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[ForgetPasswordViewController new] animated:YES];
}

- (void)loginAction:(UIButton *)sender
{
    if ((self.rootView.loginUserName.text.length == 0) || (self.rootView.loginPassword.text.length == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"账号或密码为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }else{
        [self loginNetworkRequest];
    }
    
}

- (void)weiBoAction:(UIButton *)sender
{
    [self loginWithWB:sender];
}

- (void)qqAction:(UIButton *)sender
{
    [self loginWithQQ:sender];
}

- (void)weiXinAction:(UIButton *)sender
{
    [self loginWithWX:sender];
}

- (void)getServeButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    CGRect arect = self.rootView.nextButton.frame;
    CGFloat h = arect.origin.y;
    CGFloat change = 59;
    
    if (sender.selected) {
        arect.origin.y = h + change;
    }else{
        arect.origin.y = h - change;
        self.rootView.AlipayBgView.hidden = YES;
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.rootView.nextButton.frame = arect;
        
    }completion:^(BOOL finished) {
        if (sender.selected) {
            self.rootView.AlipayBgView.hidden = NO;
        }else{
            
        }
    }];
    
}

- (void)leftItemAction:(UIButton *)sender
{
    if (self.isChangeAlipayNumber || self.isChangeAlipayNumber) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{

        [[HandyWay shareHandyWay] setUserInfoWithNotLogin];
        
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"] animated:NO completion:nil];
    }
    
}


- (void)nextButtonAction:(UIButton *)sender
{
    NSInteger count = 0;
    
    BOOL result = [self.rootView.rigisterUserName.text containsString:@"@"];
//    NSString *type;
    if (result) {
//        type = @"email";
        
        if([self isValidateEmail:self.rootView.rigisterUserName.text]){
            
            NSLog(@"邮箱正确");
            count++;
        }else{
            NSLog(@"邮箱错误");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号格式有误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else{
//        type = @"mobile";
        if([self isValidatePhoneNumber:self.rootView.rigisterUserName.text]){
            
            NSLog(@"手机号正确");
            count++;
        }else{
            NSLog(@"手机号错误");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号格式有误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    
    if (count == 1) {
        
        if (![self.rootView.rigisterPassword.text isEqualToString:self.rootView.againPassword.text]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码不一致！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            if ([self isValidatePassword:self.rootView.rigisterPassword.text]) {
                NSLog(@"密码正确");
                count++;
                
            }else{
                NSLog(@"密码错误");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码格式" message:@"6-16位,不能有空格,不能是9位以下纯数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
    }
    
    
    if (count == 2) {
        [self netWorkingRequest];
    }
}

//- (void)changeView:(UISegmentedControl *)sender
//{
//    NSInteger index = sender.selectedSegmentIndex;
//    if (index == 0) {
//        self.rootView.loginView.hidden = NO;
//        self.rootView.rigisterView.hidden = YES;
//    } else {
//        self.rootView.loginView.hidden = YES;
//        self.rootView.rigisterView.hidden = NO;
//    }
//}
//buttonView的触发方法:
- (void)btn1ActionInLogin:(UIButton *)sender {
    self.rootView.loginView.hidden = NO;
    self.rootView.rigisterView.hidden = YES;
}
- (void)btn2ActionInLogin:(UIButton *)sender {
    self.rootView.loginView.hidden = YES;
    self.rootView.rigisterView.hidden = NO;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


#pragma mark - about network
//注册获取验证码
- (void)netWorkingRequest
{
    BOOL result = [self.rootView.rigisterUserName.text containsString:@"@"];
    NSString *strType;
    if (result) {
        strType = @"email";
    }else{
        strType = @"mobile";
    }
    
    NSDictionary *param = @{@"destination":self.rootView.rigisterUserName.text,@"type":strType};
    [CMAPI postUrl:API_USER_VERIFICATIONCODE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            PYLog(@"%@" , detailDict);
            
            InviteViewController *vc = [InviteViewController new];
            
            int a;
            if (self.rootView.getServeButton.selected) {
                a = 2;
            }else{
                a = 0;
            }
            self.userInfo = @{@"type":strType,strType:self.rootView.rigisterUserName.text,@"password":[self.rootView.rigisterPassword.text MD5EncodedString],@"role":@(a),@"alipayAccount":self.rootView.AlipayUserName.text,@"verificationCode":detailDict[@"result"][@"verificationCode"]};
            vc.dic = [NSMutableDictionary dictionaryWithDictionary:self.userInfo];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

//登录
- (void)loginNetworkRequest
{
    
    BOOL result = [CMTool validateEmail:self.rootView.loginUserName.text];
    NSString *strType;
    if (result) {
        strType = @"mail";
    }else{
        strType = @"mobile";
    }
    
    NSDictionary *param = @{@"password":[self.rootView.loginPassword.text MD5EncodedString],strType:self.rootView.loginUserName.text};
    NSLog(@"%@" , param);
    
    [CMAPI postUrl:API_USER_LOGIN Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            PYLog(@"__________________________%@" , detailDict);
            
            //保存用户信息
            [[HandyWay shareHandyWay] setUserInfoWithDic:detailDict];
            
            [CMData initDatabase];
            
            if (self.isChangePhoneNumber) {
                
                ModificationPhoneNumberViewController *vc = [ModificationPhoneNumberViewController new];
                vc.isPhoneUserChangePhoneNumber = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (self.isChangeAlipayNumber){
                
                ModificationPhoneNumberViewController *vc = [ModificationPhoneNumberViewController new];
                vc.isChangeAlipayNumber = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                                
                [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"] animated:NO completion:nil];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
    
}


//判断邮箱
- (BOOL)isValidateEmail:(NSString *)email{
 
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


- (BOOL)isValidatePassword:(NSString *)password{

    NSString *emailRegex = @"^(?![0-9]{1,8}$)[\\S]{6,16}$";

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:password];

}


//手机号
- (BOOL)isValidatePhoneNumber:(NSString *)mobileNum{
    
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:mobileNum];
    
    BOOL res2 = [regextestcm evaluateWithObject:mobileNum];
    
    BOOL res3 = [regextestcu evaluateWithObject:mobileNum];
    
    BOOL res4 = [regextestct evaluateWithObject:mobileNum];
    
    
    NSString *phone14 = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *regextest14 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone14];
    
    BOOL res5 = [regextest14 evaluateWithObject:mobileNum];
    
    if (res1 || res2 || res3 || res4 || res5){
        
        return YES;
    }else{
        return NO;
    }
}

// 第三方登录
- (IBAction)loginWithQQ:(id)sender
{
    
    
    TencentOAuth* tOAuth = ((AppDelegate*)[UIApplication sharedApplication].delegate).tencentOAuth;
    NSArray* permissions = ((AppDelegate*)[UIApplication sharedApplication].delegate).permissions;
    
    if(![TencentOAuth iphoneQQInstalled])
    {
        [SVProgressHUD showInfoWithStatus:@"未安装QQ"];
        return;
    }
    
    type = ShareTypeQQ;
    if([tOAuth isSessionValid])
    {
        [tOAuth getUserInfo];
    }
    else
    {
        [tOAuth authorize:permissions inSafari:NO];
    }
   // [self loginWithThird];
}

- (IBAction)loginWithWX:(id)sender
{
    if(![WXApi isWXAppInstalled])
    {
        [SVProgressHUD showInfoWithStatus:@"未安装微信"];
        return;
    }
    
    type = ShareTypeWeixiSession;
    [self loginWithThird];
}

- (IBAction)loginWithWB:(id)sender
{
    if(![WeiboSDK isWeiboAppInstalled])
    {
        [SVProgressHUD showInfoWithStatus:@"未安装新浪微博"];
        return;
    }
    type = ShareTypeSinaWeibo;
    [self loginWithThird];
}

-(void)loginWithThird
{
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   NSLog(@"userInfo%@",userInfo);
//                                   if (!uData) {
//                                       uData = [[PYUserData alloc] init];
//                                   }
//                                   uData.nickName = [userInfo nickname];
//                                   uData.name = [userInfo uid];
//                                   uData.userImage = [userInfo profileImage];
//                                   
//                                   [self autoLogin];
                                   [self thirdPartLoginUserInfo:userInfo];
                               }
                               else
                               {
                                   NSLog(@"%ld:%@",(long)[error errorCode], [error errorDescription]);
                               }
                           }];
    
}

-(void)thirdPartLoginUserInfo:(id<ISSPlatformUser>)userInfo
{
    NSString *strType;
    switch (type) {
        case ShareTypeQQ:
            strType = @"qq";
            break;
        case ShareTypeWeixiSession:
        case ShareTypeWeixiTimeline:
            strType = @"wx";
            break;
        case ShareTypeSinaWeibo:
            strType = @"wb";
            break;
        default:
            strType = @"";
            break;
    }
    
    
    NSDictionary *param = @{
                            @"openId":[userInfo uid],
                            @"userDisplayName":[userInfo nickname],
                            @"photo":[userInfo profileImage],
                            @"type":strType};
//    NSLog(@"%@" , param);
    NSLog(@"%@",userInfo);
    [HandyWay shareHandyWay].headUrl = [NSString stringWithString:[userInfo profileImage]];
    [CMData setUserImage:[HandyWay shareHandyWay].headUrl];
    
    [CMAPI postUrl:API_USER_LOGORREG Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            PYLog(@"__________________________%@" , detailDict);
            
            //保存用户信息
            [[HandyWay shareHandyWay] setUserInfoWithDic:detailDict];
       
            // 上传头像
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithString:[userInfo profileImage]]]];
            UIImage *image = [UIImage imageWithData:data];
            [self updateImage:image];
            
            [CMData initDatabase];
            
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
            if (self.isChangePhoneNumber) {
                
                ModificationPhoneNumberViewController *vc = [ModificationPhoneNumberViewController new];
                vc.isPhoneUserChangePhoneNumber = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (self.isChangeAlipayNumber){
                
                ModificationPhoneNumberViewController *vc = [ModificationPhoneNumberViewController new];
                vc.isChangeAlipayNumber = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                
                [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"] animated:NO completion:nil];
            }
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
                           NSString *item = nil;
                           for (CLPlacemark *place in placemarks) {
                               item=[NSString stringWithFormat:@"%@",place.country];
                               //  item=[NSString stringWithFormat:@"%@\n\r国家代码：%@",item,place.ISOcountryCode];
                           }
                           //                           item=[NSString stringWithFormat:@"%@%@,",item,result.addressDetail.province];
                           //                           item=[NSString stringWithFormat:@"%@%@",item,result.addressDetail.city];
                           
                           
                           //                           self.locationLabel.text = item;
                           
                           //                           self.country = item;
                           //                           self.province = result.addressDetail.province;
                           //                           self.changedCity = result.addressDetail.city;
                           //
                           if(!item)
                           {
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
@end
