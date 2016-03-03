//
//  UserCenterViewController.m
//  FlashTag
//
//  Created by MyOS on 15/8/27.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  个人中心卖家页面

#import "UserCenterViewController.h"
#import "ChargePlaceViewController.h"
#import "UserInfoViewController.h"
#import "BuyOnOtherForSellViewController.h"
#import "BuyOnOtherForBuyViewController.h"
#import "ResultViewController.h"
#import "SetViewController.h"
#import "UserCenterPostModel.h"
#import "FreePlaceViewController.h"
#import "CommonInterface.h"

#import "FolderSystemCollectionViewCell.h"
#import "FolderChargeCollectionViewCell.h"
#import "FolderCustomCollectionViewCell.h"

#import "EditFolderViewController.h"
#import "CreateFolderViewController.h"

#import "UserCenterViewController.h"
#import "VisitSellerViewController.h"
#import "VisitBuyerViewController.h"
#import "LoginViewController.h"
#import "ButtonView.h"

#import "Alipay.h"

#import <AlipaySDK/AlipaySDK.h>

#import "LoginView.h"

#import "CameraViewController.h"
#import "UIView+Extension.h"
#import "AppDelegate.h"
#import "SDImageView+SDWebCache.h"

@interface UserCenterViewController ()<UIScrollViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UIAlertViewDelegate , CameraDelagate>
{
    NSInteger emptyCount;//收费货位可以购买的剩余个数
}
@property(nonatomic , strong)NSMutableArray *postArray;
@property(nonatomic , strong)NSMutableArray *fileArray;
@property(nonatomic , strong)NSMutableArray *collectArray;

//自定义弹出框
@property(nonatomic , strong)UIView *bgView;
@property(nonatomic , strong)UIView *remindView1;

//标记收费货位帖子
@property(nonatomic , assign)BOOL chargePlaceIs0;

//新建文件夹cell标记
@property(nonatomic , assign)int createFolderCount;

//修改id
@property(nonatomic , copy)NSString *myID;

//身份转换
@property(nonatomic , copy)NSString *alipayNumber;
@property(nonatomic , strong)UIAlertView *freeAlert;
@property(nonatomic , strong)UIAlertView *alipayAlert;

//用户类型
@property(nonatomic , assign)BOOL isSeller;

//免费货位信息
@property(nonatomic , strong)NSDictionary *freeDic;

//交易信息
@property(nonatomic , copy)NSString *tradedId;
@property(nonatomic , copy)NSString *orderNumber;


//计数
@property(nonatomic , assign)int postCount;
@property(nonatomic , assign)int topCount;

//默认图
@property(nonatomic , strong)UIImageView *defaultImage;
@property(nonatomic , strong)UILabel *defaultLabel;


//刷新
@property(nonatomic , assign)int page;


@property(nonatomic , strong)LoginView *loginView;


//分区头

@property (nonatomic, strong) ButtonView *buttonView;


@property(nonatomic , strong)UIImageView *topView1;
@property(nonatomic , strong)UIButton *leftTopButton;
@property(nonatomic , strong)UIButton *rightTopButton;
@property(nonatomic , strong)UIButton *userHeardButton;
@property(nonatomic , strong)UIImageView *tagImageView;
@property(nonatomic , strong)UILabel *nameLabel;
@property(nonatomic , strong)UIButton *hotButton;
@property(nonatomic , strong)UIButton *attentionButton;
@property(nonatomic , strong)UIButton *fansButton;

@property(nonatomic , strong)UILabel *placeLabel;

@property(nonatomic , assign)int createPostCount;


@end

static NSString *userCenterPostCellID = @"userCenterSellerPostCellID";
static NSString *userCentercollectionCellID = @"userCenterSellerCollectionCellID";

static NSString *folderSystemCollectionViewCellID = @"FolderSystemCollectionViewCellID";
static NSString *folderChargeCollectionViewCellID = @"FolderChargeCollectionViewCellID";
static NSString *folderCustomCollectionViewCellID = @"FolderCustomCollectionViewCellID";
static NSString *folderFreeCellID = @"free";
static NSString *folderCreateCellID = @"newCreateCell";


@implementation UserCenterViewController

- (void)loadView
{
    [super loadView];
    
    self.userView = [[UserCenterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.userView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

    
    [HandyWay shareHandyWay].mayChangeHead = 5;
    
    if ([[CMData getUserId] isEqualToString:@""]) {
        
        [self isNotLogin];
        
        LoginViewController *vc = [LoginViewController new];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        self.loginView = (LoginView *)vc.view;
        
    }
    
    [self isLogin];
}

- (void)isNotLogin
{
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
    [left addTarget:self action:@selector(leftItemAction111) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];

}

//buttonView的触发方法:
- (void)btn1ActionInLogin:(UIButton *)sender {
    self.loginView.loginView.hidden = NO;
    self.loginView.rigisterView.hidden = YES;
}
- (void)btn2ActionInLogin:(UIButton *)sender {
    self.loginView.loginView.hidden = YES;
    self.loginView.rigisterView.hidden = NO;
}


- (void)leftItemAction111
{
        [[HandyWay shareHandyWay] setUserInfoWithNotLogin];
        
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"] animated:NO completion:nil];
}

- (void)isLogin
{
    self.postCount = 10;
    
    //
    self.myID = [[HandyWay shareHandyWay] changeUserId:[CMData getUserId]];
    
    self.topCount = 0;
    self.createFolderCount = 0;
    self.createPostCount = 0;
    self.page = 0;
    self.postArray = [NSMutableArray array];
    self.fileArray = [NSMutableArray array];
    self.collectArray = [NSMutableArray array];
    
    [self addCollectionView];
    
    [self setReminderView];
    
    [self networkRequestForPost];
    //    [self networkRequestForCollect];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:PYColor(@"000000")}];
    
    [self defaultImageViwe];
    
    //刷新加载
    [self reloadDataEvent];

    // 先查看本地是否有图片
    // TODO 需要本地图片缓存机制
    if (![HandyWay shareHandyWay].headUrl) {
        //根据保存的图片地址去找
        NSString* imagePath = [CMData getUserImage];
        if (imagePath&&![@"" isEqualToString:imagePath]) {
            [HandyWay shareHandyWay].headUrl = imagePath;
        }
        if (![HandyWay shareHandyWay].headUrl) {
            //根据获取的图片路径加载图片
            [HandyWay shareHandyWay].headUrl = [[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"userIcon/icon%@.jpg",self.myID]];
        }
    }
}


#pragma mark - 刷新加载
- (void)reloadDataEvent
{
    MJRefreshAutoGifFooter* footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 10;
        
        if (self.postCount == 10) {
            
            [self networkRequestForPost];
            
        }else if (self.postCount == 20){
            
            [self networkRequestForFile];
            
        }else if (self.postCount == 30){
            
            [self networkRequestForCollect];
            
        }
        
        [footer endRefreshing];
        
    }];
    footer.refreshingTitleHidden = YES;
    NSArray* refreshingImages = [CMTool getRefreshingImages];
    
    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateIdle];
    // 设置无新数据状态的动画图片
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_PERSONALCENTER_NOTE_LISTEND]] forState:MJRefreshStateNoMoreData];
    
    self.userView.postCollectionView.footer = footer;
    
}

- (void)removeAllArray
{
    self.page = 0;
    
    [self.postArray removeAllObjects];
    
    [self.collectArray removeAllObjects];
}


#pragma mark - 默认提示图片
- (void)defaultImageViwe
{
    self.defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake((fDeviceWidth - kCalculateH(100))/2, kCalculateV(271 + 30), kCalculateH(100), kCalculateH(100))];
    
    self.defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.defaultImage.frame) + kCalculateV(20), fDeviceWidth, 30)];
    self.defaultLabel.textAlignment = NSTextAlignmentCenter;
    self.defaultLabel.font = [UIFont systemFontOfSize:15];
}

- (void)addImageWithName:(NSString *)str label:(NSString *)reminder
{
    self.defaultImage.image = [UIImage imageNamed:str];
    self.defaultLabel.text = reminder;
    
    [self.userView.postCollectionView addSubview:self.defaultImage];
    [self.userView.postCollectionView addSubview:self.defaultLabel];
}

- (void)removeDefaultImage
{
    [self.defaultImage removeFromSuperview];
    [self.defaultLabel removeFromSuperview];
}

#pragma mark - 弹出框
- (void)setReminderView
{
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noResponseEvent)];
    [self.bgView addGestureRecognizer:tap];
    
    self.remindView1 = [[UIView alloc] initWithFrame:CGRectMake((fDeviceWidth - kCalculateH(280))/2, (fDeviceHeight - kCalculateV(201))/5*2, kCalculateH(280), kCalculateV(201))];
    self.remindView1.backgroundColor = [UIColor whiteColor];
    self.remindView1.layer.masksToBounds = YES;
    self.remindView1.layer.cornerRadius = kCalculateH(16);
    [self.bgView addSubview:self.remindView1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kCalculateV(22), self.remindView1.frame.size.width, kCalculateH(13))];
    label.text = @"想要购买收费货位吗？";
    label.font = [UIFont systemFontOfSize:kCalculateH(13)];
    label.textColor = PYColor(@"222222");
    label.textAlignment = NSTextAlignmentCenter;
    [self.remindView1 addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(17), kCalculateV(39), kCalculateH(246), kCalculateV(100))];
    imageView.image = [UIImage imageNamed:@"ic_set meal"];
    //    imageView.backgroundColor = [UIColor blueColor];
    [self.remindView1 addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(17), CGRectGetMaxY(imageView.frame) + kCalculateV(14), kCalculateH(246), kCalculateV(0.5))];
    view.backgroundColor = PYColor(@"c3c3c3");
    [self.remindView1 addSubview:view];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, CGRectGetMaxY(view.frame), CGRectGetWidth(self.remindView1.frame)/2, kCalculateV(47));
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(20)];
    [cancelButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.remindView1 addSubview:cancelButton];
    
    
    UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    ensureButton.frame = CGRectMake(CGRectGetMaxX(cancelButton.frame), CGRectGetMaxY(view.frame), CGRectGetWidth(self.remindView1.frame)/2, kCalculateV(47));
    ensureButton.backgroundColor = [UIColor whiteColor];
    ensureButton.titleLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(20)];
    [ensureButton setTitleColor:PYColor(@"007aff") forState:UIControlStateNormal];
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [ensureButton addTarget:self action:@selector(ensureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.remindView1 addSubview:ensureButton];
    
}

#pragma mark - 支付宝
- (void)ensureButtonAction:(UIButton *)sender
{
    
    [self.bgView removeFromSuperview];
//    [self.navigationController pushViewController:[ChargePlaceViewController new] animated:YES];
    
    //orderString 订单参数列表
    NSString *orderString = [Alipay getOrderString:self.orderNumber price:@"0.01"];
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
                
                [self paySucced];
            }
            else if ([resultStatus isEqualToString:@"8000"]){
                showStr=@"支付正在处理中，稍后可查看支付结果";
                
                [self paySucced];
            }
            else if ([resultStatus isEqualToString:@"6002"]){
                showStr=@"支付失败，请检查网络连接";
                
                [self payFail];
            }
            else if ([resultStatus isEqualToString:@"4000"]){
                showStr=@"支付失败";
                
                [self payFail];
            }
            else{//加入最后一个没有判断的分支，是为了适应支付宝的扩展
                showStr=@"支付失败";
                
                [self payFail];
            }
            
            [SVProgressHUD showInfoWithStatus:showStr];
        }
    }];

}


-(void)cancelButtonAction
{
    [self.bgView removeFromSuperview];
}

- (void)noResponseEvent
{
    
}

- (void)addAction
{
    //左上按钮
    [self.leftTopButton addTarget:self action:@selector(leftTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //右上按钮
    [self.rightTopButton addTarget:self action:@selector(rightTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //用户头像
    [self.userHeardButton addTarget:self action:@selector(userHeardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //热度按钮
    [self.hotButton addTarget:self action:@selector(hotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //关注数按钮
    [self.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //粉丝数按钮
    [self.fansButton addTarget:self action:@selector(fansButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //segment点击事件
    
    [self.buttonView.btn1 addTarget:self action:@selector(btn1Act:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView.btn2 addTarget:self action:@selector(btn2Act:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView.btn3 addTarget:self action:@selector(btn3Act:) forControlEvents:UIControlEventTouchUpInside];
    
}



#pragma mark - 各按钮点击事件

- (void)btn1Act:(UIButton *)sender {
    
    [self removeDefaultImage];
    [self removeAllArray];
    
    self.postCount = 10;
    [self networkRequestForPost];
}

- (void)btn2Act:(UIButton *)sender {
    
    [self removeDefaultImage];
    [self removeAllArray];
    
    self.postCount = 20;
    [self networkRequestForFile];
    
}

- (void)btn3Act:(UIButton *)sender {
    
    [self removeDefaultImage];
    [self removeAllArray];
    
    self.postCount = 30;
    [self networkRequestForCollect];
    
}


- (void)leftTopButtonAction:(UIButton *)sender
{
    self.navigationController.navigationBar.translucent = NO;
    if (self.isSeller) {
       [self.navigationController pushViewController:[BuyOnOtherForSellViewController new] animated:YES];
    }else{
        BuyOnOtherForBuyViewController* vc = [BuyOnOtherForBuyViewController new];
        vc.type = BuyOnOtherForBuyTypeSelf;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)rightTopButtonAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[SetViewController new] animated:YES];
}

- (void)userHeardButtonAction:(UIButton *)sender
{
    UserInfoViewController *vc = [UserInfoViewController new];
    
    if (self.isSeller) {
        vc.userType = @"2";
    }else{
        vc.userType = @"0";
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)hotButtonAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[ResultViewController new] animated:YES];
}

- (void)attentionButtonAction:(UIButton *)sender
{
    MyAttentionViewController *vc = [MyAttentionViewController new];
    vc.userId = [CMData getUserId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fansButtonAction:(UIButton *)sender
{
    MyFansViewController *vc = [MyFansViewController new];
    
    vc.userId = [CMData getUserId];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UIScrollView的代理方法

- (void)addCollectionView
{
    //帖子页面
    
    [self.userView.postCollectionView registerClass:[PostCollectionViewCell class] forCellWithReuseIdentifier:userCenterPostCellID];
    [self.userView.postCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"createPost"];
    
    self.userView.postCollectionView.delegate = self;
    self.userView.postCollectionView.dataSource = self;
    
    
    
    // 注册页眉（section的header）
    [self.userView.postCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"123456789"];

    //文件夹页面
    [self.userView.postCollectionView registerClass:[FolderSystemCollectionViewCell class] forCellWithReuseIdentifier:folderSystemCollectionViewCellID];
    [self.userView.postCollectionView registerClass:[FolderSystemCollectionViewCell class] forCellWithReuseIdentifier:folderFreeCellID];
    [self.userView.postCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:folderChargeCollectionViewCellID];
    [self.userView.postCollectionView registerClass:[FolderCustomCollectionViewCell class] forCellWithReuseIdentifier:folderCustomCollectionViewCellID];
    [self.userView.postCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:folderCreateCellID];
    
    
    //收藏页面
    [self.userView.postCollectionView registerClass:[PostCollectionViewCell class] forCellWithReuseIdentifier:userCentercollectionCellID];

}



#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isSeller) {
        if (self.postCount == 10) {
            
            return self.postArray.count + 1;
            
        }else if (self.postCount == 20){
            if (self.fileArray.count > 0) {
                return self.fileArray.count + 1;
            }
            return 0;
        }else if (self.postCount == 30){
            return self.collectArray.count;
        }
        
        
    }else{
        if (self.postCount == 10) {
            
            return self.postArray.count + 1;
            
        }else if (self.postCount == 20){
            if (self.fileArray.count > 0) {
                return self.fileArray.count + 2;
            }
            return 0;
        }else if (self.postCount == 30){
            return self.collectArray.count;
        }
        
    }
    
    return 0;
}


//设置collectionView的分区头(或分区脚)
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //判断到底是设置分区头还是分区脚
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        这种情况是设置分区头
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"123456789" forIndexPath:indexPath];
        headerView.backgroundColor = PYColor(@"ffffff");

        
        if (self.topCount == 0) {
            [self addSubviewsWithView:headerView];
            
            self.topCount++;
        }else{
            
        }
        
        
        return  headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"000000000" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor greenColor];
        return  footerView;
    }
}


- (void)addSubviewsWithView:(UICollectionReusableView *)view
{
    
    //上边浅色视图
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kCalculateV(93))];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.clipsToBounds = YES;
    
    self.topView1 = [[UIImageView alloc] initWithFrame:CGRectMake(-50, -50, fDeviceWidth + 100, kCalculateV(93) + 100)];
    self.topView1.backgroundColor = [UIColor lightGrayColor];
    self.topView1.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:self.topView1];

    [view addSubview:bgView];
    
    //左上角按钮
    CGFloat buttonW = kCalculateH(28);
    CGFloat buttonH = kCalculateV(28);
    
    self.leftTopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.leftTopButton.frame = CGRectMake(kCalculateH(16), kCalculateV(17), kCalculateV(25), kCalculateV(25));
    [self.leftTopButton setBackgroundImage:[UIImage imageNamed:@"btn_list"] forState:UIControlStateNormal];
    [view addSubview:self.leftTopButton];
    
    //右上角按钮
    self.rightTopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightTopButton.frame = CGRectMake(fDeviceWidth - kCalculateH(16) - buttonW, kCalculateV(17), buttonW, buttonH);
    [self.rightTopButton setBackgroundImage:[UIImage imageNamed:@"btn_shezhi"] forState:UIControlStateNormal];
    [view addSubview:self.rightTopButton];
    
    //用户头像
    CGFloat userHeadSize = kCalculateH(100);
    self.userHeardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.userHeardButton.layer.masksToBounds = YES;
    self.userHeardButton.layer.cornerRadius = userHeadSize/2;
    self.userHeardButton.layer.borderWidth = userHeadSize/100;
    self.userHeardButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [view addSubview:self.userHeardButton];
    self.userHeardButton.frame = CGRectMake((fDeviceWidth - userHeadSize)/2, kCalculateV(43), userHeadSize, userHeadSize);
    [self.userHeardButton setBackgroundImage:[UIImage imageNamed:@"ic_head"] forState:UIControlStateNormal];
    
    //标签视图？
    CGFloat tagImageViewSize = kCalculateH(30);
    self.tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(70), kCalculateV(78), tagImageViewSize, tagImageViewSize)];
//    self.tagImageView.image = [UIImage imageNamed:@"btn_weibo"];
    self.tagImageView.layer.masksToBounds = YES;
    self.tagImageView.layer.cornerRadius = tagImageViewSize/2;
    [view addSubview:self.tagImageView];
    
    //用户名
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userHeardButton.frame), CGRectGetMaxY(self.userHeardButton.frame) + kCalculateV(10), CGRectGetWidth(self.userHeardButton.frame), kCalculateH(16))];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(16)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = PYColor(@"7f7f7f");
    [view addSubview:self.nameLabel];
    
    //热度等级
    self.hotButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.hotButton.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + kCalculateH(5), CGRectGetMinY(self.nameLabel.frame), self.nameLabel.frame.size.height, self.nameLabel.frame.size.height);
    [view addSubview:self.hotButton];
    
    //关注数
    CGFloat buttonWith = kCalculateH(70);
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.attentionButton.frame = CGRectMake((fDeviceWidth - buttonWith * 2 - kCalculateH(10))/2, CGRectGetMaxY(self.nameLabel.frame) + kCalculateV(15), buttonWith, kCalculateH(13));
    [self.attentionButton setTitleColor:PYColor(@"7f7f7f") forState:UIControlStateNormal];
    self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    [view addSubview:self.attentionButton];
    
    //粉丝数
    self.fansButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.fansButton.frame = CGRectMake(CGRectGetMaxX(self.attentionButton.frame) + kCalculateH(5), CGRectGetMinY(self.attentionButton.frame), buttonWith, kCalculateH(13));
    [self.fansButton setTitleColor:PYColor(@"7f7f7f") forState:UIControlStateNormal];
    self.fansButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    [view addSubview:self.fansButton];
    
    //地点
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.attentionButton.frame) + kCalculateV(12), fDeviceWidth - 100, kCalculateV(15))];
    self.placeLabel.textAlignment = NSTextAlignmentCenter;
    self.placeLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.placeLabel.textColor = PYColor(@"7f7f7f");
    [view addSubview:self.placeLabel];
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.userHeardButton.frame) + kCalculateV(88), fDeviceWidth, kCalculateV(40));
    self.buttonView = [[ButtonView alloc] initWithFrame:frame andButtonArr:@[@"帖子", @"文件夹", @"收藏"]];
    _buttonView.btn1.selected = YES;
    [view addSubview:_buttonView];
    
    
    [self addAction];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //在这里分类处理
    if (self.postCount == 10) {
        //帖子页面
        
        if (indexPath.row == 0) {
            //新建
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"createPost" forIndexPath:indexPath];
            
            cell.backgroundColor = PYColor(@"ffffff");
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = kCalculateH(10);
            cell.layer.borderWidth = 1;
            cell.layer.borderColor = PYColor(@"d0d0d0").CGColor;
            
            if (self.createPostCount == 0) {
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(144 - 30)/2, kCalculateV(78), kCalculateH(30), kCalculateH(30))];
                imageV.image = [UIImage imageNamed:@"ic_me_note_addnew"];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(20), kCalculateV(120), kCalculateH(144-40), 18)];
                label.textColor = [UIColor lightGrayColor];
                label.font = [UIFont systemFontOfSize:kCalculateH(12)];
                label.text = @"添加一条帖子吧";
                label.textAlignment = NSTextAlignmentCenter;
                
                [cell.contentView addSubview:imageV];
                [cell.contentView addSubview:label];
                
                self.createPostCount++;
            }
            
            return cell;
            
        }

        PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userCenterPostCellID forIndexPath:indexPath];
        
        if (self.postArray.count > 0) {
            UserCenterPostModel *model = self.postArray[indexPath.row - 1];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, model.noteId]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            
            NSLog(@"%@" , [NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, model.noteId]);
            cell.commentButton.likesLabel.text = model.comments;
            [cell.commentButton addTarget:self action:@selector(cellCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentButton.tag = indexPath.row + 2000;
            
            cell.collectButton.likesLabel.text = model.likes;
            if ([model.isLiked isEqualToString:@"yes"]) {
                cell.collectButton.tagImage.image = [UIImage imageNamed:@"ic_press_like"];
            }else{
                cell.collectButton.tagImage.image = [UIImage imageNamed:@"ic_like"];
            }
            [cell.collectButton addTarget:self action:@selector(cellCollectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.collectButton.tag = indexPath.row + 3000;
        }
        
        return cell;
    }else if (self.postCount == 20){
        //文件夹页面
        
        if (self.isSeller) {
            if (self.fileArray.count > 0) {
                
                if (indexPath.row == 0) {
                    //免费货位
                    
                    FolderSystemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderFreeCellID forIndexPath:indexPath];
                    cell.topLabel.text = @"免费货位";
                    
                    NSArray *array = [NSArray arrayWithArray:self.fileArray[0][@"hotList"]];
                    
                    NSInteger count = array.count;
                    cell.reminderLabel.text = [NSString stringWithFormat:@"%d个帖子" , count];
                    
                    if (count > 0) {
                        
                        for (int i = 0; (i < count) && (i < 4); i++) {
                            if (i == 0) {
                                [cell.bottomImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[0][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                
                            }else if (i == 1){
                                [cell.bottomSmallImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[1][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                            }else if (i == 2){
                                [cell.bottomSmallImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[2][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                            }else if (i == 3){
                                [cell.bottomSmallImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[3][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                            }
                            
                        }
                    }else{
                        
                    }
                    
                    return cell;
                    
                }else if (indexPath.row == 1) {
                    //收费货位
                    
                    NSArray *array = [NSArray arrayWithArray:self.fileArray[1][@"hotList"]];
                    NSInteger count = array.count;
                    NSInteger payCount = [self.fileArray[1][@"payCount"] integerValue];
                    emptyCount = [self.fileArray[1][@"emptyCount"] integerValue];
                    
                    if (payCount > 0||count>0)
                    {
                        
                        FolderSystemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderSystemCollectionViewCellID forIndexPath:indexPath];
                        cell.topLabel.text = @"收费货位";
                        cell.reminderLabel.text = [NSString stringWithFormat:@"%d个帖子" , count];
                        
                        //收费货位不为0
                        self.chargePlaceIs0 = NO;
                        if (count > 0) {
                            //收费货位有帖子
                            
                            for (int i = 0; (i < count) && (i < 4); i++) {
                                if (i == 0) {
                                    [cell.bottomImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[0][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                    
                                    cell.bottomSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                                    cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                                    cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                                }else if (i == 1){
                                    [cell.bottomSmallImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[1][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                    
                                    cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                                    cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                                }else if (i == 2){
                                    [cell.bottomSmallImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[2][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                    
                                    cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                                }else if (i == 3){
                                    [cell.bottomSmallImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[3][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                }
                                
                            }
                            
                        }
                        else
                        {
                            cell.bottomImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
                            cell.bottomSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                            cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                            cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                        }
                        
                        return cell;
                        
                    }else{
                        //收费货位为0
                        self.chargePlaceIs0 = YES;
                        
                        FolderChargeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderChargeCollectionViewCellID forIndexPath:indexPath];
                        
                        cell.topLabel.text = @"收费货位";
                        cell.midImageView.image = [UIImage imageNamed:@"ic_lock2"];
                        [cell.bottomButton setTitle:@"购买" forState:UIControlStateNormal];
                        [cell.bottomButton addTarget:self action:@selector(addReminderEvent) forControlEvents:UIControlEventTouchUpInside];
                        return cell;
                        
                    }
                    
                    
                }else if (indexPath.row == 2) {
                    //默认文件夹
                    
                    FolderSystemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderSystemCollectionViewCellID forIndexPath:indexPath];
                    
                    cell.topLabel.text = @"默认文件夹";
                    NSArray *array = [NSArray arrayWithArray:self.fileArray[2][@"hotList"]];
                    NSInteger count = array.count;
                    
                    cell.reminderLabel.text = [NSString stringWithFormat:@"%d个帖子" , count];
                    
                    if (count > 0) {
                        
                        for (int i = 0; (i < count) && (i < 4); i++) {
                            if (i == 0) {
                                [cell.bottomImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[0][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                
                                cell.bottomSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                                cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                                cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                            }else if (i == 1){
                                [cell.bottomSmallImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[1][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];

                                cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                                cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                            }else if (i == 2){
                                [cell.bottomSmallImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[2][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                
                                cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                            }else if (i == 3){
                                [cell.bottomSmallImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[3][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                            }
                            
                        }
                    }else{
                        
                        cell.bottomImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
                        cell.bottomSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                        cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                        cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                    }
                    
                    return cell;
                    
                }else if (indexPath.row == self.fileArray.count) {
                    //新建文件夹
                    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderCreateCellID forIndexPath:indexPath];
                    
                    cell.backgroundColor = PYColor(@"ffffff");
                    cell.layer.masksToBounds = YES;
                    cell.layer.cornerRadius = kCalculateH(10);
                    cell.layer.borderWidth = 1;
                    cell.layer.borderColor = PYColor(@"d0d0d0").CGColor;
                    
                    if (self.createFolderCount == 0) {
                        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(33), kCalculateV(61), kCalculateH(144 - 33*2), kCalculateH(78))];
                        imageV.image = [UIImage imageNamed:@"ic_add folder"];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(20), kCalculateV(151), kCalculateH(144-40), 15)];
                        label.textColor = [UIColor lightGrayColor];
                        label.font = [UIFont systemFontOfSize:kCalculateH(12)];
                        label.text = @"新建文件夹";
                        label.textAlignment = NSTextAlignmentCenter;
                        
                        [cell.contentView addSubview:imageV];
                        [cell.contentView addSubview:label];
                        
                        self.createFolderCount++;
                    }
                    
                    return cell;
                }else if (indexPath.row > 2) {
                    
                    FolderCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderCustomCollectionViewCellID forIndexPath:indexPath];
                    
                    NSArray *array = [NSArray arrayWithArray:self.fileArray[indexPath.row][@"hotList"]];
                    cell.topLabel.text = self.fileArray[indexPath.row][@"placeName"];
                    
                    NSInteger count = array.count;
                    cell.midReminderLabel.text = [NSString stringWithFormat:@"%d个帖子" , count];
                    [cell.bottomButton setTitle:@"编辑" forState:UIControlStateNormal];
                    [cell.bottomButton addTarget:self action:@selector(editFolderEvent:) forControlEvents:UIControlEventTouchUpInside];
                    cell.bottomButton.tag = indexPath.row + 1000;
                    
                    if (count > 0) {

                        
                        for (int i = 0; (i < count) && (i < 4); i++) {
                            if (i == 0) {
                                [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[0][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];

                                cell.midSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                                cell.midSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                                cell.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                                
                            }else if (i == 1){
                                [cell.midSmallImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[1][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                
                                cell.midSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                                cell.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                                
                            }else if (i == 2){
                                [cell.midSmallImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[2][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                                
                                cell.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                                
                            }else if (i == 3){
                                [cell.midSmallImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[3][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                            }
                            
                        }
                    }else{
                        
                        cell.midImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
                        cell.midSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                        cell.midSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                        cell.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                    }
                    
                    return cell;
                }
                
            }else{
                
            }
            
        }else{
            //普通用户
            
            if (indexPath.row == 0) {
                //默认文件夹
                
                FolderSystemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderSystemCollectionViewCellID forIndexPath:indexPath];
                
                cell.topLabel.text = @"默认文件夹";
                NSArray *array = [NSArray arrayWithArray:self.fileArray[0][@"hotList"]];
                NSInteger count = array.count;
                
                cell.reminderLabel.text = [NSString stringWithFormat:@"%d个帖子" , count];
                
                if (count > 0) {
                    
                    for (int i = 0; (i < count) && (i < 4); i++) {
                        if (i == 0) {
                            [cell.bottomImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[0][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                        }else if (i == 1){
                            [cell.bottomSmallImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[1][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                        }else if (i == 2){
                            [cell.bottomSmallImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[2][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                        }else if (i == 3){
                            [cell.bottomSmallImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[3][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                        }
                        
                    }
                }else{
                    
                }
                
                return cell;
                
            }else if (indexPath.row == self.fileArray.count) {
                
                //新建文件夹
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderCreateCellID forIndexPath:indexPath];
                
                cell.backgroundColor = PYColor(@"ffffff");
                cell.layer.masksToBounds = YES;
                cell.layer.cornerRadius = kCalculateH(10);
                cell.layer.borderWidth = 1;
                cell.layer.borderColor = PYColor(@"d0d0d0").CGColor;
                
                if (self.createFolderCount == 0) {
                    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(33), kCalculateV(61), kCalculateH(144 - 33*2), kCalculateH(78))];
                    imageV.image = [UIImage imageNamed:@"ic_add folder"];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(20), kCalculateV(151), kCalculateH(144-40), 18)];
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"新建文件夹";
                    label.textAlignment = NSTextAlignmentCenter;
                    
                    [cell.contentView addSubview:imageV];
                    [cell.contentView addSubview:label];
                    
                    self.createFolderCount++;
                }
                
                return cell;
            }else if (indexPath.row == self.fileArray.count + 1){
                
                //免费货位
                FolderChargeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderChargeCollectionViewCellID forIndexPath:indexPath];
                
                cell.topLabel.text = @"免费货位";
                cell.midImageView.image = [UIImage imageNamed:@"ic_lock2"];
                [cell.bottomButton setTitle:@"解锁" forState:UIControlStateNormal];
                [cell.bottomButton addTarget:self action:@selector(freePlace) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                
            }else if (indexPath.row > 0){
                FolderCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderCustomCollectionViewCellID forIndexPath:indexPath];
                
                NSArray *array = [NSArray arrayWithArray:self.fileArray[indexPath.row][@"hotList"]];
                cell.topLabel.text = self.fileArray[indexPath.row][@"placeName"];
                
                NSInteger count = array.count;
                cell.midReminderLabel.text = [NSString stringWithFormat:@"%d个帖子" , count];
                [cell.bottomButton setTitle:@"编辑" forState:UIControlStateNormal];
                [cell.bottomButton addTarget:self action:@selector(editFolderEvent:) forControlEvents:UIControlEventTouchUpInside];
                cell.bottomButton.tag = indexPath.row + 1000;
                
                
                if (count > 0) {
                    

                    for (int i = 0; (i < count) && (i < 4); i++) {
                        if (i == 0) {
                            [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[0][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                            
                            cell.midSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                            cell.midSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                            cell.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];

                        }else if (i == 1){
                            [cell.midSmallImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[1][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                            
                            cell.midSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                            cell.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                            
                        }else if (i == 2){
                            [cell.midSmallImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[2][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                            
                            cell.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                            
                        }else if (i == 3){
                            [cell.midSmallImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[3][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
                        }
                        
                    }
                }else{
                    
                    cell.midImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
                    cell.midSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                    cell.midSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                    cell.midSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
                    
                }
                
                return cell;
                
            }
            
        }
        
        
    }
    
    //收藏页面
    
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userCentercollectionCellID forIndexPath:indexPath];
    
    if (self.collectArray.count > 0) {
        UserCenterPostModel *model = self.collectArray[indexPath.row];
        
        [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], [[HandyWay shareHandyWay] changeUserId:model.userId], model.noteId]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
        
        NSLog(@"%@" , [NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, model.noteId]);
        
                
        cell.commentButton.likesLabel.text = model.comments;
        [cell.commentButton addTarget:self action:@selector(cellCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentButton.tag = indexPath.row + 4000;
        
        cell.collectButton.likesLabel.text = model.likes;
        if ([model.isLiked isEqualToString:@"yes"]) {
            cell.collectButton.tagImage.image = [UIImage imageNamed:@"ic_press_like"];
        }else{
            cell.collectButton.tagImage.image = [UIImage imageNamed:@"ic_like"];
            
        }
        [cell.collectButton addTarget:self action:@selector(cellCollectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.collectButton.tag = indexPath.row + 5000;
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %d , row = %d" , indexPath.section , indexPath.row);
    
    if (self.isSeller) {
        if (self.postCount == 20) {
            //文件夹页面
            
            if (indexPath.row == 0) {
                
                FreePlaceViewController *vc = [FreePlaceViewController new];
                vc.itemID = self.fileArray[0][@"placeId"];
                vc.postCount = [self.fileArray[0][@"emptyCount"] intValue];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 1) {
                if (self.chargePlaceIs0) {
                    [self addReminderEvent];
                }else{
                    ChargePlaceViewController* vc = [ChargePlaceViewController new];
                    vc.emptyCount = emptyCount;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else if (indexPath.row == 2) {

                PostListViewController *postListVC = [PostListViewController new];
                postListVC.userId = [CMData getUserId];
                postListVC.itemID = self.fileArray[2][@"placeId"];
                postListVC.title = self.fileArray[2][@"placeName"];
                [self.navigationController pushViewController:postListVC animated:YES];
                
            }else if (indexPath.row == self.fileArray.count){
                
                [self.navigationController pushViewController:[CreateFolderViewController new] animated:YES];
                
            }else if (indexPath.row > 2){
                
                PostListViewController *postListVC = [PostListViewController new];
                postListVC.userId = [CMData getUserId];
                postListVC.itemID = self.fileArray[indexPath.row][@"placeId"];
                postListVC.title = self.fileArray[indexPath.row][@"placeName"];
                [self.navigationController pushViewController:postListVC animated:YES];
                
            }
        }
        
        
    }else{
        
        //普通用户
        if (self.postCount == 20) {
            //文件夹页面
            
            if (indexPath.row == 0) {
                
                PostListViewController *postListVC = [PostListViewController new];
                postListVC.userId = [CMData getUserId];
                postListVC.itemID = self.fileArray[0][@"placeId"];
                postListVC.title = self.fileArray[0][@"placeName"];
                [self.navigationController pushViewController:postListVC animated:YES];
                
                
            }else if (indexPath.row == self.fileArray.count) {
                [self.navigationController pushViewController:[CreateFolderViewController new] animated:YES];
                
            }else if (indexPath.row == self.fileArray.count + 1) {
                [self freePlace];
                
            }else if (indexPath.row > 0){
                
                PostListViewController *postListVC = [PostListViewController new];
                postListVC.userId = [CMData getUserId];
                postListVC.itemID = self.fileArray[indexPath.row][@"placeId"];
                postListVC.title = self.fileArray[indexPath.row][@"placeName"];
                [self.navigationController pushViewController:postListVC animated:YES];
            }
        }
        
    }
    
    if (self.postCount == 10) {
        
        
        if (indexPath.row == 0) {
            
            CameraViewController *vc = [[CameraViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            vc.delagate = self;
            vc.isFrist = YES;
            vc.type = CutTypeDefault;
            vc.ratio = 1.0f;
            [self presentViewController:nav
                               animated:YES completion:nil];
            
            
        }else{
            
            UserCenterPostModel *model = self.postArray[indexPath.row - 1];
            
            [[HandyWay shareHandyWay] pushToNoteDetailWithController:self NoteId:model.noteId UserId:model.userId];
            
        }

    }
    
    if (self.postCount == 30) {
        
        UserCenterPostModel *model = self.collectArray[indexPath.row];
        
        [[HandyWay shareHandyWay] pushToNoteDetailWithController:self NoteId:model.noteId UserId:model.userId];
    }
    
}


-(void)afterCut:(UIImage *)image ByViewController:(UIViewController*)viewC
{
    
}


#pragma mark - 警告框

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.freeAlert]) {
        if (buttonIndex == 1) {
            self.alipayAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //
            self.alipayAlert.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *textField= [self.alipayAlert textFieldAtIndex:0];
            textField.placeholder = @"请输入你的支付宝账户";
            
            //            textField.layer.cornerRadius = 5;
            //            textField.backgroundColor = PYColor(@"e7e7e7");
            [self.alipayAlert show];
        }
    }
    
    if ([alertView isEqual:self.alipayAlert]){
        if (buttonIndex == 1) {
            UITextField *textField= [alertView textFieldAtIndex:0];
            self.alipayNumber = textField.text;
            
            NSLog(@"turn %@" , self.alipayNumber);
            
            if ([[HandyWay shareHandyWay] isValidateEmail:self.alipayNumber] || [[HandyWay shareHandyWay] isValidatePhoneNumber:self.alipayNumber]) {
                
                [self turnToSeller];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"格式错误!"];
                
                self.alipayAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                //
                self.alipayAlert.alertViewStyle=UIAlertViewStylePlainTextInput;
                UITextField *textField= [self.alipayAlert textFieldAtIndex:0];
                textField.placeholder = @"请输入你的支付宝账户";
                [self.alipayAlert show];
            }

            
        }
    }
    
}



#pragma mark - 解锁免费货位

- (void)freePlace
{
    self.freeAlert = [[UIAlertView alloc] initWithTitle:nil message:@"是否能够提供海淘代购服务，并且解锁免费货位？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解锁", nil];
    [self.freeAlert show];
    
}

- (void)goFreePlaceAction
{
    
    FreePlaceViewController *vc = [FreePlaceViewController new];
    vc.itemID = self.freeDic[@"placeId"];
    vc.postCount = [self.freeDic[@"emptyCount"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 评论,点赞
- (void)cellCommentButtonAction:(UIButton *)sender
{
    NSLog(@"comment");
    
    CommentViewController *vc = [CommentViewController new];
    UserCenterPostModel *model = nil;
    if (sender.tag > 3000) {
        //收藏页面
        model = self.collectArray[sender.tag - 4000];
        
        vc.noteId = model.noteId;
        vc.noteOwnerId = model.userId;
        
    }else{
        //帖子页面
       model = self.postArray[sender.tag - 2000 - 1];
        
        
        vc.noteId = model.noteId;
        vc.noteOwnerId = model.userId;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.commentCount = ^(NSString *commentCount)
    {
        if (![commentCount isEqualToString:@"0"]) {
            
            model.comments =[NSString stringWithFormat:@"%d",[model.comments intValue ] +[commentCount intValue]];
            [self.userView.postCollectionView reloadData];
            return;
            
            
        }
    };
}

- (void)cellCollectButtonAction:(PostLikesButton *)sender
{
    NSLog(@"collect");
    if (sender.tag > 4000) {
        
        [[HandyWay shareHandyWay] postLikesWithButton:sender Array:self.collectArray tag:5000];
    }else{
        
        [[HandyWay shareHandyWay] postLikesWithButton:sender Array:self.postArray tag:3001];
    }
}

- (void)editFolderEvent:(UIButton *)sender
{
    //    FolderCustomCollectionViewCell *cell = (FolderCustomCollectionViewCell *)sender.superview;
    //    NSIndexPath *indexPath = [self.userView.fileCollectionView indexPathForCell:cell];
    //    NSLog(@"%ld" , indexPath.row);
    
    NSLog(@"%d" , sender.tag - 1000);
    
    EditFolderViewController *vc = [EditFolderViewController new];
    vc.placeID = [self.fileArray[sender.tag - 1001][@"placeId"] intValue];
    vc.isDelete = ((NSArray *)(self.fileArray[sender.tag - 1001][@"hotList"])).count;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 添加提示框购买收费货位
- (void)addReminderEvent
{
    [self verificationBuy];
}

#pragma mark - netWorking
//networkingForUserInfo(共用)
- (void)networkingRequestForSeller
{
    NSDictionary *param = @{@"targetUserId":@([CMData getUserIdForInt]),@"userId":@([CMData getUserIdForInt])};
    
    [CMAPI postUrl:API_USER_PRPFILE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"%@" , detailDict);
            //配置用户信息
            [self setUserInfoWithDctionary:detailDict[@"result"]];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

//帖子列表(共用)
- (void)networkRequestForPost
{
    NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"orderRanking":@(self.page),@"order":@(1),@"orderRule":@"myNotes"};
    
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"帖子列表*************%@" , detailDict);
            NSArray *arr = [NSMutableArray arrayWithArray:detailDict[@"result"][@"noteList"]];
            for (NSDictionary *dic in arr) {
                UserCenterPostModel *model = [[UserCenterPostModel alloc] initWithDictionary:dic];
                [self.postArray addObject:model];
            }
            
            [self.userView.postCollectionView reloadData];
            [self.userView.postCollectionView.footer resetNoMoreData];
            
        }else{
            
            if ([[[detailDict objectForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                [self.userView.postCollectionView reloadData];
                [self.userView.postCollectionView.footer noticeNoMoreData];
            }else{
                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
                
            }

        }
//        [self.userView.postCollectionView showEmptyList:self.postArray Image:IMG_DEFAULT_PERSONALCENTER_NOTE_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_NOTE_NODATASTRING ByCSS:NoDataCSSTop];
    }];
}

//文件夹(区分)
- (void)networkRequestForFile
{
    
    NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"type":@"all"};
    
    [CMAPI postUrl:API_GET_FOLODERSORSHELVES Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        
        NSDictionary* result= [detailDict objectForKey:RESULT];

        if (succeed) {
            NSLog(@"文件夹列表______________________%@" , detailDict);
            [self.fileArray removeAllObjects];
            
            if (self.isSeller) {
                
                [self.fileArray addObject:detailDict[@"result"][@"free"]];
                [self.fileArray addObject:detailDict[@"result"][@"pay"]];
                [self.fileArray addObject:detailDict[@"result"][@"sys"]];
                
                for (NSDictionary *dic in (NSArray*)detailDict[@"result"][@"custom"]) {
                    [self.fileArray addObject:dic];
                }
            }else{
                
                self.freeDic = [NSDictionary dictionaryWithDictionary:detailDict[@"result"][@"free"]];
                [self.fileArray addObject:detailDict[@"result"][@"sys"]];
                
                for (NSDictionary *dic in (NSArray*)detailDict[@"result"][@"custom"]) {
                    [self.fileArray addObject:dic];
                }
                
            }
            
            
            [self.userView.postCollectionView reloadData];
            
            if (self.fileArray.count > 0) {
                [self.userView.postCollectionView.footer noticeNoMoreData];
            }
        }
        
        else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            else
            {
                if (self.fileArray.count > 0) {
                    [self.userView.postCollectionView.footer noticeNoMoreData];
                }
            }
        }
    }];
    
}

//收藏(公用)
- (void)networkRequestForCollect
{
    NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"orderRanking":@(self.page),@"order":@(1),@"orderRule":@"collection"};
    
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        
        NSDictionary* result= [detailDict objectForKey:RESULT];
        if (succeed) {
            NSLog(@"收藏列表####################%@" , detailDict);
            NSArray *arr = [NSMutableArray arrayWithArray:detailDict[@"result"][@"noteList"]];
            for (NSDictionary *dic in arr) {
                UserCenterPostModel *model = [[UserCenterPostModel alloc] initWithDictionary:dic];
                [self.collectArray addObject:model];
            }
            
            [self.userView.postCollectionView reloadData];
            [self.userView.postCollectionView.footer resetNoMoreData];
            
        }else{
            
            if ([[[detailDict objectForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                
                if (self.collectArray.count > 0) {
                    
                }else{
                    [self addImageWithName:@"img_default_me_collectnote" label:@"你还没有任何收藏哦"];
                }
                
                
                [self.userView.postCollectionView reloadData];
                if (self.collectArray.count > 0) {
                    [self.userView.postCollectionView.footer noticeNoMoreData];
                }
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
        }
//        [self.userView.postCollectionView showEmptyList:self.postArray Image:IMG_DEFAULT_PERSONALCENTER_COLLECTION_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_COLLECTION_NODATA ByCSS:NoDataCSSTop];
    }];
    
}


//身份变更(买家)
- (void)turnToSeller
{
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"alipayAccount":self.alipayNumber};
   
    [CMAPI postUrl:API_USER_TURNTOSELLER Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"^_^恭喜你,免费货位已解锁,可以开启欢乐的代购之旅啦!"];
            
            //用户信息改变
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [documentPath stringByAppendingPathComponent:@"zpzUserInfo.plist"];
            NSDictionary *token = [NSDictionary dictionaryWithContentsOfFile:filePath];

            [token setValue:@"2" forKey:@"role"];
            [token writeToFile:filePath atomically:NO];
            
            self.isSeller = YES;
            [self networkRequestForFile];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}




//买货位前验证(卖家)
- (void)verificationBuy
{
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken]};
    
    NSLog(@"%@" , dic);
    
    [CMAPI postUrl:API_BUYSHELFAPPLY Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"订单************%@" , detailDict);
            
            NSString *str = detailDict[@"result"][@"out_trade_no"];
            if (str.length > 10) {
                self.orderNumber = detailDict[@"result"][@"out_trade_no"];
                self.tradedId = detailDict[@"result"][@"tradeId"];
                
                [self.view addSubview:self.bgView];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经没有可购买的货位了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}



#pragma mark - 得到数据后给页面赋值
- (void)setUserInfoWithDctionary:(NSDictionary *)dic
{
    //用户类型
    
    if ([dic[@"userType"] isEqualToString:@"0"]) {
        self.isSeller = NO;
    }else{
        self.isSeller = YES;
    }
    
    
    BOOL isThird = NO;
    
    if ([dic[@"thirdType"] isEqualToString:@"qq"]) {
        
        isThird = YES;
        self.tagImageView.image = [UIImage imageNamed:@"QQ"];
    }else if ([dic[@"thirdType"] isEqualToString:@"wx"]){
        
        isThird = YES;
        self.tagImageView.image = [UIImage imageNamed:@"weixin"];
        
    }else if ([dic[@"thirdType"] isEqualToString:@"wb"]){
        
        isThird = YES;
        self.tagImageView.image = [UIImage imageNamed:@"weibo"];
        
    }else{
        
        isThird = NO;
        self.tagImageView.hidden = YES;
    }

    if (isThird) {
        [self.userHeardButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[HandyWay shareHandyWay].headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
        [self.topView1 getGSImageWithDegree:90.0];
    }else{
    
//    [self.userHeardButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_default_me_user"] options:SDWebImageRefreshCached];
    
        if ([HandyWay shareHandyWay].mayChangeHead == 5 || [HandyWay shareHandyWay].mayChangeHead == 2) {
//
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]] options:SDWebImageDownloaderProgressiveDownload progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        
//        if (image) {
//            
//        }else{
//            image = [UIImage imageNamed:@"img_default_me_user"];
//        }
//
//        [self.userHeardButton setBackgroundImage:image forState:UIControlStateNormal];
//            
//        
//    }];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]];
           
//           [[SDImageCache sharedImageCache] removeImageForKey:[url absoluteString] fromDisk:YES withCompletion:^{
//                         [self.userHeardButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_default_me_user"] options:SDWebImageRefreshCached ];
//               
//           }];
//         
    [self.userHeardButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
            
            
            if ([HandyWay shareHandyWay].mayChangeHead == 5) {
                
                [HandyWay shareHandyWay].mayChangeHead = 2;
            }else{
                
                [HandyWay shareHandyWay].mayChangeHead = 0;

            }
            
        }
    NSLog(@"头像头像..............%@" , [NSString stringWithFormat:@"%@userIcon/icon%@.jpg" , [CMData getCommonImagePath] , [CMData getUserId]]);
    }
    
    [self.topView1 getGSImageWithDegree:90.0 ByUserId:[CMData getUserId]];
    
    self.nameLabel.text = dic[@"targetDisplayName"];
    
    
    [self.hotButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_%@" , dic[@"level"]]] forState:UIControlStateNormal];
    
    [self.attentionButton setTitle:[NSString stringWithFormat:@"关注:%@" , dic[@"followings"]] forState:UIControlStateNormal];
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝:%@" , dic[@"followedUsers"]] forState:UIControlStateNormal];
    
    
    if (self.isSeller) {
        
        NSArray *arr = [NSArray arrayWithArray:dic[@"credit"]];
        if (arr.count == 0) {
            
        }else if (arr.count == 1){
            self.placeLabel.text = [NSString stringWithFormat:@"🔴 %@" , arr[0]];
        }else if (arr.count == 2){
            self.placeLabel.text = [NSString stringWithFormat:@"🔴 %@ %@" , arr[0] , arr[1]];
        }else if (arr.count > 2){
            self.placeLabel.text = [NSString stringWithFormat:@"🔴 %@ %@ %@" , arr[0] , arr[1] , arr[2]];
        }
        
    }
    
    //    //知道用户身份后才能加载文件夹列表
//        if (self.postCount == 10) {
//            [self networkRequestForPost];
//    
//        }else if (self.postCount == 20){
//            [self networkRequestForFile];
//    
//        }else if (self.postCount == 30){
//            [self networkRequestForCollect];
//    
//        }
    
    if (self.postCount == 20) {
        [self networkRequestForFile];
        
    }
    
    
}


#pragma mark - 每次进入页面更新用户信息
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if ([[CMData getUserId] isEqualToString:@""]){
        
    }else{
    
    [self networkingRequestForSeller];
        
    self.navigationController.navigationBarHidden = YES;
    }

}


- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


- (void)payFail
{
    NSDictionary *dic = @{@"tradeId":self.tradedId,@"type":@"shelf"};
    
    [CMAPI postUrl:API_PAYFAIL Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
           
        }else{
            
        }
    }];
}

- (void)paySucced
{
    NSDictionary *dic = @{@"tradeId":self.tradedId,@"type":@"shelf"};
    
    [CMAPI postUrl:API_PAYSUCCED Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
        }else{
            
        }
    }];
}

- (BOOL) prefersStatusBarHidden
{
    if ([[CMData getUserId] isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

@end
