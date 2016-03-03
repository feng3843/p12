//
//  BuyDetailViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  代购详情

#import "BuyDetailViewController.h"
#import "BuyDetailView.h"

#import "BuyDetailSection1TableViewCell.h"
#import "BuyDetailSection2TableViewCell.h"
#import "BuyDetailSection3TableViewCell.h"
#import "LibCM.h"
#import "NSDate+Extensions.h"
#import "NSString+Extensions.h"
#import "CMDefault.h"
#import "VisitSellerViewController.h"
#import "VisitBuyerViewController.h"

@interface BuyDetailViewController ()<UITableViewDataSource , UITableViewDelegate>

@property(nonatomic , strong)BuyDetailView *buyDetailView;
//LA  增加
@property(nonatomic)NSString* action;

@end

@implementation BuyDetailViewController

- (void)loadView
{
    [super loadView];
    self.buyDetailView = [[BuyDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.buyDetailView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"代购详情";
    
    self.buyDetailView.tableView.dataSource = self;
    self.buyDetailView.tableView.delegate = self;
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    NSLog(@"LALALALA:%@",_flg);
    NSLog(@"LALALALA:%@",_status);
    NSLog(@"LALALALA:%@",_dic);
    
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kCalculateV(44.5+91);
        
    }else if (indexPath.section == 1){
        
        return kCalculateV(113);
    }else if (indexPath.section == 2){
        
        return kCalculateV(100);
    }else if (indexPath.section == 3){
        
        return kCalculateV(55);
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return self.flowLayout.bottomType == OrderFlowLayoutTypeBottomZero?(70+55): 70;
    }
    return kCalculateV(10);
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kCalculateV(10))];
//    view.backgroundColor = PYColor(@"e7e7e7");
//    
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //LA  添加数据绑定
    if (indexPath.section == 0) {
        OrderCell *cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"0000"];
        
        OrderFlowLayout* flowLayout = [[OrderFlowLayout alloc] init];
        
        if([_flg isEqualToString:@"seller"])
        {
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[_dic valueForKey:@"buyer"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            cell.userName.text = [_dic valueForKey:@"buyerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[_dic valueForKey:@"buyer"] integerValue];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOne;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }
        if([_flg isEqualToString:@"buyer"])
        {
            [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:[_dic valueForKey:@"sellerId"]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            cell.userName.text = [_dic valueForKey:@"sellerName"];
            [cell.btnGotoUserCenter addTarget:self action:@selector(gotToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnGotoUserCenter.tag=[[_dic valueForKey:@"sellerId"] integerValue];
            
            flowLayout.topType = OrderFlowLayoutTypeTopOne;
            flowLayout.middleType = OrderFlowLayoutTypeMiddleOne;
            flowLayout.bottomType = OrderFlowLayoutTypeBottomZero;
        }
        [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:[_dic valueForKey:@"sellerId"] PostID:[_dic valueForKey:@"noteId"]]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
//        cell.grGotoNoteDetail.delegate = self;
        [cell.grGotoNoteDetail addTarget:self action:@selector(jump2NoteDetail)];
        
        cell.detailLabel.text = [_dic valueForKey:@"noteDesc"];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[_dic valueForKey:@"orderPrice"]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.flowLayout = flowLayout;
        return cell;
    }else if (indexPath.section == 1){
        BuyDetailSection1TableViewCell *cell = [[BuyDetailSection1TableViewCell alloc] init];
        cell.indentNumber.text = [NSString stringWithFormat:@"代购订单号: %@" , [_dic valueForKey:@"out_trade_no"]];
        cell.AlipayIndentNumber.text = [NSString stringWithFormat:@"支付宝订单号: %@" , [_dic valueForKey:@"alipay_trade_no"]];
        NSString* starttime=[_dic valueForKey:@"tradeBeginTime"];
        if(starttime&&starttime.length>0)
            starttime=[[HandyWay shareHandyWay] getTimeWithStr:starttime];
        else
            starttime=@"";
        cell.indentTime.text = [NSString stringWithFormat:@"下单时间: %@" ,starttime];
        NSString* endtime=[_dic valueForKey:@"tradeEndTime"];
//        if([_status isEqualToString:@"refunding"])
//        {
//            if ([[_dic valueForKey:@"remainDays"] intValue]<=0) {
//                endtime = [_dic valueForKey:@"backEndTime"];
//            }
//        }
        
        if(endtime&&endtime.length>0)
            endtime=[[HandyWay shareHandyWay] getTimeWithStr:endtime];
        else
            endtime=@"";
        cell.finishTime.text = [NSString stringWithFormat:@"成交时间: %@" , endtime];
        
        NSString* agree=[_dic valueForKey:@"isAgree"];
        if(!agree)
            agree=@"";
        NSString* isvalidate=[_dic valueForKey:@"isValidate"];
        if(!isvalidate)
            isvalidate=@"";
        cell.stateLabel.text =[self getStatus:[_dic valueForKey:@"status"] IsValidate:isvalidate IsAgree:agree];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
     
        BuyDetailSection2TableViewCell *cell = [[BuyDetailSection2TableViewCell alloc] init];
        double zongjia=[[_dic valueForKey:@"orderPrice"] doubleValue];
        double youhuijia=[[_dic valueForKey:@"virtualPrice"] doubleValue];
        double zhekou=zongjia-youhuijia;
        cell.priceLabel.text =[NSString stringWithFormat:@"¥%.2f",zongjia];
        cell.scoreLabel.text =[NSString stringWithFormat:@"¥%.2f",youhuijia];
        cell.lastLabel.text =[NSString stringWithFormat:@"¥%.2f",zhekou];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    BuyDetailSection3TableViewCell *cell = [[BuyDetailSection3TableViewCell alloc] init];
    
    //LA 增加爆出判断
    [cell.leftButton setHidden:YES];
    [cell.rightButton setHidden:YES];
    [cell.leftButton setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
    cell.leftButton.layer.borderColor = PYColor(@"999999").CGColor;
    [cell.rightButton setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
    cell.rightButton.layer.borderColor = PYColor(@"999999").CGColor;
    if([_flg isEqualToString:@"seller"])
    {
        if([_status isEqualToString:@"new"])
        {
            [cell.leftButton setTitle:@"不接受" forState:UIControlStateNormal];
            cell.leftButton.tag=2;
            [cell.leftButton setTitleColor:PYColor(@"f24949") forState:UIControlStateNormal];
            cell.leftButton.layer.borderColor = PYColor(@"f24949").CGColor;
            [cell.leftButton setHidden:NO];
            [cell.rightButton setTitle:@"接受" forState:UIControlStateNormal];
            cell.rightButton.tag=1;
            [cell.rightButton setTitleColor:PYColor(@"f24949") forState:UIControlStateNormal];
            cell.rightButton.layer.borderColor = PYColor(@"f24949").CGColor;
            [cell.rightButton setHidden:NO];
        }
        if([_status isEqualToString:@"refunding"])
        {
            NSString* isagree=[_dic valueForKey:@"isAgree"];
            if(!isagree)
                isagree=@"";
            if ([[_dic valueForKey:@"remainDays"] intValue]<=0) {
                
            }
            else
            {
                if(![isagree isEqualToString:@"yes"])
                {
                    [cell.rightButton setTitle:@"同意" forState:UIControlStateNormal];
                    cell.rightButton.tag=3;
                    [cell.rightButton setTitleColor:PYColor(@"f24949") forState:UIControlStateNormal];
                    cell.rightButton.layer.borderColor = PYColor(@"f24949").CGColor;
                    [cell.rightButton setHidden:NO];
                }
            }
        }
    }
    if([_flg isEqualToString:@"buyer"])
    {
        if([_status isEqualToString:@"new"])
        {
            //
            NSString* isvalidate=[_dic valueForKey:@"isValidate"];
            if(!isvalidate)
                isvalidate=@"";
            if([isvalidate isEqualToString:@"success"])
            {
                [cell.rightButton setTitle:@"申请退款" forState:UIControlStateNormal];
                cell.rightButton.tag=5;
                [cell.rightButton setHidden:NO];
            }
        }
        if([_status isEqualToString:@"processing"])
        {
            [cell.leftButton setTitle:@"申请退款" forState:UIControlStateNormal];
            cell.leftButton.tag=5;
            [cell.leftButton setHidden:NO];
            [cell.rightButton setTitle:@"同意付款" forState:UIControlStateNormal];
            cell.rightButton.tag=4;
            [cell.rightButton setTitleColor:PYColor(@"f24949") forState:UIControlStateNormal];
            cell.rightButton.layer.borderColor = PYColor(@"f24949").CGColor;
            [cell.rightButton setHidden:NO];
        }
    }
    [cell.rightButton addTarget:self action:@selector(funcBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [cell.leftButton addTarget:self action:@selector(funcBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(void)jump2NoteDetail
{
    NoteInfoModel *model = [[NoteInfoModel alloc] init];
    
    model.noteId = [_dic valueForKey:@"noteId"];
    model.userId = [_dic valueForKey:@"sellerId"];
    
    NoteDetailViewController *note = [[NoteDetailViewController alloc]init];
    note.noteId = model.noteId;
    note.noteUserId = model.userId;
    
    [self.navigationController pushViewController:note animated:YES];
    note.returnBackBlock = ^(NSString *str) {
    };
}

//LA  func start

-(NSString*)getStatus:(NSString*)str IsValidate:(NSString*)isvalidate IsAgree:(NSString*)agree
{
    NSString* status=@"";
    if ([@"seller" isEqualToString:_flg]) {
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
                if ([[_dic valueForKey:@"remainDays"] intValue]<=0) {
                    
                    status=@"后台自动退款";
                }
                else
                {
                    status=@"待同意";
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
    }
    else if ([@"buyer" isEqualToString:_flg])
    {
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
                NSString* days=[_dic valueForKey:@"remainDays"];
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
    }
    
    return status;
}


-(void)funcBtnTouchUpInside:(id)sender
{
    UIButton* btn=sender;
    _action=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定执行？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
       [self OpJiaoyiJilu];
        NSLog(@"LALLAL:tag:%@",_action);
}

-(void)OpJiaoyiJilu
{
    NSString* tradeID=[_dic valueForKey:@"tradeId"];
    NSDictionary *param = @{
                            @"userId":[CMData getUserId],
                            @"token":[CMData getToken],
                            @"type":_flg,
                            @"action":_action,
                            @"tradeId":tradeID
                            };
    
    [CMAPI postUrl:API_USER_ACTIONABOUNTTRADE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSString* code=[detailDict valueForKey:@"code"];
            if([code isEqualToString:@"2000"])
            {
                //数据更新刷新本界面
                NSDictionary* dic=[detailDict valueForKey:@"result"];
                NSString* status=[dic valueForKey:@"status"];
                
                if(status)
                {
                    [_dic setValue:status forKey:@"status"];
                    _status=status;
                }
                NSString* remainDays=[dic valueForKey:@"remainDays"];
                if(remainDays)
                    [_dic setValue:remainDays forKey:@"remainDays"];
                
                //下面的数据继续解析增加
                
                NSLog(@"LALAL 操作返回结果:%@",detailDict);
                
                [self.buyDetailView.tableView reloadData];
                //通知列表界面更新
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DINGDAN_RELOAD object:nil];
            }
        }
        [SVProgressHUD showSuccessWithStatus:[detailDict valueForKey:@"reason"]];
    }];
}

//跳转到对方的个人中心
-(void)gotToUserCenter:(id)sender
{
    UIButton* btn=sender;
    NSString* userid=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    id pshVc=nil;
    if([_flg isEqualToString:@"seller"])
        pshVc=[[VisitSellerViewController alloc]init];
   
    if([_flg isEqualToString:@"buyer"])
        pshVc=[[VisitBuyerViewController alloc]init];
    [pshVc setUserId:userid];
    if(pshVc)
        [self.navigationController pushViewController:pshVc animated:YES];
}


//LA  func end

@end
