//
//  HandyWay.m
//  FlashTag
//
//  Created by MyOS on 15/8/31.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  单例

#import "HandyWay.h"
#import "NSString+Extensions.h"

@implementation HandyWay


+ (HandyWay *)shareHandyWay
{
    static HandyWay *handyWay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handyWay = [[HandyWay alloc] init];
    });
    return handyWay;
}


//提取invitationCode
- (NSString *)getInvitationCode
{
    return [self getUserInfoDic][@"invitationCode"];
}


- (NSDictionary *)getUserInfoDic
{
    
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *filePath = [documentPath stringByAppendingPathComponent:@"zpzUserInfo.plist"];
//    NSDictionary *dic = @{@"token":detailDict[@"result"][@"token"],@"userId":detailDict[@"result"][@"userId"]};
//    [dic writeToFile:filePath atomically:NO];
//    
//    NSLog(@"%@" ,[[HandyWay shareHandyWay] getTokenCode]);
    

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"zpzUserInfo.plist"];
    NSDictionary *token = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return token;
}



- (BOOL)judgeDueWithTime:(NSString *)str
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];
    NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    if ([nowTime doubleValue] > ([str doubleValue]/1000)) {
        return YES;
    }else{
        return NO;
    }
}

// 没有把今天加进去
- (NSString *)judgeResidueWith:(NSString *)str
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];
    NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
//    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//    [formatter2 setDateFormat:@"dd"];
//    NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:[str integerValue]/1000 - [nowTime integerValue]];
//    NSString *confromTimespStr2 = [formatter2 stringFromDate:confromTimesp2];
    
//    return confromTimespStr2;
//    NSInteger time=[str doubleValue]+28800;
    NSInteger xx = ([str doubleValue]/1000 - [nowTime doubleValue])/3600/24 + 1;
    return [NSString stringWithFormat:@"%ld天" , (long)xx] ;

}

- (NSString *)getTimeWithStr:(NSString *)str
{
    
    NSTimeInterval timestr = [str doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestr/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

- (NSString *)getTimeWithStr2:(NSString *)str
{
    
    NSTimeInterval timestr = [str doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestr/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

- (NSString *)getTimeWithStrForSecond:(NSString *)str
{
    NSTimeInterval timestr = [str doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}


- (void)postSiteEveryday
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:date];
    
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"PostSiteEveryday.plist"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if ([str isEqualToString:time]) {
    
    }else{
        [self postSite];
        [time writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}



- (NSString *)changeUserId:(NSString *)str
{
    return [str get2Subs];
}


//点赞
- (void)postLikesWithButton:(PostLikesButton *)button Array:(NSMutableArray *)array tag:(NSInteger)tag
{
    UserCenterPostModel *model = array[button.tag - tag];
    
    NSString *type;
    if ([model.isLiked isEqualToString:@"no"]) {
        type = @"yes";
    }else{
        type = @"no";
    }
    
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"noteId":model.noteId,
                            @"targetId":model.userId,
                            @"isLiked":type};
    [CommonInterface callingInterfacePraise:param succeed:^{
        
        NSString *like = model.likes;
        if ([type isEqualToString:@"yes"]) {
            model.isLiked = @"yes";
            
            model.likes = [NSString stringWithFormat:@"%d" , [like intValue] + 1];
            button.tagImage.image = [UIImage imageNamed:@"ic_press_like"];
            
            [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
        }else{
            model.isLiked = @"no";
            model.likes = [NSString stringWithFormat:@"%d" , [like intValue] - 1];
            button.tagImage.image = [UIImage imageNamed:@"ic_like"];
            [SVProgressHUD showSuccessWithStatus:@"取消点赞成功"];
        }
        
        button.likesLabel.text = model.likes;
    }];

}

- (void)setUserInfoWithNotLogin
{
    [CMData setToken:@""];
    [CMData setUserId:@""];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"zpzUserInfo.plist"];
    NSDictionary *dic = @{@"role":@"", @"invitationCode":@""};
    [dic writeToFile:filePath atomically:NO];
    
    NSLog(@"%d" ,[CMData getUserType]);
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


- (BOOL)isValidateID:(NSString *)str
{
    NSString *emailRegex = @"^[0-9A-Za-z]{4}$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:str];

}


- (void)setUserInfoWithDic:(NSDictionary *)dic
{
    //保存用户信息
    [CMData setToken:dic[@"result"][@"token"]];
    [CMData setUserId:dic[@"result"][@"userId"]];
    [CMData setUserName:dic[@"result"][@"userDisplayName"]];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"zpzUserInfo.plist"];
    id role = dic[@"result"][@"role"];
    NSDictionary *dictionary = @{@"role":role?role:@"", @"invitationCode":dic[@"result"][@"invitationCode"]};
    [dictionary writeToFile:filePath atomically:NO];

}


#pragma mark - 定位
- (void)postSite
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    [BMKLocationService setLocationDistanceFilter:100.f];
    if (!_locService) {
        _locService=[[BMKLocationService alloc]init];
        _locService.delegate=self;
    }
    [_locService startUserLocationService];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.location=userLocation.location;
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = self.location.coordinate;
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
    if (error == BMK_SEARCH_NO_ERROR)
    {
        [_locService stopUserLocationService];
        _locService.delegate= nil;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.location
                       completionHandler:^(NSArray *placemarks, NSError *error)
                        {
                           if(error)
                           {
                               
                           }
                            else
                            {
                                NSString *item = nil;
                                for (CLPlacemark *place in placemarks) {
                                    item=[NSString stringWithFormat:@"%@",place.country];
                                    break;
                                }
                                if (placemarks)
                                {
                                    [self postSiteWithCountry:item Province:result.addressDetail.province City:result.addressDetail.city longitude:self.location.coordinate.longitude latitude:self.location.coordinate.latitude];
                                }
                            }
                       }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"抱歉，未找到结果"];
    }
    searcher.delegate = nil;
}

- (void)postSiteWithCountry:(NSString *)country Province:(NSString *)province City:(NSString *)city longitude:(CGFloat)longitude latitude:(CGFloat)latitude
{
    if (!country||[@"" isEqualToString:country])
    {
        return;
    }
    if (!province||[@"" isEqualToString:province])
    {
        return;
    }
    if (!city||[@"" isEqualToString:city])
    {
        return;
    }
    
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"type":@"localAddress",@"city":city,@"country":country, @"province":province , @"locateAddress":[NSString stringWithFormat:@"%f,%f" , longitude , latitude]};
    
    [CMAPI postUrl:API_UPLOAD_ADDRESS Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed)
        {
            NSLog(@"定位成功");
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];

}

#pragma mark - 帖子详情
- (void)pushToNoteDetailWithController:(UIViewController *)vc NoteId:(NSString *)noteId UserId:(NSString *)userId
{
    NoteDetailViewController *noteVc = [NoteDetailViewController new];
    noteVc.noteId = noteId;
    noteVc.noteUserId = userId;
    vc.navigationController.navigationBar.translucent = YES;
    [vc.navigationController pushViewController:noteVc animated:YES];
    noteVc.returnBackBlock = ^(NSString *str) {
    };
}


@end
