//
//  BuyOnOtherForSellViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购页面卖

#import "BuyOnOtherForSellViewController.h"
#import "OrderCell.h"
#import "BuyOnOtherForSellView.h"
#import "BuyOnOtherForBuyViewController.h"
#import "OrderCell.h"
#import "BuyDetailViewController.h"
#import "LibCM.h"
#import "MJRefresh.h"
#import "CMDefault.h"
#import "VisitSellerViewController.h"

@interface BuyOnOtherForSellViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic , strong)BuyOnOtherForSellView *buyOnOtherForSellView;

@property(nonatomic)NSDictionary* dicAll;
@property(nonatomic)NSDictionary* dicRefunded;
//@property(nonatomic)NSArray* arrayAll;
//@property(nonatomic)NSArray* arrayRefunded;

//操作确认使用
@property(nonatomic)NSString* uType;
@property(nonatomic)NSString* action;
@property(nonatomic)NSString* tradeID;
@property(nonatomic)NSString* wReload;

@end

@implementation BuyOnOtherForSellViewController


- (void)loadView
{
    [super loadView];
    
    self.title = @"卖";
    self.buyOnOtherForSellView = [[BuyOnOtherForSellView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.buyOnOtherForSellView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.buyOnOtherForSellView.allButton addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buyOnOtherForSellView.refundButton addTarget:self action:@selector(refundButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buyOnOtherForSellView.allTableView.delegate = self;
    self.buyOnOtherForSellView.allTableView.dataSource = self;
    
    self.buyOnOtherForSellView.refundTableView.delegate = self;
    self.buyOnOtherForSellView.refundTableView.dataSource = self;
    
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //右侧
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    right.frame = CGRectMake(0, 10, 44, 24);
    [right setTitle:@"买" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor colorWithHexString:@"296FBF"] forState:UIControlStateNormal];//LA 修改
    right.layer.masksToBounds = YES;
    right.layer.cornerRadius = 4;
    //LA修改
    [right setBackgroundColor:[UIColor clearColor]];
    
    right.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [right addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
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
    self.buyOnOtherForSellView.allTableView.header=header;
    
    header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self networkRequestForRefundForNewData:YES];
    }];
    header.stateLabel.font=[UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font=[UIFont systemFontOfSize:14];
    header.stateLabel.textColor=[UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor=[UIColor grayColor];
    self.buyOnOtherForSellView.refundTableView.header=header;
    
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
    
    self.buyOnOtherForSellView.allTableView.footer = footer;
    
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
    
    self.buyOnOtherForSellView.refundTableView.footer = footer;
}

-(void)DataInit
{
    _dicAll=[[NSDictionary alloc]init];
    _dicRefunded=[[NSDictionary alloc]init];
    
    [self networkRequestForAllForNewData:YES];
    
    
    //注册通知事件
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(getNotification:) name:NOTIFICATION_DINGDAN_RELOAD object:nil];
}

-(void)getNotification:(NSNotification*)notification
{
    //更新
    [self networkRequestForAllForNewData:YES];
    [self networkRequestForRefundForNewData:YES];
    NSLog(@"LALLALAL: 通知事件执行");
}

//LA  func end

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    [self.navigationController pushViewController:[BuyOnOtherForBuyViewController new] animated:YES];
}

- (void)allButtonAction:(UIButton *)sender
{
    self.buyOnOtherForSellView.allTableView.hidden = NO;
    self.buyOnOtherForSellView.refundTableView.hidden = YES;
    
    //    [self.buyOnOtherForSellView addSubview: self.buyOnOtherForSellView.allTableView];;
    //    [self.buyOnOtherForSellView.refundTableView removeFromSuperview];
    
    [sender setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    
    [self.buyOnOtherForSellView.refundButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    
}

- (void)refundButtonAction:(UIButton *)sender
{
    
    [self networkRequestForRefundForNewData:YES];
    
    self.buyOnOtherForSellView.allTableView.hidden = YES;
    self.buyOnOtherForSellView.refundTableView.hidden = NO;
    //    [self.buyOnOtherForSellView addSubview: self.buyOnOtherForSellView.refundTableView];;
    //    [self.buyOnOtherForSellView.allTableView removeFromSuperview];
    
    [sender setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    
    [self.buyOnOtherForSellView.allButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //LA  修改
    if ([tableView isEqual:self.buyOnOtherForSellView.allTableView]) {
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
        
    }else if ([tableView isEqual:self.buyOnOtherForSellView.refundTableView]){
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
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.buyOnOtherForSellView.allTableView]) {
        return 3;
    }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.buyOnOtherForSellView.allTableView]) {
        if (section == 0) {
            return @"未处理";
        }else if (section == 1){
            return @"进行中";
        }else if (section == 2){
            return @"已完成";
        }
    }else if ([tableView isEqual:self.buyOnOtherForSellView.refundTableView]){
        if (section == 0) {
            return @"进行中";
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
    //LA修改数据绑定
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", indexPath.section , indexPath.row];
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
    
    if ([tableView isEqual:self.buyOnOtherForSellView.allTableView]) {
        
        
        if (indexPath.section == 0) {
            
            arrTmp=[_dicAll valueForKey:@"new"];
            
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"buyer"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"buyer"] integerValue];
            cell.userName.text = [dic valueForKey:@"buyerName"];
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsAgree:agree remainDays:[dic objectForKey:@"remainDays"]];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            [cell.rightButton setTitle:@"接受" forState:UIControlStateNormal];
            [cell.leftButton setTitle:@"不接受" forState:UIControlStateNormal];
            cell.leftButton.tag=[[dic valueForKey:@"tradeId"] integerValue];
            [cell.leftButton addTarget:self action:@selector(btnBujieshouDaigouClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.rightButton.tag=[[dic valueForKey:@"tradeId"] integerValue];
            [cell.rightButton addTarget:self action:@selector(btnJieshouDaigouClick:) forControlEvents:UIControlEventTouchUpInside];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOne;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomTwoRedRed;
            
        }else if (indexPath.section == 1){
            
            arrTmp=[_dicAll valueForKey:@"processing"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"buyer"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"buyer"] integerValue];
            
            cell.userName.text = [dic valueForKey:@"buyerName"];
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsAgree:agree remainDays:[dic objectForKey:@"remainDays"]];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            
        }else if (indexPath.section == 2){
            
            arrTmp=[_dicAll valueForKey:@"completed"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"buyer"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"buyer"] integerValue];
            cell.userName.text = [dic valueForKey:@"buyerName"];
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsAgree:agree remainDays:[dic objectForKey:@"remainDays"]];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }
    }
    else
    {
        if (indexPath.section == 0) {
            
            arrTmp=[_dicRefunded valueForKey:@"refunding"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"buyer"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            cell.userName.text = [dic valueForKey:@"buyerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"buyer"] integerValue];
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsAgree:agree remainDays:[dic objectForKey:@"remainDays"]];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            if(![agree isEqualToString:@"yes"]){
                [cell.leftButton setHidden:YES];
                [cell.rightButton setTitle:@"同意" forState:UIControlStateNormal];
                cell.rightButton.tag=[[dic valueForKey:@"tradeId"] integerValue];
                [cell.rightButton addTarget:self action:@selector(btnTongyiTuikuanClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            
            NSString *remainDays = [dic valueForKey:@"remainDays"];
            int timestr = [remainDays intValue];
            
            if([@"yes" isEqualToString:agree]||timestr<=0)
            {
                flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            }
            else
            {
                flowLayout.bottomType = OrderFlowLayoutTypeBottomOneRed;
            }
            
        }else if (indexPath.section == 1){
            
            arrTmp=[_dicRefunded valueForKey:@"refunded"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[dic valueForKey:@"buyer"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            cell.userName.text = [dic valueForKey:@"buyerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[dic valueForKey:@"buyer"] integerValue];
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            cell.stateLabel.text =[self getStatus:[dic valueForKey:@"status"] IsAgree:agree remainDays:[dic objectForKey:@"remainDays"]];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[dic valueForKey:@"sellerId"] PostID:[dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
            cell.detailLabel.text =[dic valueForKey:@"noteDesc"];
            cell.priceLabel.text =[NSString stringWithFormat:@"¥%@",[dic valueForKey:@"orderPrice"]];
            
            cell.refundLabel.text =[NSString stringWithFormat:@"¥%.2f",([[dic valueForKey:@"orderPrice"] doubleValue]-[[dic valueForKey:@"virtualPrice"] doubleValue])];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOneRed;
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
//    NSIndexPath *indexPath = [self.buyOnOtherForSellView.allTableView indexPathForCell:cell];
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
    
    if ([tableView isEqual:self.buyOnOtherForSellView.allTableView])
    {
        
        if (indexPath.section == 0) {
            
            flowLayout.topType = OrderFlowLayoutTypeTopOne;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomTwoRedRed;
            
        }else if (indexPath.section == 1){
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            
        }else if (indexPath.section == 2){
            
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }
    }
    else
    {
        if (indexPath.section == 0) {
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            arrTmp=[_dicRefunded valueForKey:@"refunding"];
            dic=[arrTmp objectAtIndex:indexPath.row/2];
            NSString* agree=[dic valueForKey:@"isAgree"];
            if(!agree)
                agree=@"";
            NSString *remainDays = [dic valueForKey:@"remainDays"];
            int timestr = [remainDays intValue];
            
            if([@"yes" isEqualToString:agree]||timestr<=0)
            {
                flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
            }
            else
            {
                flowLayout.bottomType = OrderFlowLayoutTypeBottomOneRed;
            }
        }else if (indexPath.section == 1){
            flowLayout.topType = OrderFlowLayoutTypeTopOneRed;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOneRed;
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
    BuyDetailViewController *pshVc=[[BuyDetailViewController alloc]init];
    OrderCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[OrderCell class]]) {
        pshVc.flowLayout = cell.flowLayout;
    }
    NSArray* arrTmp;
    NSMutableDictionary* dic;
    NSString* status=@"";
    [pshVc setFlg:@"seller"];
    if ([tableView isEqual:self.buyOnOtherForSellView.allTableView]) {
        if (indexPath.section == 0) {
            //设置
            status=@"new";
            arrTmp=[_dicAll valueForKey:status];
            dic=[[arrTmp objectAtIndex:indexPath.row/2] mutableCopy];
            [pshVc setDic:dic];
            pshVc.status = status;
            
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
    }else if ([tableView isEqual:self.buyOnOtherForSellView.refundTableView]){
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
    }
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
                            @"userType":@"seller"
                            };
    [CMAPI postUrl:API_USER_TRADERECORDS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        [self.buyOnOtherForSellView.allTableView.header endRefreshing];
        [self.buyOnOtherForSellView.allTableView.footer endRefreshing];
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
                    [self.buyOnOtherForSellView.allTableView.footer noticeNoMoreData];
                }
            }
        }
        
        //判断是否有数据
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
            [self.buyOnOtherForSellView.allTableView reloadData];
        }
        
        [self.buyOnOtherForSellView.allTableView showEmptyListHaveData:flg Image:IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_ALL_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_ALL_NODATASTRING ByCSS:NoDataCSSTop];
        
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
                            @"userType":@"seller"
                            };
    [CMAPI postUrl:API_USER_TRADERECORDS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        [self.buyOnOtherForSellView.refundTableView.header endRefreshing];
        [self.buyOnOtherForSellView.refundTableView.footer endRefreshing];
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
                if (([[_dicRefunded objectForKey:@"refunding"] count]+[[_dicRefunded objectForKey:@"refunded"] count]) > 0) {
                    [self.buyOnOtherForSellView.refundTableView.footer noticeNoMoreData];
                }
            }
        }
        
        //判断是否有数据
        BOOL flg=NO;
        
        NSArray* arrtmp=[_dicRefunded valueForKey:@"refunding"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        arrtmp=[_dicRefunded valueForKey:@"refunded"];
        if(arrtmp&&arrtmp.count>0)
            flg=YES;
        
        if (flg) {
            [self.buyOnOtherForSellView.refundTableView reloadData];
        }
        
        [self.buyOnOtherForSellView.refundTableView showEmptyListHaveData:flg Image:IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_REFUND_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_REFUND_NODATASTRING ByCSS:NoDataCSSTop];
    }];
    
}

//LA func start
-(NSString*)getStatus:(NSString*)str IsAgree:(NSString*)agree remainDays:(NSString*)remainDays
{
    NSString* status=@"";
    if([str isEqualToString:@"new"])//未处理 无需显示
        status=@"未处理";
    if([str isEqualToString:@"processing"])//代购进行中
        status=@"代购进行中";
    if([str isEqualToString:@"completed"])//已完成 无需显示
        status=@"已完成";
    if([str isEqualToString:@"refunding"])//退款进行中
    {
        if([agree isEqualToString:@"yes"])
            status=@"已经同意退款，后台退款中";
        else
        {
            if ([remainDays intValue]<=0) {
                status = @"后台自动退款";
            }
            else
            {
                status = @"待同意";
            }
        }
    }
    if([str isEqualToString:@"refunded"])//已完成  无需显示
    {
        if([agree isEqualToString:@"yes"])
            status=@"已完成";
        else
            status=@"买家取消预订";
    }
    if([str isEqualToString:@"toSeller"])//买家已同意付款
        status=@"买家已同意付款，请等待后台打款";
    return status;
}

-(void)btnJieshouDaigouClick:(id)sender
{
    _action=@"1";
    UIButton* btn=sender;
    _tradeID=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    _wReload=@"all";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定操作？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)btnBujieshouDaigouClick:(id)sender
{
    _action=@"2";
    UIButton* btn=sender;
    _tradeID=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    _wReload=@"all";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定操作？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)btnTongyiTuikuanClick:(id)sender
{
    _action=@"3";
    UIButton* btn=sender;
    _tradeID=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    _wReload=@"refund";
    
    //弹出提示确定
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定操作？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

//-(void)OpJiaoyiJiluWithAction:(NSString*)action TradeID:(NSString*)tradeID completion:(void (^)(BOOL succeed, NSDictionary *detailDict, NSError *error))completion{
//    NSDictionary *param = @{
//                            @"userId":[CMData getUserId],
//                            @"token":[CMData getToken],
//                            @"type":@"seller",
//                            @"action":action,
//                            @"tradeId":tradeID
//                            };
//    
//    [CMAPI postUrl:API_USER_ACTIONABOUNTTRADE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
//        completion(succeed,detailDict,error);
//    }];
//}


-(void)OpJiaoyiJilu
{
    _uType=@"seller";
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

//跳转到对方的个人中心
-(void)gotToUserCenter:(id)sender
{
    UIButton* btn=sender;
    NSString* userid=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    VisitSellerViewController* pshVc=[[VisitSellerViewController alloc]init];
    [pshVc setUserId:userid];
    [self.navigationController pushViewController:pshVc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat h=0;
    BOOL flg=YES;
    NSString* status=@"";
    NSDictionary* arrTmp;
    if ([tableView isEqual:self.buyOnOtherForSellView.allTableView]) {
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
    }else if ([tableView isEqual:self.buyOnOtherForSellView.refundTableView]){
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
    }
    h=flg?25:0;
    return h;
}

//LA func end
@end
