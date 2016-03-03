    //
//  BuyOnOtherForBuyViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购页面买

#import "BuyOnOtherForBuyViewController.h"
#import "BuyOnOtherForBuyView.h"
#import "OrderCell.h"
#import "BuyDetailViewController.h"

#import "BuyOnOtherForSellViewController.h"
#import "LibCM.h"
#import "VisitBuyerViewController.h"
#import "MJRefresh.h"
#import "NSString+Extensions.h"
#import "NSDate+Extensions.h"



@interface BuyOnOtherForBuyViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic , strong)BuyOnOtherForBuyView *buyOnOtherForBuyView;

@property(nonatomic)NSDictionary* dicAll;

@property(nonatomic)NSDictionary* dicRefunded;

@property(nonatomic)NSDictionary* dicHuowei;

//操作确认使用
@property(nonatomic)NSString* uType;
@property(nonatomic)NSString* action;
@property(nonatomic)NSString* tradeID;
@property(nonatomic)NSString* wReload;

@end

@implementation BuyOnOtherForBuyViewController

- (void)loadView
{
    [super loadView];
    
    self.title = @"买";
    self.buyOnOtherForBuyView = [[BuyOnOtherForBuyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.buyOnOtherForBuyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == BuyOnOtherForBuyTypeSelf)
    {
        self.title = @"我的代购";
    }
    else
    {
        self.title = @"买";
    }
    self.buyOnOtherForBuyView.type = self.type;
    
    [self.buyOnOtherForBuyView.allButton addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buyOnOtherForBuyView.refundButton addTarget:self action:@selector(refundButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.type == BuyOnOtherForBuyTypeDefault)
    {
        [self.buyOnOtherForBuyView.placeButton addTarget:self action:@selector(placeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.buyOnOtherForBuyView.allTableView.delegate = self;
    self.buyOnOtherForBuyView.allTableView.dataSource = self;
    
    self.buyOnOtherForBuyView.refundTableView.delegate = self;
    self.buyOnOtherForBuyView.refundTableView.dataSource = self;
    
    if(self.type == BuyOnOtherForBuyTypeDefault)
    {
        self.buyOnOtherForBuyView.placeTableView.delegate = self;
        self.buyOnOtherForBuyView.placeTableView.dataSource = self;
    }
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    //LA  增加 组件初始化  数据初始化
    [self CompInit];
    [self DataInit];
}

//LA func start
-(void)CompInit{
    MJRefreshNormalHeader* header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self networkRequestForAllForNewData:YES];
    }];
    header.stateLabel.font=[UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font=[UIFont systemFontOfSize:14];
    header.stateLabel.textColor=[UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor=[UIColor grayColor];
    self.buyOnOtherForBuyView.allTableView.header=header;
    
    header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self networkRequestForRefundForNewData:YES];
    }];
    header.stateLabel.font=[UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font=[UIFont systemFontOfSize:14];
    header.stateLabel.textColor=[UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor=[UIColor grayColor];
    self.buyOnOtherForBuyView.refundTableView.header=header;
    
    if (self.type == BuyOnOtherForBuyTypeDefault) {
        header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self networkRequestForPlace];
        }];
        header.stateLabel.font=[UIFont systemFontOfSize:15];
        header.lastUpdatedTimeLabel.font=[UIFont systemFontOfSize:14];
        header.stateLabel.textColor=[UIColor grayColor];
        header.lastUpdatedTimeLabel.textColor=[UIColor grayColor];
        self.buyOnOtherForBuyView.placeTableView.header=header;
    }
    
    MJRefreshAutoGifFooter* footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [self networkRequestForAllForNewData:NO];
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
    
    self.buyOnOtherForBuyView.allTableView.footer = footer;
    
    footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [self networkRequestForRefundForNewData:NO];
        [footer endRefreshing];
    }];
    footer.refreshingTitleHidden = YES;
    
    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateIdle];
    // 设置无新数据状态的动画图片
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_PERSONALCENTER_NOTE_LISTEND]] forState:MJRefreshStateNoMoreData];
    
    self.buyOnOtherForBuyView.refundTableView.footer = footer;
}

-(void)DataInit
{
    _dicAll=[[NSDictionary alloc]init];
    _dicRefunded=[[NSDictionary alloc]init];
    _dicHuowei=[[NSDictionary alloc]init];
    
    [self networkRequestForAllForNewData:YES];
    
    //注册通知事件
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(getNotification:) name:NOTIFICATION_DINGDAN_RELOAD object:nil];
}

-(void)getNotification:(NSNotification*)notification
{
    //更新
    [self networkRequestForAllForNewData:YES];
    [self networkRequestForRefundForNewData:YES];
}

//LA  func end

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)allButtonAction:(UIButton *)sender
{
    self.buyOnOtherForBuyView.allTableView.hidden = NO;
    self.buyOnOtherForBuyView.refundTableView.hidden = YES;
    self.buyOnOtherForBuyView.placeTableView.hidden = YES;
    
    
    [sender setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    
    [self.buyOnOtherForBuyView.refundButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    
    [self.buyOnOtherForBuyView.placeButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
}

- (void)refundButtonAction:(UIButton *)sender
{
    self.buyOnOtherForBuyView.allTableView.hidden = YES;
    self.buyOnOtherForBuyView.refundTableView.hidden = NO;
    self.buyOnOtherForBuyView.placeTableView.hidden = YES;
    
    [self networkRequestForRefundForNewData:YES];
    
    [sender setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    
    [self.buyOnOtherForBuyView.allButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    
    [self.buyOnOtherForBuyView.placeButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
}

- (void)placeButtonAction:(UIButton *)sender
{
    self.buyOnOtherForBuyView.allTableView.hidden = YES;
    self.buyOnOtherForBuyView.refundTableView.hidden = YES;
    self.buyOnOtherForBuyView.placeTableView.hidden = NO;
    
    if (self.type == BuyOnOtherForBuyTypeDefault) {
        [self networkRequestForPlace];
    }
    
    [sender setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    
    [self.buyOnOtherForBuyView.allButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];

    [self.buyOnOtherForBuyView.refundButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //LA  修改
    if ([tableView isEqual:self.buyOnOtherForBuyView.allTableView]) {
        NSString* strFlg=@"new";
        if (section == 0) {
            strFlg=@"new";
        }else if (section == 1){
            strFlg=@"processing";
        }else if (section == 2){
            strFlg=@"completed";
        }
        NSInteger ct=0;
        NSMutableArray* arrTmp;
        arrTmp=[[_dicAll valueForKey:strFlg] mutableCopy];
        if(arrTmp)
            ct=arrTmp.count*2-1;
        return ct;
        
    }else if ([tableView isEqual:self.buyOnOtherForBuyView.refundTableView]){
        NSString* strFlg=@"refunding";
        if (section == 0) {
            strFlg=@"refunding";
        }else if (section == 1){
            strFlg=@"refunded";
        }
        NSInteger ct=0;
        NSMutableArray* arrTmp;
        arrTmp=[[_dicRefunded valueForKey:strFlg] mutableCopy];
        if(arrTmp)
            ct=arrTmp.count*2-1;
        return ct;
    }else if ([tableView isEqual:self.buyOnOtherForBuyView.placeTableView]){
        //LA  需要修改
        NSString* strFlg=@"handling";
        if (section == 0) {
            strFlg=@"handling";
        }else if (section == 1){
            strFlg=@"success";
        }
        
        NSInteger ct=0;
        NSMutableArray* arrTmp;
        arrTmp=[[_dicHuowei valueForKey:strFlg] mutableCopy];
        if(arrTmp)
            ct=arrTmp.count*2-1;
        return ct;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.buyOnOtherForBuyView.allTableView]) {
        return 3;
    }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.buyOnOtherForBuyView.allTableView]) {
        if (section == 0) {
            return @"未处理";
        }else if (section == 1){
            return @"进行中";
        }else if (section == 2){
            return @"已完成";
        }
    }else if ([tableView isEqual:self.buyOnOtherForBuyView.refundTableView]){
        if (section == 0) {
            return @"进行中";
        }else if (section == 1){
            return @"已完成";
        }
    }else if ([tableView isEqual:self.buyOnOtherForBuyView.placeTableView]){
        if (section == 0) {
            return @"处理中";
        }else if (section == 1){
            return @"已完成";
        }
    }
    return @"";
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(0), 0, kCalculateH(CGRectGetWidth(self.view.frame)), [self tableView:tableView heightForHeaderInSection:section])];
    view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    NSString* string = [self tableView:tableView titleForHeaderInSection:section];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), 0, kCalculateH(CGRectGetWidth(self.view.frame)), [self tableView:tableView heightForHeaderInSection:section])];
    label.text = string;
    label.textColor = [UIColor colorWithHexString:@"888888"];
    label.font = [UIFont systemFontOfSize:13];
    [view addSubview:label];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //LA 修改数据绑定
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%d", (long)indexPath.section , indexPath.row];
    NSArray* arrTmp;
    NSDictionary* dic;
    
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    OrderFlowLayout* flowLayout = [[OrderFlowLayout alloc] init];
    
    if (indexPath.row%2==1) {
        flowLayout.topType = OrderFlowLayoutTypeTopZero;
        flowLayout.middleType = OrderFlowLayoutTypeMiddleZero;
        flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        cell.flowLayout = flowLayout;
        cell.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
        return cell;
    }
    
    if ([tableView isEqual:self.buyOnOtherForBuyView.allTableView]) {
        
        if (indexPath.section == 0) {
            
            arrTmp=[_dicAll valueForKey:@"new"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"sellerId"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            cell.userName.text = [dic valueForKey:@"sellerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"sellerId"] integerValue];
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            NSString* isvalidate=[dic valueForKey:@"isValidate"];
            if(!isvalidate)
                isvalidate=@"";
            NSString* remainDays=[dic valueForKey:@"remainDays"];
            if(!remainDays)
                remainDays=@"0";
            
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsValidate:isvalidate IsAgree:agree RemainDays:remainDays];
            
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            [cell.rightButton setTitle:@"申请退款" forState:UIControlStateNormal];
            cell.rightButton.tag=[[dic valueForKey:@"tradeId"] integerValue];
            [cell.rightButton addTarget:self action:@selector(btnShenqingTuikuanClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            if ([@"success" isEqualToString:isvalidate]) {
                flowLayout.bottomType = OrderFlowLayoutTypeBottomOneGray;
            }
            else
            {
                flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            }
            
            cell.flowLayout = flowLayout;
            
        }else if (indexPath.section == 1){
            arrTmp=[_dicAll valueForKey:@"processing"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"sellerId"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            cell.userName.text = [dic valueForKey:@"sellerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"sellerId"] integerValue];
            
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            NSString* isvalidate=[dic valueForKey:@"isValidate"];
            if(!isvalidate)
                isvalidate=@"";
            NSString* remainDays=[dic valueForKey:@"remainDays"];
            if(!remainDays)
                remainDays=@"0";
            
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsValidate:isvalidate IsAgree:agree RemainDays:remainDays];
            
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            
            if([@"toSeller"isEqualToString:[dic valueForKey:@"status"]])
            {
                agree = @"yes";
            }
            if ([@"yes" isEqualToString:agree]) {
                
//                [cell.rightButton setTitle:@"申请退款" forState:UIControlStateNormal];
//                cell.rightButton.tag=[[dic valueForKey:@"tradeId"] integerValue];
//                [cell.rightButton addTarget:self action:@selector(btnShenqingTuikuanClick:) forControlEvents:UIControlEventTouchUpInside];
                
                flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            }
            else
            {
                [cell.leftButton setTitle:@"申请退款" forState:UIControlStateNormal];
                cell.leftButton.tag=[[dic valueForKey:@"tradeId"] integerValue];
                [cell.leftButton addTarget:self action:@selector(btnShenqingTuikuanClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.rightButton setTitle:@"同意付款" forState:UIControlStateNormal];
                cell.rightButton.tag=[[dic valueForKey:@"tradeId"] integerValue];
                [cell.rightButton addTarget:self action:@selector(btnTongyiFukuanClick:) forControlEvents:UIControlEventTouchUpInside];
                
                flowLayout.bottomType = OrderFlowLayoutTypeBottomTwoGrayRed;
            }
            
            
        }else if (indexPath.section == 2){
            
            arrTmp=[_dicAll valueForKey:@"completed"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"sellerId"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            cell.userName.text = [dic valueForKey:@"sellerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"sellerId"] integerValue];
            
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            NSString* isvalidate=[dic valueForKey:@"isValidate"];
            if(!isvalidate)
                isvalidate=@"";
            NSString* remainDays=[dic valueForKey:@"remainDays"];
            if(!remainDays)
                remainDays=@"0";
            
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsValidate:isvalidate IsAgree:agree RemainDays:remainDays];
            
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }
        
    }else if([tableView isEqual:self.buyOnOtherForBuyView.refundTableView]){
        
        if (indexPath.section == 0) {
            arrTmp=[_dicRefunded valueForKey:@"refunding"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"sellerId"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            cell.userName.text = [dic valueForKey:@"sellerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"sellerId"] integerValue];
            
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            NSString* isvalidate=[dic valueForKey:@"isValidate"];
            if(!isvalidate)
                isvalidate=@"";
            NSString* remainDays=[dic valueForKey:@"remainDays"];
            if(!remainDays)
                remainDays=@"0";
            
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsValidate:isvalidate IsAgree:agree RemainDays:remainDays];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            
        }else if (indexPath.section == 1){
            arrTmp=[_dicRefunded valueForKey:@"refunded"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"sellerId"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            cell.userName.text = [dic valueForKey:@"sellerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"sellerId"] integerValue];
            
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            NSString* isvalidate=[dic valueForKey:@"isValidate"];
            if(!isvalidate)
                isvalidate=@"";
            NSString* remainDays=[dic valueForKey:@"remainDays"];
            if(!remainDays)
                remainDays=@"0";
            
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsValidate:isvalidate IsAgree:agree RemainDays:remainDays];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            cell.refundLabel.text =[NSString stringWithFormat:@"¥%.2f",([[dic valueForKey:@"orderPrice"] doubleValue]-[[dic valueForKey:@"virtualPrice"] doubleValue])];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOneRed;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;

        }
    }
    else
    {
        if (indexPath.section == 0)
        {
            arrTmp=[_dicHuowei valueForKey:@"handling"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], [[dic valueForKey:@"userId"] get2Subs], [dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_buy"]];
            
            NSString* buytime=[dic valueForKey:@"buyTime"];
            if(buytime&&buytime.length>0)
                buytime=[[HandyWay shareHandyWay] getTimeWithStr:buytime];
            else
                buytime=@"";
            cell.timeLabel.text = buytime;
            
            NSString* source=[dic valueForKey:@"source"];
            if(source)
                source=[self getHuoweiLaiyuan:source];
            else
                source=@"";
            
            NSString* strFileName = [dic valueForKey:@"fileName"];
            NSString* strFileName2 = [dic valueForKey:@"fileName"];
            strFileName2 = [strFileName2 stringByReplacingOccurrencesOfString:@"收费" withString:@""];
            strFileName2 = [NSString stringWithFormat:@"%d",[strFileName2 intValue] + 4];
            cell.detailLabel.text =[NSString stringWithFormat:@"%@ %@－%@",source,strFileName,strFileName2];
            
            cell.priceLabel.text =[NSString stringWithFormat:@"%@",@"¥20"];
            
            NSString* status=[dic valueForKey:@"status"];
            if(status)
                status=[self getHuoweiStatus:status BySource:[dic valueForKey:@"source"]];
            else
                status=@"";
            
            cell.stateLabel.text = status;
            
            flowLayout.topType = OrderFlowLayoutTypeTopZero;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleTwo;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }
        else if (indexPath.section == 1)
        {
            arrTmp=[_dicHuowei valueForKey:@"success"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], [[dic valueForKey:@"userId"] get2Subs], [dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_buy"]];
            
            NSString* source=[dic valueForKey:@"source"];
            if(source)
                source=[self getHuoweiLaiyuan:source];
            else
                source=@"";
            NSString* strFileName = [dic valueForKey:@"fileName"];
            NSString* strFileName2 = [dic valueForKey:@"fileName"];
            strFileName2 = [strFileName2 stringByReplacingOccurrencesOfString:@"收费" withString:@""];
            strFileName2 = [NSString stringWithFormat:@"%d",[strFileName2 intValue] + 4];
            cell.detailLabel.text =[NSString stringWithFormat:@"%@ %@－%@",source,strFileName,strFileName2];
            
            NSString* buytime=[dic valueForKey:@"buyTime"];
            if(buytime&&buytime.length>0)
                buytime=[[HandyWay shareHandyWay] getTimeWithStr2:buytime];
            else
                buytime=@"";
            cell.timeLabel.text = buytime;
            
            cell.priceLabel.text =[NSString stringWithFormat:@"%@",@"¥20"];
            NSString* status=[dic valueForKey:@"status"];
            if(status)
                status=[self getHuoweiStatus:status BySource:[dic valueForKey:@"source"]];
            else
                status=@"";
            
            cell.stateLabel.text = status;
            flowLayout.topType = OrderFlowLayoutTypeTopZero;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleTwo;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }

    }
    
    cell.flowLayout = flowLayout;
    return cell;
    
}

//- (void)attentionButtonAction:(UIButton *)sender
//{
//    
//    UITableViewCell *cell = (UITableViewCell *)sender.superview;
//    NSIndexPath *indexPath = [self.buyOnOtherForBuyView.allTableView indexPathForCell:cell];
//    NSLog(@"%ld" , indexPath.row);
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderFlowLayout* flowLayout = [[OrderFlowLayout alloc] init];
    if (indexPath.row%2==1) {
        return 10;
    }
    NSArray* arrTmp;
    NSDictionary* dic;
    if ([tableView isEqual:self.buyOnOtherForBuyView.allTableView]) {
        
        if (indexPath.section == 0) {
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            arrTmp=[_dicAll valueForKey:@"new"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            NSString* isvalidate=[dic valueForKey:@"isValidate"];
            if(!isvalidate)
                isvalidate=@"";
            if ([@"success" isEqualToString:isvalidate]) {
                flowLayout.bottomType = OrderFlowLayoutTypeBottomOneGray;
            }
            else
            {
                flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            }
            
        }else if (indexPath.section == 1){
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomTwoGrayRed;
            
        }else if (indexPath.section == 2){
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }
        
    }else if([tableView isEqual:self.buyOnOtherForBuyView.refundTableView]){
        
        if (indexPath.section == 0) {
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            
        }else if (indexPath.section == 1){
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOneRed;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            
        }
    }
    else
    {
        if (indexPath.section == 0) {
            
            flowLayout.topType = OrderFlowLayoutTypeTopZero;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleTwo;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }else if (indexPath.section == 1){
            flowLayout.topType = OrderFlowLayoutTypeTopZero;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleTwo;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }
        
    }
    
    CGFloat top = 0.0;
    CGFloat middle = 0.0;
    CGFloat bottom = 0.0;
    
    if (flowLayout.topType != OrderFlowLayoutTypeTopZero) {
        top = 44.5;
    }
    if (flowLayout.middleType != OrderFlowLayoutTypeMiddleZero)
    {
        middle = 91;
    }
    if (flowLayout.bottomType != OrderFlowLayoutTypeBottomZero) {
        bottom = 43.5;
    }
    return kCalculateV(top+middle+bottom);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyDetailViewController * pshVc=[[BuyDetailViewController alloc]init];
    OrderCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[OrderCell class]]) {
        pshVc.flowLayout = cell.flowLayout;
    }
    NSArray* arrTmp;
    NSMutableDictionary* dic;
    NSString* status=@"";
    [pshVc setFlg:@"buyer"];
    if ([tableView isEqual:self.buyOnOtherForBuyView.allTableView]) {
        
        if (indexPath.section == 0) {
            //
            status=@"new";
            arrTmp=[_dicAll valueForKey:status];
            dic=[[arrTmp objectAtIndex:indexPath.row/2] mutableCopy];
            [pshVc setDic:dic];
            [pshVc setStatus:status];
            
        }else if (indexPath.section == 1){
            //
            status=@"processing";
            arrTmp=[_dicAll valueForKey:status];
            dic=[[arrTmp objectAtIndex:indexPath.row/2] mutableCopy];
            [pshVc setDic:dic];
            [pshVc setStatus:status];
            
        }else if (indexPath.section == 2){
            //
            status=@"completed";
            arrTmp=[_dicAll valueForKey:status];
            dic=[[arrTmp objectAtIndex:indexPath.row/2] mutableCopy];
            [pshVc setDic:dic];
            [pshVc setStatus:status];
            
        }
    }else if ([tableView isEqual:self.buyOnOtherForBuyView.refundTableView]){
        if (indexPath.section == 0) {
            //
            status=@"refunding";
            arrTmp=[_dicRefunded valueForKey:status];
            dic=[[arrTmp objectAtIndex:indexPath.row/2] mutableCopy];
            [pshVc setDic:dic];
            [pshVc setStatus:status];
            
        }else if (indexPath.section == 1){
            //
            status=@"refunded";
            arrTmp=[_dicRefunded valueForKey:status];
            dic=[[arrTmp objectAtIndex:indexPath.row/2] mutableCopy];
            [pshVc setDic:dic];
            [pshVc setStatus:status];
        }
    }else if ([tableView isEqual:self.buyOnOtherForBuyView.placeTableView]){
        if (indexPath.section == 0) {
            
        }else if (indexPath.section == 1){
            
        }
    }
    if ([tableView isEqual:self.buyOnOtherForBuyView.allTableView]||[tableView isEqual:self.buyOnOtherForBuyView.refundTableView])
    [self.navigationController pushViewController:pshVc animated:YES];
}


#pragma mark - network
//全部
- (void)networkRequestForAllForNewData:(BOOL)forNewData
{
    NSDictionary *param = @{
                            @"userId":[CMData getUserId],
                            @"token":[CMData getToken],
                            @"type":@"all",
                            @"orderRanking":forNewData?@(0):@([[_dicAll objectForKey:@"new"] count]+[[_dicAll objectForKey:@"processing"] count]+[[_dicAll objectForKey:@"completed"] count]),
                            @"userType":@"user"
                            };
    
    [CMAPI postUrl:API_USER_TRADERECORDS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        [self.buyOnOtherForBuyView.allTableView.header endRefreshing];
        id result = [detailDict valueForKey:@"result"];
        if (succeed) {
            if (forNewData) {
                _dicAll = @{};
            }
            NSMutableDictionary* dicMutableAll = [_dicAll mutableCopy];
            NSMutableArray* arrayMutableAll1 = [[dicMutableAll objectForKey:@"new"] mutableCopy];
            NSMutableArray* arrayMutableAll2 = [[dicMutableAll objectForKey:@"processing"] mutableCopy];
            NSMutableArray* arrayMutableAll3 = [[dicMutableAll objectForKey:@"refunded"] mutableCopy];
            if (!arrayMutableAll1)
            {
                arrayMutableAll1 = [@[] mutableCopy];
            }
            if (!arrayMutableAll2)
            {
                arrayMutableAll2 = [@[] mutableCopy];
            }
            if (!arrayMutableAll3)
            {
                arrayMutableAll3 = [@[] mutableCopy];
            }
            [arrayMutableAll1 addObjectsFromArray:[result objectForKey:@"new"]];
            [arrayMutableAll2 addObjectsFromArray:[result objectForKey:@"processing"]];
            [arrayMutableAll3 addObjectsFromArray:[result objectForKey:@"completed"]];
            if(arrayMutableAll1)
            {
                [dicMutableAll setObject:arrayMutableAll1 forKey:@"new"];
            }
            if(arrayMutableAll2)
            {
                [dicMutableAll setObject:arrayMutableAll2 forKey:@"processing"];
            }
            if(arrayMutableAll3)
            {
                [dicMutableAll setObject:arrayMutableAll3 forKey:@"completed"];
            }
            _dicAll = [dicMutableAll copy];
            NSLog(@"%@" , detailDict);
        }
        else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            else
            {
                if (([[_dicAll objectForKey:@"new"] count]+[[_dicAll objectForKey:@"processing"] count]+[[_dicAll objectForKey:@"completed"] count]) > 0) {
                    [self.buyOnOtherForBuyView.allTableView.footer noticeNoMoreData];
                }
            }
        }
        
        //判断是否增加默认图片
        BOOL flg=NO;
        
        NSArray* arrtmp=[_dicAll valueForKey:@"new"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        arrtmp=[_dicAll valueForKey:@"processing"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        arrtmp=[_dicAll valueForKey:@"completed"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        if (flg) {
            [self.buyOnOtherForBuyView.allTableView reloadData];
        }
        
        [self.buyOnOtherForBuyView.allTableView showEmptyListHaveData:flg Image:IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_ALL_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_ALL_NODATASTRING ByCSS:NoDataCSSTop];
    }];
}

//退款
- (void)networkRequestForRefundForNewData:(BOOL)forNewData
{
    NSDictionary *param = @{
                            @"userId":[CMData getUserId],
                            @"token":[CMData getToken],
                            @"type":@"refund",
                            @"orderRanking":forNewData?@(0):@([[_dicRefunded objectForKey:@"refunding"] count]+[[_dicRefunded objectForKey:@"refunded"] count]),
                            @"userType":@"user"
                            };
    
    [CMAPI postUrl:API_USER_TRADERECORDS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        [self.buyOnOtherForBuyView.refundTableView.header endRefreshing];
        id result = [detailDict valueForKey:@"result"];
        if (succeed) {
            if (forNewData) {
                _dicRefunded = @{};
            }
            NSMutableDictionary* dicMutableRefunded = [_dicRefunded mutableCopy];
            NSMutableArray* arrayMutableRefunded1 = [[dicMutableRefunded objectForKey:@"refunding"] mutableCopy];
            NSMutableArray* arrayMutableRefunded2 = [[dicMutableRefunded objectForKey:@"refunded"] mutableCopy];
            if (!arrayMutableRefunded1)
            {
                arrayMutableRefunded1 = [@[] mutableCopy];
            }
            if (!arrayMutableRefunded2)
            {
                arrayMutableRefunded2 = [@[] mutableCopy];
            }
            [arrayMutableRefunded1 addObjectsFromArray:[result objectForKey:@"refunding"]];
            [arrayMutableRefunded2 addObjectsFromArray:[result objectForKey:@"refunded"]];
            if (arrayMutableRefunded1) {
                [dicMutableRefunded setObject:arrayMutableRefunded1 forKey:@"refunding"];
            }
            
            if (arrayMutableRefunded2) {
                 [dicMutableRefunded setObject:arrayMutableRefunded2 forKey:@"refunded"];
            }
           
            _dicRefunded = [dicMutableRefunded copy];
            NSLog(@"%@" , detailDict);
        }
        else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            else
            {
                if (self.dicRefunded.count > 0) {
                    [self.buyOnOtherForBuyView.refundTableView.footer noticeNoMoreData];
                }
            }
        }
        
        //判断是否增加默认图片
        BOOL flg=NO;
        
        NSArray* arrtmp=[_dicRefunded valueForKey:@"refunding"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        arrtmp=[_dicRefunded valueForKey:@"refunded"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        
        if (flg) {
            [self.buyOnOtherForBuyView.refundTableView reloadData];
        }
        [self.buyOnOtherForBuyView.refundTableView showEmptyListHaveData:flg Image:IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_REFUND_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_REFUND_NODATASTRING ByCSS:NoDataCSSTop];
    }];
}

//货位
- (void)networkRequestForPlace
{
    NSDictionary *param = @{
                            @"userId":[CMData getUserId],
                            @"token":[CMData getToken]
                            };
    
    [CMAPI postUrl:API_PAYSHELFRECORD Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        [self.buyOnOtherForBuyView.placeTableView.header endRefreshing];
        if (succeed) {
            _dicHuowei=[detailDict objectForKey:@"result"];
            
            NSLog(@"%@" , detailDict);
        }else{
            if (![[[detailDict valueForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[[detailDict valueForKey:@"result"] objectForKey:@"reason"]];
            }
        }
        
        //判断是否增加默认图片
        BOOL flg=NO;
        
        NSArray* arrtmp=[_dicHuowei valueForKey:@"handling"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        arrtmp=[_dicHuowei valueForKey:@"success"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        if (flg) {
            [self.buyOnOtherForBuyView.placeTableView reloadData];
        }
        else
        {
            //提示无数据
            UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f, self.buyOnOtherForBuyView.placeTableView.bounds.size.width, self.buyOnOtherForBuyView.placeTableView.bounds.size.height )];
            myView.backgroundColor=[UIColor colorWithHexString:@"E1E1E1"];
            
            UIImage* myImg=[UIImage imageNamed:@"img_default_me_list"];
            UIImageView *imgView=[[UIImageView alloc]initWithImage:myImg];
            [imgView setFrame:CGRectMake((self.view.frame.size.width-112.0f)/2, [UIScreen mainScreen].bounds.size.height/2-130-44,112.0f,112.0f)];
            [myView addSubview:imgView];
            
            UILabel* labWarn=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200.0f)/2, [UIScreen mainScreen].bounds.size.height/2-44,200.0f,25.0f)];
            labWarn.text=@"您还没有购买任何货位哦！";
            labWarn.font=[UIFont systemFontOfSize:15];
            labWarn.textColor=[UIColor colorWithHexString:@"878787"];
            labWarn.textAlignment=UITextAlignmentCenter;
            [myView addSubview:labWarn];
            
            [self.buyOnOtherForBuyView.placeTableView addSubview:myView];
        }
        
        
    }];
}


//LA  func start

-(NSString*)getStatus:(NSString*)str IsValidate:(NSString*)isvalidate IsAgree:(NSString*)agree RemainDays:(NSString*)remainDays
{
    NSString* status=@"";
    if([str isEqualToString:@"new"])//未处理 无需显示
    {
        if([isvalidate isEqualToString:@"newing"])
            status=@"未付款";
        if([isvalidate isEqualToString:@"mobileSuccess"])
            status=@"已付款";
        if([isvalidate isEqualToString:@"success"])
            status=@"付款成功，请等待卖家处理";
        if([isvalidate isEqualToString:@"mobieFailed"])
            status=@"付款失败";
    }
    if([str isEqualToString:@"processing"])//代购进行中
        status=@"代购进行中";
    if([str isEqualToString:@"completed"])//已完成 无需显示
        status=@"已完成";
    if([str isEqualToString:@"refunding"])//退款进行中
    {
        if([agree isEqualToString:@"yes"])
            status=@"卖家已经同意退款，等待后台打款";
        else
        {
            NSString* days=remainDays;
            if ([days intValue]<=0) {
                status = @"后台自动退款";
            }
            else
            {
                status=[NSString stringWithFormat:@"%@天后自动退款",days];
            }
        }
    }
    if([str isEqualToString:@"refunded"])//已完成  无需显示
        status=@"已完成";
    if([str isEqualToString:@"toSeller"])//买家已同意付款
        status=@"已同意付款，请等待后台处理";
    return status;
}

-(void)btnShenqingTuikuanClick:(id)sender
{
    _action=@"5";
    UIButton* btn=sender;
    _tradeID=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    _wReload=@"all";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"申请退款" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

-(void)btnTongyiFukuanClick:(id)sender
{
    _action=@"4";
    UIButton* btn=sender;
    _tradeID=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    _wReload=@"all";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"同意付款" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


-(void)OpJiaoyiJilu
{
    _uType=@"buyer";
    NSDictionary *param = @{
                            @"userId":[CMData getUserId],
                            @"token":[CMData getToken],
                            @"type":_uType,
                            @"action":_action,
                            @"tradeId":_tradeID
                            };
    
    [CMAPI postUrl:API_USER_ACTIONABOUNTTRADE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSString* code=[detailDict valueForKey:@"code"];
            if([code isEqualToString:@"2000"])
            {
                if([_wReload isEqualToString:@"all"])
                    [self networkRequestForAllForNewData:YES];
                if([_wReload isEqualToString:@"refund"])
                    [self networkRequestForRefundForNewData:YES];
            }
        }
        [SVProgressHUD showSuccessWithStatus:[detailDict valueForKey:@"reason"]];
    }];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSLog(@"确定了执行操作");
        [self OpJiaoyiJilu];
    }
    
}

-(void)gotToUserCenter:(id)sender
{
    UIButton* btn=sender;
    NSString* userid=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    VisitBuyerViewController* pshVc=[[VisitBuyerViewController alloc]init];
    [pshVc setUserId:userid];
    [self.navigationController pushViewController:pshVc animated:YES];
}

-(NSString*)getHuoweiLaiyuan:(NSString*)source
{
    NSString* str=@"";
    if ([source isEqualToString:@"buy"]) {
        str=@"购买";
    }
    if ([source isEqualToString:@"continue"]) {
        str=@"续费";
    }
    return  str;
}

-(NSString*)getHuoweiStatus:(NSString*)status BySource:(NSString*)source
{
    NSString* str;
    if([status isEqualToString:@"newing"])
        str=@"待付款";
    if([status isEqualToString:@"mobileSuccess"])
        str=@"已支付";
    if([status isEqualToString:@"mobileFailed"])
        str=@"支付失败";
    if([status isEqualToString:@"success"])
    {
        if ([@"buy" isEqualToString:source]) {
            str=@"已开通";
        }
        else if ([@"continue" isEqualToString:source])
        {
            str = @"已续费";
        }
    }
    if([status isEqualToString:@"failed"])
        str=@"失败";
    return str;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat h=0;
    BOOL flg=YES;
    NSString* status=@"";
    NSDictionary* arrTmp;
    if ([tableView isEqual:self.buyOnOtherForBuyView.allTableView]) {
        if (section == 0) {
            status=@"new";
            arrTmp=[_dicAll valueForKey:status];
            if(arrTmp&&arrTmp.count>0)
                flg=YES;
            else
                flg=NO;
        }else if (section == 1){
            status=@"processing";
            arrTmp=[_dicAll valueForKey:status];
            if(arrTmp&&arrTmp.count>0)
                flg=YES;
            else
                flg=NO;
        }else if (section == 2){
            status=@"completed";
            arrTmp=[_dicAll valueForKey:status];
            if(arrTmp&&arrTmp.count>0)
                flg=YES;
            else
                flg=NO;
        }
    }else if ([tableView isEqual:self.buyOnOtherForBuyView.refundTableView]){
        if (section == 0) {
            status=@"refunding";
            arrTmp=[_dicRefunded valueForKey:status];
            if(arrTmp&&arrTmp.count>0)
                flg=YES;
            else
                flg=NO;
        }else if (section == 1){
            status=@"refunded";
            arrTmp=[_dicRefunded valueForKey:status];
            if(arrTmp&&arrTmp.count>0)
                flg=YES;
            else
                flg=NO;
        }
    }else if ([tableView isEqual:self.buyOnOtherForBuyView.placeTableView]){
        if (section == 0) {
            status=@"handling";
            arrTmp=[_dicHuowei valueForKey:status];
            if(arrTmp&&arrTmp.count>0)
                flg=YES;
            else
                flg=NO;
        }else if (section == 1){
            status=@"success";
            arrTmp=[_dicHuowei valueForKey:status];
            if(arrTmp&&arrTmp.count>0)
                flg=YES;
            else
                flg=NO;
        }
    }
    h=flg?25:0;
    return h;
}


//LA  func end

@end
