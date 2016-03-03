//
//  DingWeiVC.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "DingWeiVC.h"
#import <CoreLocation/CoreLocation.h>

#import "PYHttpTool.h"
#import "UserModel.h"
#import "TableViewCell.h"
#import "ScrollCountryView.h"
#import "CountrysName.h"
#import "VisitSellerViewController.h"
#import "VisitBuyerViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ShortUserArrayTool.h"

#import "MoreCountryViewController.h"

@interface DingWeiVC () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) int userId;
@property (nonatomic, copy) NSString *token;
/**存储请求到的所有国家*/
@property (nonatomic, strong) NSMutableArray *moreCountryArr;
/**存储排序好的所有国家的数组*/
@property (nonatomic, strong) NSArray *bigArr;
/**存储热门国家的数组*/
@property (nonatomic, strong) NSMutableArray *countryArr;
/**存储用户*/
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSArray *tempArr;
/**segment标识*/
@property (nonatomic, assign) NSInteger caseCount;

/** 定位*/
@property(nonatomic,strong) BMKLocationService* locService;
@property(nonatomic ,strong) CLLocation* location;
@property (nonatomic, strong) NSString *locationString;

@property(nonatomic,strong)CLLocationManager *locMgr;//位置管理器
@property (nonatomic,strong) UsuallyLivePlace *usuallyLivePlace;//常用住址

@property (nonatomic, strong) UIView *noView;
@property (nonatomic, strong) UILabel *noCountLabel;
@property (nonatomic, strong) UIView *whiteView;//背景层

@property(nonatomic , strong)NSArray *countryInfoArray;

@end

@implementation DingWeiVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self creatLeftItem];
}

//懒加载
- (CLLocationManager *)locMgr {
    if (_locMgr == nil) {
        self.locMgr = [[CLLocationManager alloc] init];
        self.locMgr.delegate = self;
    }
    return _locMgr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.userId = [CMData getUserIdForInt];
    self.token = [CMData getToken];
    self.bigArr = [NSArray array];
    self.dataArr = [NSMutableArray array];
    self.countryArr = [NSMutableArray array];
    self.moreCountryArr = [NSMutableArray array];
    
    self.noView = [[UIView alloc] initWithFrame:self.view.bounds];
    _noView.backgroundColor = [UIColor whiteColor];
    self.noCountLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, kCalculateV(40), fDeviceWidth, 40)];
    _noCountLabel.textAlignment=NSTextAlignmentCenter;
    _noCountLabel.textColor=PYColor(@"a8a8a8");
    _noCountLabel.font = [UIFont systemFontOfSize:13];
    _noCountLabel.text = @"这儿暂时没有更多用户啦!";
    [self.view addSubview:_noView];
    [_noView addSubview:_noCountLabel];
    _noView.hidden=YES;
    
    
    //获取热门国家列表
    [self getCountryFormNet];
    //获取用户常用地址
    [self getPlaceOfUserWithUserId:[CMData getUserIdForInt]];
    /** 定位*/
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败,您可以在设置->隐私->定位服务中开启定位。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        
    }else
    {
        [self BMKlocation];
    }

}

- (void)creatCountriesButtonsWithArr:(NSArray *)arr {
    CGFloat phoneWide = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnWide = phoneWide/5;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, phoneWide, kCalculateV(40))];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [scrollView setContentSize:CGSizeMake(btnWide*7, -kCalculateV(40))];
    for (int i = 0; i<7; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*btnWide, 0, btnWide, kCalculateV(40));
        btn.tag = 1000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:kCalculateV(14)];
        [btn setTitleColor:PYColor(@"5c6870") forState:UIControlStateNormal];
        [btn setTitleColor:PYColor(@"3890ce") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        if (i==0) {
            [self action:btn];
            [btn setTitle:@"同城" forState:UIControlStateNormal];
        } else if (i>0 && i<6) {
            NSString *countryName = ((CountrysName *)self.countryArr[i-1]).chineseName;
            [btn setTitle:countryName forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"更多" forState:UIControlStateNormal];
        }
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(39), btnWide*7, 0.5)];
    lineView.backgroundColor = PYColor(@"bababa");
    [scrollView addSubview:lineView];
    [self.view addSubview:scrollView];
}

- (void)action:(UIButton *)btn {
    NSInteger tag = btn.tag;
    for (int i = 0; i<7; i++) {
        if (1000+i != tag) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:1000+i];
            btn.selected = NO;
        }
    }
    btn.selected = YES;
    
    switch (tag-1000) {
        case 0:
            _caseCount = 0;
            if (![[CMData getToken] isEqualToString:@""]) {
                [self getOneCityFromURLWithPath:API_GET_ONECITY andDictionary:@{@"userId":@(_userId), @"orderRanking":@(0), @"count":@(50)}];
            }
            else
            {
                [self.dataArr removeAllObjects];
                 _noView.hidden = NO;
            }
            [self.tableView reloadData];
            break;
            
        case 1:
            _caseCount = 1;
            [self getOneCityFromURLWithPath:API_GET_SELLERSBYCOUNTRY andDictionary:@{@"domain":((CountrysName *)self.countryArr[_caseCount-1]).domain, @"orderRanking":@(0), @"count":@(50)}];
            [self.tableView reloadData];
            break;
            
        case 2:
            _caseCount = 2;
            [self getOneCityFromURLWithPath:API_GET_SELLERSBYCOUNTRY andDictionary:@{@"domain":((CountrysName *)self.countryArr[_caseCount-1]).domain, @"orderRanking":@(0), @"count":@(50)}];
            [self.tableView reloadData];
            break;
            
        case 3:
            _caseCount = 3;
            [self getOneCityFromURLWithPath:API_GET_SELLERSBYCOUNTRY andDictionary:@{@"domain":((CountrysName *)self.countryArr[_caseCount-1]).domain, @"orderRanking":@(0), @"count":@(50)}];
            [self.tableView reloadData];
            break;
            
        case 4:
            _caseCount = 4;
            [self getOneCityFromURLWithPath:API_GET_SELLERSBYCOUNTRY andDictionary:@{@"domain":((CountrysName *)self.countryArr[_caseCount-1]).domain, @"orderRanking":@(0), @"count":@(50)}];
            [self.tableView reloadData];
            break;
            
        case 5:
            _caseCount = 5;
            [self getOneCityFromURLWithPath:API_GET_SELLERSBYCOUNTRY andDictionary:@{@"domain":((CountrysName *)self.countryArr[_caseCount-1]).domain, @"orderRanking":@(0), @"count":@(50)}];
            [self.tableView reloadData];
            break;
            
        case 6:
            _caseCount = 6;
            [self getCountryFormNetWithParam:@{@"type":@"all"}];
            break;
        default:
            break;
    }
}

- (void)creatLeftItem {
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
}
- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 定位
- (void)BMKlocation
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否开启定位服务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alert show];
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
        //       __block NSString *item=[NSString stringWithFormat:@"经度：%f\n\r纬度：%f",self.location.coordinate.longitude,self.location.coordinate.latitude];
        //       item=[NSString stringWithFormat:@"%@\n\r地址：%@",item,result.address];
        //       item=[NSString stringWithFormat:@"%@\n\r街道：%@",item,result.addressDetail.streetName];
        //       item=[NSString stringWithFormat:@"%@\n\r区域：%@",item,result.addressDetail.district];
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
                           item=[NSString stringWithFormat:@"%@%@,",item,result.addressDetail.province];
                           item=[NSString stringWithFormat:@"%@%@",item,result.addressDetail.city];
                           self.locationString = item;
                           if ([_usuallyLivePlace.city isEqualToString:_locationString]) {
                               [self ifLocalIsEquelwithItem:item];
                           }
                       }];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"抱歉，未找到结果"];
    }
}
- (void)ifLocalIsEquelwithItem:(NSString *)item {
    //此时应该判断用户现处位置是否为常住地址位置, 如果不是,弹窗提醒
    NSString *tempStr = [NSString stringWithFormat:@"您当前的定位与历史定位不符,是否更改为'%@'?", item];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:tempStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"点击取消");
    } else {
        NSLog(@"点击确定");
        [self locMgr];//开启定位
    }
}


#pragma mark 获取热门国家
- (void)getCountryFormNet {
    [CMAPI postUrl:API_GET_POPULARCOUNTRIES Param:@{@"type":@"hot"} Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        PYLog(@"++_+_+_+_+_+_+_+__+热门国家为:%@", result);
        if (succeed) {
            NSArray *arr = result[@"popularCountries"];
            for (NSDictionary *dic in arr) {
                CountrysName *country = [[CountrysName alloc] initWithDic:dic];
                [self.countryArr addObject:country];
            }
            [self creatCountriesButtonsWithArr:_countryArr];
        } else {
            //            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
    }];
}

#pragma mark 获取用户常用地址
- (void)getPlaceOfUserWithUserId:(NSInteger)userId {
    NSDictionary *param = @{@"userId":@(userId)};
    [CMAPI postUrl:API_GET_LOCALADDRESS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        PYLog(@"++_+_+_+_+_+_+_+__+获取本机用户的常用住址为%@", result);
        if (succeed) {
            self.usuallyLivePlace = [UsuallyLivePlace new];
            _usuallyLivePlace.country = result[@"country"];
            _usuallyLivePlace.locateAddress = result[@"locateAddress"];
            _usuallyLivePlace.province = result[@"province"];
            _usuallyLivePlace.city = result[@"city"];
            
        } else {
            //            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
    }];
}
#pragma mark 根据地理位置搜索用户
- (void)getOneCityFromURLWithPath:(NSString *)path andDictionary:(NSDictionary *)param {
    [CMAPI postUrl:path Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        PYLog(@"++_+_+_+_+_+_+_+__+搜索的同城普通卖家为:%@", result);
        if (succeed) {
            [self.dataArr removeAllObjects];
            self.tempArr = result[@"sellers"];
            for (NSDictionary *dic in _tempArr) {
                UserModel *user = [[UserModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:user];
            }
            self.dataArr = [ShortUserArrayTool shortCountryUserArray:self.dataArr];
            [self.tableView reloadData];
            _noView.hidden = YES;
        } else {
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
            _noView.hidden = NO;
        }
    }];
    
}
#pragma mark 获取更多国家
- (void)getCountryFormNetWithParam:(NSDictionary *)param {
    [CMAPI postUrl:API_GET_POPULARCOUNTRIES Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        if (succeed) {
            NSArray *arr = result[@"popularCountries"];
            
            self.countryInfoArray = [NSArray arrayWithArray:arr];
            for (NSDictionary *dic in arr) {
                CountrysName *country = [[CountrysName alloc] initWithDic:dic];
                [self.moreCountryArr addObject:country];
            }
            //排序国家
            self.bigArr = [ShortCountries shortCountriesByCountryArr:_moreCountryArr];
            [_tableView reloadData];
            _noView.hidden=YES;
            
        } else {
            _noView.hidden=NO;
        }
    }];
    
}



#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_caseCount == 6) {
        return self.bigArr.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_caseCount != 6) {
        return self.dataArr.count;
    } else {
        NSArray *arr = (self.bigArr[section])[@"list"];
        return arr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_caseCount != 6) {
        return kCalculateV(60);
    } else {
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_caseCount != 6) {
        return 0;
    } else {
        return 25;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_caseCount == 6) {
        return (self.bigArr[section])[@"zimu"];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据国家获取用户
    if (_caseCount != 6) {
        
        UserModel *userList = (UserModel *)self.dataArr[indexPath.row];
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
        if (cell == nil) {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
        }
        NSString *path = [CMData getCommonImagePath];//path/userIcon/icon7.jpg;
        NSString *userImageStr = [NSString stringWithFormat:@"%@/userIcon/icon%@.jpg", path, userList.userId];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:userImageStr] placeholderImage:[UIImage imageNamed:@"img_default_user"]];//用户图像
        
        cell.fans.text = userList.distance;//距离
        cell.userName.text = userList.userDisPlayName;//用户名字
        NSString *LVImageStr = [NSString stringWithFormat:@"img_search_hot_%@", userList.levle];
        cell.lvImage.image = [UIImage imageNamed:LVImageStr];//热卖度(等级)图片
        return cell;
    } else {
        //获取更多国家
        NSArray *arr = (_bigArr[indexPath.section])[@"list"];
        NSString *countryNameStr = arr[indexPath.row];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"countryCell"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = countryNameStr;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_caseCount != 6) {
        UserModel *model = self.dataArr[indexPath.row];
        if ([model.role isEqualToString:@"2"]) {
            VisitSellerViewController *vc = [VisitSellerViewController new];
            vc.userId=model.userId;
            [self.navigationController pushViewController:vc animated:YES];
            vc.returnBackBlock = ^(NSString *str) {
                
            };
        } else if ([model.role isEqualToString:@"0"]){
            VisitBuyerViewController *vc = [VisitBuyerViewController new];
            vc.userId=model.userId;
            [self.navigationController pushViewController:vc animated:YES];
            vc.returnBackBlock = ^(NSString *str) {
                
            };
        }
    }else{
        NSString *touchObject = [NSString string];
        NSString *str = _bigArr[indexPath.section][@"list"][indexPath.row];
        for (NSDictionary *dic in self.countryInfoArray) {
            if ([str isEqualToString:dic[@"chineseName"]]) {
                touchObject = dic[@"domain"];
            }
        }
        
        MoreCountryViewController *vc = [MoreCountryViewController new];
        vc.country = touchObject;
        vc.title = str;
        [self.navigationController pushViewController:vc animated:YES];
    }
}




@end
