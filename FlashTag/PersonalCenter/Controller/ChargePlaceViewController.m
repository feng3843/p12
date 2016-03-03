//
//  ChargePlaceViewController.m
//  FlashTag
//
//  Created by MyOS on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  收费货位页面

#import "ChargePlaceViewController.h"
#import "RemindTableViewCell.h"
#import "ChargePlaceModel.h"

#import "Alipay.h"

#import <AlipaySDK/AlipaySDK.h>


@interface ChargePlaceViewController ()<UIScrollViewDelegate , UICollectionViewDataSource , UICollectionViewDelegate , UIActionSheetDelegate , UIAlertViewDelegate , UITableViewDelegate , UITableViewDataSource>


@property(nonatomic , strong)NSMutableArray *allArray;
@property(nonatomic , strong)NSMutableArray *idleArray;
@property(nonatomic , strong)NSMutableArray *dueArray;

//转移货位
@property(nonatomic , strong)UITableView *reminderTableView;
@property(nonatomic , strong)UIView *reminderBg;

//自定义弹出框
@property(nonatomic , strong)UIView *bgView;
@property(nonatomic , strong)UIView *remindView1;
@property(nonatomic , strong)UILabel *reminderLabel;

//续费
@property(nonatomic , strong)UIAlertView *continueAlert;
@property(nonatomic , copy)NSString *groupId;

@property(nonatomic , copy)NSString *myID;


//交易信息
@property(nonatomic , copy)NSString *tradedId;
@property(nonatomic , copy)NSString *orderNumber;


@end

static NSString *chargePlaceCellID = @"chargePlaceCellID";
static NSString *firstCell = @"first";
static NSString *dueCell = @"due";

@implementation ChargePlaceViewController

- (void)loadView
{
    [super loadView];
    
    self.chargePlaceView = [[ChargePlaceView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.chargePlaceView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收费货位";

    
    //
    self.myID = [[HandyWay shareHandyWay] changeUserId:[CMData getUserId]];
    
    self.allArray = [NSMutableArray array];
    self.idleArray = [NSMutableArray array];
    self.dueArray = [NSMutableArray array];
    
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //segment点击事件
    [self.chargePlaceView.buttonView.btn1 addTarget:self action:@selector(btn1Act:) forControlEvents:UIControlEventTouchUpInside];
    [self.chargePlaceView.buttonView.btn2 addTarget:self action:@selector(btn2Act:) forControlEvents:UIControlEventTouchUpInside];
    [self.chargePlaceView.buttonView.btn3 addTarget:self action:@selector(btn3Act:) forControlEvents:UIControlEventTouchUpInside];
    
    //showScrollView滑动改变segment选中状态
    self.chargePlaceView.showScrollView.delegate = self;
    
    [self addCollectionView];
    
//    [self setReminderTableViewAction];
    [self setReminderView];
    
    [self networkRequestForPlace];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 转移帖子
//- (void)setReminderTableViewAction
//{
//    self.reminderBg = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.reminderBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noResponseEvent)];
//    [self.reminderBg addGestureRecognizer:tap];
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(20), (fDeviceHeight - kCalculateV(324))*1/3, kCalculateH(280), kCalculateV(324))];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = kCalculateH(16);
//    view.backgroundColor = [UIColor whiteColor];
//    [self.reminderBg addSubview:view];
//    
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    cancelButton.frame = CGRectMake(kCalculateH(21), kCalculateV(20), kCalculateH(18), kCalculateH(18));
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:cancelButton];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame) + kCalculateH(49), 0, 120, kCalculateV(49))];
//    label.text = @"转移至文件夹";
//    [view addSubview:label];
//    
//    UIView *divideLine = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(16), kCalculateV(48), kCalculateH(280-32), kCalculateV(1))];
//    divideLine.backgroundColor = PYColor(@"c3c3c3");
//    [view addSubview:divideLine];
//    
//    
//    self.reminderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kCalculateV(49), kCalculateH(280), kCalculateV(220 - 2))];
//    [view addSubview:self.reminderTableView];
//    //
//    self.reminderTableView.bounces = NO;
//    //
//    self.reminderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //
//    self.reminderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.reminderTableView.delegate = self;
//    self.reminderTableView.dataSource = self;
//    
//    
//    UIView *divideLine2 = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(16), CGRectGetMaxY(self.reminderTableView.frame), kCalculateH(280-32), kCalculateV(1))];
//    divideLine2.backgroundColor = PYColor(@"c3c3c3");
//    [view addSubview:divideLine2];
//    
//    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    addButton.frame = CGRectMake(kCalculateH(21), CGRectGetMaxY(divideLine2.frame) + kCalculateV(14), kCalculateH(20), kCalculateH(20));
//    [addButton setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:addButton];
//    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addButton.frame) + kCalculateH(10), CGRectGetMaxY(divideLine2.frame), 120, kCalculateV(49))];
//    label2.text = @"新建文件夹";
//    [view addSubview:label2];
//    
//    
//}

- (void)noResponseEvent
{
    
}

//#pragma mark - tableView delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"reminder";
//    RemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (nil == cell) {
//        cell = [[RemindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    
//    cell.leftImage.image = [UIImage imageNamed:@"test2.jpg"];
//    cell.label.text = @"dwqfwefwefewfwef";
//    
//    if (indexPath.row == 9) {
//        cell.divideLine.hidden = YES;
//    }
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return kCalculateV(55);
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"00000");
//}
//
//- (void)cancelAction
//{
//    [self.reminderBg removeFromSuperview];
//}
//
//
//- (void)addAction
//{
//    
//}


#pragma mark - 左侧返回按钮
- (void)btn1Act:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.chargePlaceView.showScrollView.contentOffset = CGPointMake(0, 0);
    }];
}
- (void)btn2Act:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.chargePlaceView.showScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    }];
}
- (void)btn3Act:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.chargePlaceView.showScrollView.contentOffset = CGPointMake(2 * self.view.frame.size.width, 0);
    }];
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIScrollView的代理方法
// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = self.chargePlaceView.showScrollView.contentOffset;
    
    if (offset.x == 0) {
        
        [self.chargePlaceView.buttonView btn1Action:self.chargePlaceView.buttonView.btn1];
    } else if (offset.x == fDeviceWidth) {
        
        [self.chargePlaceView.buttonView btn2Action:self.chargePlaceView.buttonView.btn2];
    } else {
        
        [self.chargePlaceView.buttonView btn3Action:self.chargePlaceView.buttonView.btn3];
    }
}

- (void)addCollectionView
{
    //全部货位
    [self.chargePlaceView.allCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:chargePlaceCellID];
    [self.chargePlaceView.allCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:firstCell];
    [self.chargePlaceView.allCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:dueCell];
    self.chargePlaceView.allCollectionView.delegate = self;
    self.chargePlaceView.allCollectionView.dataSource = self;
    
    //闲置货位
    [self.chargePlaceView.idleCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:chargePlaceCellID];
    [self.chargePlaceView.idleCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:dueCell];
    self.chargePlaceView.idleCollectionView.delegate = self;
    self.chargePlaceView.idleCollectionView.dataSource = self;
    
    //已到期货位
    [self.chargePlaceView.dueCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:dueCell];
    self.chargePlaceView.dueCollectionView.delegate = self;
    self.chargePlaceView.dueCollectionView.dataSource = self;
    
}


#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.chargePlaceView.allCollectionView]) {
        
        return self.allArray.count + 1;
        
    }else if ([collectionView isEqual:self.chargePlaceView.idleCollectionView]){
        if (self.idleArray.count > 0) {
            return self.idleArray.count;
        }
        return 0;
    }else{
        return self.dueArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //在这里分类处理
    if ([collectionView isEqual:self.chargePlaceView.allCollectionView]) {
        //全部货位
        
        if (indexPath.row == 0) {
            FolderChargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstCell forIndexPath:indexPath];
            
            cell.topLabel.text = @"收费货位";
            [cell.bottomButton setTitle:@"购买" forState:UIControlStateNormal];
            cell.midImageView.image = [UIImage imageNamed:IMG_DEFAULT_PLACE_CHARGE_LOCK];
            [cell.bottomButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
          //  cell.dueImageView.hidden = NO;
          //  cell.midImageView.hidden = NO;
            return cell;
        }else{
            
            ChargePlaceModel *model = self.allArray[indexPath.row - 1];
            FolderChargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dueCell forIndexPath:indexPath];
            cell.topLabel.text = model.fileName;
            if ([self.dueArray containsObject:model]) {
                
                
                cell.bottomLabel.text = @"已到期";
                cell.bottomLabel.textColor = PYColor(@"f72525");
                
                [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, model.noteId]] placeholderImage:nil];
                
                cell.dueImageView.image = [UIImage imageNamed:IMG_DEFAULT_PLACE_CHARGE_DEADLINE];
                cell.dueImageView.hidden = NO;
                cell.midImageView.hidden = NO;
            }
            else
            {
                if ([self.idleArray containsObject:model]){
                    
                    cell.midImageView.hidden = YES;
                    cell.dueImageView.image = [UIImage imageNamed:IMG_DEFAULT_PLACE_CHARGE_UNUSE];
                    cell.dueImageView.hidden = NO;
                }
                else
                {
                     cell.midImageView.hidden = NO;
                    [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, model.noteId]] placeholderImage:nil];
                    cell.dueImageView.hidden = YES;
                }
                
                cell.bottomLabel.text = [NSString stringWithFormat:@"🕒剩余%@天" , model.leftDays];;
                cell.bottomLabel.textColor = PYColor(@"acacac");
                
                
            }
            
            return cell;
        }
        
    }else if ([collectionView isEqual:self.chargePlaceView.idleCollectionView]){
        //闲置货位
        ChargePlaceModel *model = self.idleArray[indexPath.row];
        
        if ([self.dueArray containsObject:model]) {
            FolderChargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dueCell forIndexPath:indexPath];
            cell.topLabel.text = model.fileName;
            cell.midImageView.image = [UIImage imageNamed:@"ic_lock2"];
            cell.bottomLabel.text = @"已到期";
            cell.bottomLabel.textColor = PYColor(@"f72525");
//            cell.dueImageView.image = [UIImage imageNamed:@"ic_lock"];
     
            return cell;
        }else{
            FolderChargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:chargePlaceCellID forIndexPath:indexPath];
            cell.topLabel.text = model.fileName;
            cell.midImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
            cell.bottomLabel.text = [NSString stringWithFormat:@"🕒剩余%@天" , model.leftDays];
            cell.bottomLabel.textColor = PYColor(@"acacac");
            
            return cell;
        }
    }
    
    
    //到期货位
    
    ChargePlaceModel *model = self.dueArray[indexPath.row];
    FolderChargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dueCell forIndexPath:indexPath];
    cell.topLabel.text = model.fileName;
    [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, model.noteId]] placeholderImage:[UIImage imageNamed:@"ic_lock"]];
    cell.bottomLabel.text = @"已到期";
    cell.bottomLabel.textColor = PYColor(@"f72525");
    cell.dueImageView.image = [UIImage imageNamed:IMG_DEFAULT_PLACE_CHARGE_DEADLINE];
//    cell.dueImageView.image = [UIImage imageNamed:@"ic_lock"];
//    if ([self.idleArray containsObject:model]) {
//        cell.dueImageView.hidden = YES;
//    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %d , row = %d" , indexPath.section , indexPath.row);
    if ([collectionView isEqual:self.chargePlaceView.dueCollectionView]) {
        //到期页面
        
        //
        ChargePlaceModel *model = self.dueArray[indexPath.row];
        self.groupId = model.groupId;
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"此货位已过期，您可以执行以下操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"续费" otherButtonTitles:nil, nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        [sheet showInView:self.view];
    }else if ([collectionView isEqual:self.chargePlaceView.idleCollectionView]) {
        //闲置页面
        
        ChargePlaceModel *model = self.idleArray[indexPath.row];
        
        //判断是否到期
        if ([self.dueArray containsObject:model]) {
            self.groupId = model.groupId;
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"此货位已过期，您可以执行以下操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"续费" otherButtonTitles:nil, nil];
            sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            
            [sheet showInView:self.view];
        }else{
            //写帖子?
            
        }
        
    }else{
        //全部页面
        
        
        //判断货位类型
        if (indexPath.row == 0) {
            //购买货位
            [self buyAction];
        }else{
            ChargePlaceModel *model = self.allArray[indexPath.row - 1];
            
            if ([self.dueArray containsObject:model]) {
                self.groupId = model.groupId;
                
                UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"此货位已过期，您可以执行以下操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"续费" otherButtonTitles:nil, nil];
                sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                
                [sheet showInView:self.view];
            }else if ([self.idleArray containsObject:model]){
                //写帖子
#warning 写帖子
                
            }else{
                //看帖子
                
                ChargePlaceModel *model = self.allArray[indexPath.row - 1];
                
                [[HandyWay shareHandyWay] pushToNoteDetailWithController:self NoteId:model.noteId UserId:[CMData getUserId]];
            }
        }
    }
    
}

#pragma mark - actionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self goOn];
            break;
        case 1:
            ;
            break;
            
        default:
            break;
    }
}

- (void)goOn
{
    [self networkRequestForContinue];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if ([alertView isEqual:self.continueAlert]) {
//        if (buttonIndex == 1) {
//            [self ensureButtonAction];
//        }
//    }
}

- (void)buyAction
{
    NSLog(@"buy");
    
    if (self.emptyCount>0) {
        [self verificationBuy];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经没有可购买的货位了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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
    
    self.reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCalculateV(22), self.remindView1.frame.size.width, kCalculateH(13))];
    self.reminderLabel.text = @"想要购买收费货位吗？";
    self.reminderLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.reminderLabel.textColor = PYColor(@"222222");
    self.reminderLabel.textAlignment = NSTextAlignmentCenter;
    [self.remindView1 addSubview:self.reminderLabel];
    
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
    [ensureButton addTarget:self action:@selector(ensureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.remindView1 addSubview:ensureButton];
    
}


#pragma mark - 支付宝
- (void)ensureButtonAction
{

    [self.bgView removeFromSuperview];
    
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

//- (void)noResponseEvent
//{
//
//}



#pragma mark - networkRequest
- (void)networkRequestForPlace
{
    NSDictionary *param = @{@"userId":[CMData getUserId]};
    
    [CMAPI postUrl:API_GETPAYSHELFINFO Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        if (succeed) {
            NSLog(@"帖子列表*************%@" , detailDict);
            NSArray *arr = [NSMutableArray arrayWithArray:detailDict[@"result"][@"shelfList"]];
            for (NSDictionary *dic in arr) {
                ChargePlaceModel *model = [[ChargePlaceModel alloc] initWithDictionary:dic];
                if([model.leftDays isEqualToString:@"0"])
                {
                     [self.dueArray addObject:model];
                }
//                if ([[HandyWay shareHandyWay] judgeDueWithTime:model.expireTime]) {
//
//                }
                else
                {
                    if ([model.noteId isEqualToString:@"0"] || [model.noteId isEqualToString:@"null"] || [model.noteId isEqualToString:@""]) {
                        [self.idleArray addObject:model];
                        
                    }
                }
                
                [self.allArray addObject:model];
            }
            
            [self.chargePlaceView.allCollectionView reloadData];
            [self.chargePlaceView.idleCollectionView reloadData];
            [self.chargePlaceView.dueCollectionView reloadData];
            
        }else{
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
        }
    }];
}


//买货位前验证
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
                self.reminderLabel.text = @"想要购买收费货位吗？";
            }
        }else{
            if (![[[detailDict valueForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[[detailDict valueForKey:@"result"] objectForKey:@"reason"]];
            }
        }
    }];
}


- (void)networkRequestForContinue
{
    
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"groupId":self.groupId};
    
    NSLog(@"%@" , dic);
    
    [CMAPI postUrl:API_continueShelfApply Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"订单************%@" , detailDict);
            
            NSString *str = detailDict[@"result"][@"out_trade_no"];
            
            
            if (str.length > 10) {
                
                self.orderNumber = detailDict[@"result"][@"out_trade_no"];
                self.tradedId = detailDict[@"result"][@"tradeId"];

                
                [self.view addSubview:self.bgView];
                self.reminderLabel.text = @"想要续费吗？";
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"续费出错了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }else{
            if (![[[detailDict valueForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[[detailDict valueForKey:@"result"] objectForKey:@"reason"]];
            }
        }
    }];
    
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
            self.emptyCount -= 5;
        }else{
            
        }
    }];
}

@end
