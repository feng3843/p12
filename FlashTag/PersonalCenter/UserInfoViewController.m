//
//  UserInfoViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  用户信息

#import "UserInfoViewController.h"
#import "UserInfoView.h"
#import "UserInfoTableViewCell.h"
#import "LoginViewController.h"

#import "ModificationPhoneNumberViewController.h"

#import "CameraViewController.h"
#import "CMAPI.h"
#import "PYHttpTool.h"

#import <BaiduMapAPI/BMapKit.h>

@interface UserInfoViewController ()<UITableViewDelegate , UITableViewDataSource ,UIAlertViewDelegate,CameraDelagate , BMKLocationServiceDelegate , BMKGeoCodeSearchDelegate>

@property(nonatomic , strong)UserInfoView *userInfoView;

//判断是手机用户还是邮箱用户，作出不同响应
@property(nonatomic , assign)int type;

//
@property(nonatomic , assign)int headImageCount;

//重新登录
@property(nonatomic , strong)UIAlertView *loginAlert;
@property(nonatomic , strong)UIAlertView *alipayAlert;

/** 定位*/
@property(nonatomic,strong) BMKLocationService* locService;
@property(nonatomic ,strong) CLLocation* location;

@property(nonatomic , strong)UIAlertView *alert;

@property(nonatomic , copy)NSString *changedCity;
@property(nonatomic , copy)NSString *province;
@property(nonatomic , copy)NSString *country;
@property(nonatomic,copy)NSString *coordinate;

//
@property(nonatomic , assign)BOOL isThired;

@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.headImageCount = 0;
    
    [self networkingRequestForSeller];
    
    NSLog(@"%@" , self.dic);
}

- (void)loadView
{
    [super loadView];
    self.userInfoView = [[UserInfoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.userInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    [HandyWay shareHandyWay].mayChangeHead = 10;
    
    self.userInfoView.tableView.delegate = self;
    self.userInfoView.tableView.dataSource = self;
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
}


- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - tableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.userType isEqualToString:@"2"]) {
        return 6;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"userInfoCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    if (indexPath.row == 0) {
        
        static NSString *oneCellID = @"oneCell";
        UserInfoTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:oneCellID];
        if (nil == oneCell) {
            oneCell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneCellID];
        }
        oneCell.textLabel.text = @"头像";
        
        
//        if ([HandyWay shareHandyWay].mayChangeHead == 10) {
//            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]] options:SDWebImageDownloaderProgressiveDownload progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                
//                oneCell.userHeadImageView.image = image;
//
//            }];
        
//            [HandyWay shareHandyWay].mayChangeHead = 0;
//        }else{
        
//        }
        
        if (self.isThired) {
            
            [oneCell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[HandyWay shareHandyWay].headUrl] placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
        }else{
//           [oneCell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]] placeholderImage:[UIImage imageNamed:@"img_default_me_user"] options:SDWebImageRefreshCached];
            
            if ([HandyWay shareHandyWay].mayChangeHead == 10 || [HandyWay shareHandyWay].mayChangeHead == 20) {
                
                
                if ([HandyWay shareHandyWay].mayChangeHead == 20) {
                    
                    [HandyWay shareHandyWay].mayChangeHead = 5;
                }else{
                    
                    [HandyWay shareHandyWay].mayChangeHead = 0;
                }
                [oneCell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]]placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];

//            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]] options:SDWebImageDownloaderProgressiveDownload progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                
//                if (image) {
//                    
//                }else{
//                    image = [UIImage imageNamed:@"img_default_me_user"];
//                }
//                
//                oneCell.userHeadImageView.image = image;
//                
//            }];
                
                
            }

        }
        
        return oneCell;
        
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = self.dic[@"targetDisplayName"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"常住地";
        cell.detailTextLabel.text = self.dic[@"city"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"邮箱";
        cell.detailTextLabel.text = self.dic[@"mail"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"手机号";
        cell.detailTextLabel.text = self.dic[@"tel"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if (indexPath.row == 5){
        cell.textLabel.text = @"支付宝";
        cell.detailTextLabel.text = self.dic[@"alipayAccount"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
    cell.textLabel.textColor = PYColor(@"222222");
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    cell.detailTextLabel.textColor = PYColor(@"999999");
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kCalculateV(80);
    }else{
        return kCalculateV(49);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        if (self.isThired) {
            
           [SVProgressHUD showErrorWithStatus:@"第三方登录不能修改头像"];
        }else{
            
            [HandyWay shareHandyWay].mayChangeHead = 20;
            
            /**
             上传头像Start
             @name Mingle
             @email fu.chenming@puyuntech.com
             */
            CameraViewController* cameraVC = [[CameraViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cameraVC];
            cameraVC.delagate = self;
            cameraVC.isFrist = YES;
            cameraVC.type = CutTypeCircle;
            cameraVC.ratio = (182+2*2)/320.0f;
            [self presentViewController:nav
                               animated:YES completion:nil];
            /**
             上传头像End
             @name Mingle
             @email fu.chenming@puyuntech.com
             */

            
        }
        
    }else if (indexPath.row == 1){
        
        if (self.isThired) {
            
            [SVProgressHUD showErrorWithStatus:@"第三方登录不能修改昵称"];
        }else{
            
        ModificationPhoneNumberViewController *vc = [ModificationPhoneNumberViewController new];
        vc.isChangeUserName = YES;
        [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else if (indexPath.row == 2){
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败,您可以在设置->隐私->定位服务中开启定位。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [view show];
            
        }else
        {
            [self BMKlocation];
        }

        
    }else if (indexPath.row == 3){
        
        if (self.type == 1 || self.isThired) {
            
            ModificationPhoneNumberViewController *vc = [ModificationPhoneNumberViewController new];
            if ([tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text.length > 0) {
                vc.isPhoneUserChangeEmail = YES;
            }else{
                vc.isPhoneUserWriteEmail = YES;
            }
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            NSLog(@"邮箱用户修改邮箱？");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册邮箱不能修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    }else if (indexPath.row == 4){
        
        
        if (self.type == 1) {
            
            self.loginAlert = [[UIAlertView alloc] initWithTitle:nil message:@"修改绑定手机号,需要重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
            [self.loginAlert show];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册手机号不能修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            
        }else{
            
            ModificationPhoneNumberViewController *vc = [ModificationPhoneNumberViewController new];
            
            if ([tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text.length > 0) {
                vc.isEmailUserChangePhoneNumber = YES;
            }else{
                vc.isEmailUserWritePhoneNumber = YES;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.row == 5){
        self.alipayAlert = [[UIAlertView alloc] initWithTitle:nil message:@"修改支付宝号,需要重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
        [self.alipayAlert show];
    }
}
/**
 上传头像Start
 @name Mingle
 @email fu.chenming@puyuntech.com
 */
-(void) afterCut:(UIImage *)image ByViewController:(UIViewController *)viewC
{
    [self uploadAvatar:image];
}

-(void)uploadAvatar:(UIImage*)image
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
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功！"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]];
            
            [[SDImageCache sharedImageCache] removeImageForKey:[url absoluteString] fromDisk:YES withCompletion:^{
                UIButton *btn = [[UIButton alloc]init];
            [btn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_default_me_user"] options:SDWebImageRefreshCached ];
                
            }];
     
        }else
        {
            PYLog(@"%@",detailDict);
        }
    }];
}

/**
 上传头像End
 @name Mingle
 @email fu.chenming@puyuntech.com
 */

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.loginAlert]) {
        if (buttonIndex == 1) {
            LoginViewController *vc = [LoginViewController new];
            vc.isChangePhoneNumber = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else if ([alertView isEqual:self.alipayAlert]) {
        if (buttonIndex == 1) {
            
            LoginViewController *vc = [LoginViewController new];
            vc.isChangeAlipayNumber = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if ([alertView isEqual:self.alert]){
        if (buttonIndex == 1) {
            NSLog(@"更改位置");
            
            [self changeWeiZhi];
        }
    }
}


#pragma mark - network
//networkingForSeller
- (void)networkingRequestForSeller
{
    //[CMData getUserIdForInt]   [CMData getUserIdForInt]
    NSDictionary *param = @{@"targetUserId":@([CMData getUserIdForInt]),@"userId":@([CMData getUserIdForInt])};
    NSLog(@"%@" , param);
    [CMAPI postUrl:API_USER_PRPFILE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"%@" , detailDict);
            
            //储存最新的用户信息
            [CMData setUserName:detailDict[@"result"][@"targetDisplayName"]];
            
            
            //为个人信息页面储存数据
            self.dic = [NSMutableDictionary dictionaryWithDictionary:detailDict[@"result"]];
            [self setInfo];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

- (void)setInfo
{
    if ([self.dic[@"registerType"] isEqualToString:@"tel"]) {
        self.type = 1;
    }else if ([self.dic[@"registerType"] isEqualToString:@"mail"]){
        self.type = 2;
    }else{
        self.type = 3;
    }
    
    if ([self.dic[@"thirdType"] isEqualToString:@"qq"]) {
        
        self.isThired = YES;
    }else if ([self.dic[@"thirdType"] isEqualToString:@"wx"]){
        
        self.isThired = YES;
        
    }else if ([self.dic[@"thirdType"] isEqualToString:@"wb"]){
        
        self.isThired = YES;
        
    }else{
        
        self.isThired = NO;
    }

    [self.userInfoView.tableView reloadData];
}


#pragma mark - 定位
- (void)BMKlocation
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
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
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    if (kCLErrorDenied == error.code)
    {
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败,您可以在设置->隐私->定位服务中开启定位。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"定位失败"];
    }
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
        //       __block NSString *item=[NSString stringWithFormat:@"经度：%f\n\r纬度：%f",self.location.coordinate.longitude,self.location.coordinate.latitude];
        //       item=[NSString stringWithFormat:@"%@\n\r地址：%@",item,result.address];
        //       item=[NSString stringWithFormat:@"%@\n\r街道：%@",item,result.addressDetail.streetName];
        //       item=[NSString stringWithFormat:@"%@\n\r：%@",item,result.addressDetail.district];区域
        //       item=[NSString stringWithFormat:@"%@\n\r城市：%@",item,result.addressDetail.city];
        //       item=[NSString stringWithFormat:@"%@\n\r省：%@",item,result.addressDetail.province];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.location
                       completionHandler:^(NSArray *placemarks, NSError *error){
                           NSString *item = nil;
                           for (CLPlacemark *place in placemarks) {
                               item=[NSString stringWithFormat:@"%@,",place.country];
                               //  item=[NSString stringWithFormat:@"%@\n\r国家代码：%@",item,place.ISOcountryCode];
                           }
//                           item=[NSString stringWithFormat:@"%@%@,",item,result.addressDetail.province];
//                           item=[NSString stringWithFormat:@"%@%@",item,result.addressDetail.city];
                           
                           
//                           self.locationLabel.text = item;
                            NSString  *local = result.addressDetail.city;
//                           PYLog(@"SWWWWWW%@",result.addressDetail.city);
                         self.coordinate = [NSString stringWithFormat:@"%f,%f",self.location.coordinate.longitude,self.location.coordinate.latitude];
                           self.country = item;
                           self.province = result.addressDetail.province;
                           self.changedCity = result.addressDetail.city;
                           
                           if ([self.dic[@"city"] isEqualToString:result.addressDetail.city]) {
                              [SVProgressHUD showInfoWithStatus:@"与历史定位一致"];
                           }else{
                               
                               if ([result.addressDetail.city isEqualToString:@""] || [result.addressDetail.city isKindOfClass:[NSNull class]]  || (result.addressDetail.city = nil)) {
                                   
                                   [SVProgressHUD showErrorWithStatus:@"定位失败"];
                               }else{
                                   
                                
//                                      PYLog(@"SWWWWWWdddd%@",local);
                                   self.alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您当前定位与历史定位不符，是否更改为%@?" , local] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更改", nil];
                                   [self.alert show];

                               }
                               
                               
                           }
                           
                       }];
        
        
    }
    else {
        //        NSLog(@"抱歉，未找到结果");
        [SVProgressHUD showErrorWithStatus:@"抱歉，未找到结果"];
    }
    
}


- (void)changeWeiZhi{
    
//    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"localAddress",@"city":self.changedCity,@"country":self.country, @"province":self.province};
     NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"localAddress",@"city":self.changedCity,@"country":self.country, @"province":self.province,@"coordinate":self.coordinate};
    
    [CMAPI postUrl:API_USER_MODIFYInfo Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
            [self networkingRequestForSeller];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];

}


@end
