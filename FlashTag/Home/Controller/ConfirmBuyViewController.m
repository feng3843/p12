//
//  ConfirmBuyViewController.m
//  FlashTag
//
//  Created by py on 15/9/15.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  确认代购

#import "ConfirmBuyViewController.h"
#import "UIImage+Extensions.h"
#import "UIView+AutoLayout.h"
#import "Alipay.h"
#import "AlipayDemo.h"


@interface ConfirmBuyViewController ()<UITextFieldDelegate>
{
//    CGFloat ratio;//积分 兑换 比例
    int ratio_1;
    NSString* strIntegral;//可用积分
    NSString* strUseIntegral;//使用的积分
}
@property(nonatomic,weak)UIView *bottomView;
/** 可用积分:45000,抵￥54.00*/
@property(nonatomic ,weak) UILabel *integralLabel;//可用积分
@property(nonatomic,weak)UITextField *textField;//使用的积分
/** 积分,抵￥45.00*/
@property(nonatomic,weak)UILabel *useIntegralLable;//积分 代付的金额
@property(nonatomic,weak) UILabel *IntegralMoeny;// 合计中 积分 代付的金额
@property(nonatomic,weak) UILabel *moeny;//实付款
@property(nonatomic,weak) UIButton *confirmBtn;
@end

@implementation ConfirmBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.strImage = @"Thome.png";
//    self.strContent = @"嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻";
//    self.strPrice = @"10000.0";
    
    ratio_1 = 1;
    strIntegral = @"0";
    strUseIntegral = @"0.00";
    
    self.view.backgroundColor = PYColor(@"e7e7e7");
    [PYNotificationCenter addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [PYNotificationCenter removeObserver:self ];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
      switch (self.userType) {
        case BuyUserTypeBuyer:
        {
            switch (self.type) {
                case BuyTypeApply:
                {
                    self.title = @"代购申请";
                    
                    [self setupTop_0];
                    [self setupBottom_0];
                }
                    break;
                case BuyTypeConfirm:
                {
                    
                    //获取用户积分 及 兑换规则
                    [self getIntegral];
                    
                    self.title = @"确认代购";
                    
                    [self setupTop];
                    [self setupBottom];
                    
                }
                default:
                    break;
            }
        }
            break;
        case BuyUserTypeSeller:
        {   
            switch (self.type) {
                case BuyTypeApply:
                {
                    self.title = @"代购申请";
                    
                    [self setupTop_0];
                    [self setupBottom_0];
                }
                    break;
                case BuyTypeConfirm:
                {
                    self.title = @"确认代购";
                    
                    [self setupTop_0];
                    [self setupBottom];
                    
                    self.textField.enabled = NO;
                    self.confirmBtn.enabled = YES;
                }
                default:
                    break;
            }
        }
            break;
        default:
        {
            self.title = @"请确认用户类型";
        }
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
//    [PYNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupTop_0
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 74 *rateH, fDeviceWidth, 132 *rateH)];
    bgView.backgroundColor = PYColor(@"ffffff");
    [self.view addSubview:bgView];
    CGFloat lableY = 0*rateH;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15 *rateW, lableY, fDeviceWidth, 32 *rateH)];
    label.backgroundColor = PYColor(@"ffffff");
    label.text = @"代购信息";
    label.font = PYSysFont(12 *rateH);
    label.textColor = PYColor(@"999999");
    [bgView addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15 *rateW, CGRectGetMaxY(label.frame), fDeviceWidth - 30 *rateW, 0.5 *rateH)];
    line.backgroundColor = PYColor(@"cccccc");
    [bgView addSubview:line];
    
    
    CGFloat noteImageY = CGRectGetMaxY(line.frame) + 10 *rateH;
    UIImageView *noteImage = [[UIImageView alloc]initWithFrame:CGRectMake(15 *rateW, noteImageY, 80 *rateH, 80*rateH)];
    noteImage.layer.cornerRadius = 4 *rateH;
    noteImage.clipsToBounds = YES;
    [noteImage sd_setImageWithURL:[NSURL URLWithString:self.strImage] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
    [bgView addSubview:noteImage];
    
    CGFloat noteDetailX = CGRectGetMaxX(noteImage.frame) + 10 *rateW;
    CGFloat noteDetailW = fDeviceWidth - noteDetailX - 15 *rateH;
    
    UILabel *noteDetail = [[UILabel alloc]initWithFrame:CGRectMake(noteDetailX, noteImageY, noteDetailW, 80 *rateH)];
    noteDetail.font = PYSysFont(13 *rateH);
    noteDetail.numberOfLines = 0;
    noteDetail.textColor = PYColor(@"515151");
    noteDetail.text = self.strContent;
    [bgView addSubview:noteDetail];
}

- (void)setupBottom_0
{
    
    CGFloat bottomViewY = fDeviceHeight -53*rateH -216;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomViewY, fDeviceWidth, 53*rateH )];
    bottomView.backgroundColor = PYColor(@"f4f4f6");
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    // self.bottomView = bottomView;
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(PYSpaceX, 8 *rateH, 204 *rateW, 37 *rateH)];
    //    textField.placeholder = @"新建一个标签...";
    textField.backgroundColor = PYColor(@"ffffff");
    textField.layer.cornerRadius = 4 *rateH;
    textField.layer.borderColor = PYColor(@"acacae").CGColor;
    textField.layer.borderWidth = 1*rateH;
    textField.font = PYSysFont(24 *rateH);
    textField.textColor = PYColor(@"222222");
    [textField becomeFirstResponder];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.delegate = self;
    // textField
    self.textField = textField;
    [bottomView addSubview:textField];
    [PYNotificationCenter addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:nil];
    [self.view addSubview:bottomView];
    
    CGFloat confirmBtnX = CGRectGetMaxX(textField.frame) + PYSpaceX;
    CGFloat confirmBtnW = fDeviceWidth -confirmBtnX -PYSpaceX;
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(confirmBtnX, 8 *rateH, confirmBtnW, 37 *rateH)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:PYColor(@"ffffff") forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = PYSysFont(15 *rateH);
    [confirmBtn setBackgroundImage:[UIImage resizedImage:@"bt_home_normal_somewhere"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage resizedImage:@"bt_home_press_somewhere"] forState:UIControlStateSelected];
    [bottomView addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    self.confirmBtn.enabled = NO;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick_0) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardFrameChange:)
    //                                                 name:UIKeyboardWillChangeFrameNotification
    //                                               object:nil];
}

//- (void)keyboardFrameChange:(NSNotification *)note
//{
//    NSValue* aValue = [note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//
//    self.bottomView.y =  keyboardRect.origin.y - 53*rateH  ;
//
//}
- (void)confirmBtnClick_0
{
    if([self.textField.text floatValue]>0)
    {
        ConfirmBuyViewController *vc = [[ConfirmBuyViewController alloc]init];
        vc.strPrice = self.textField.text;
        vc.userType = self.userType;
        vc.strID = self.strID;
        vc.strOwnerID = self.strOwnerID;
        vc.strImage = self.strImage;
        vc.strContent = self.strContent;
        vc.type = BuyTypeConfirm;
        vc.maxNum = 0;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)setupTop
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 74 *rateH, fDeviceWidth, 133.5 *rateH)];
    bgView.backgroundColor = PYColor(@"ffffff");
    [self.view addSubview:bgView];
    CGFloat lableY = 0*rateH;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15 *rateW, lableY, fDeviceWidth, 32 *rateH)];
    label.backgroundColor = PYColor(@"ffffff");
    label.text = @"积分抵用";
    label.font = PYSysFont(12 *rateH);
    label.textColor = PYColor(@"999999");
    [bgView addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15 *rateW, CGRectGetMaxY(label.frame), fDeviceWidth - 30 *rateW, 0.5 *rateH)];
    line.backgroundColor = PYColor(@"cccccc");
    [bgView addSubview:line];
    
    CGFloat integralY = CGRectGetMaxY(line.frame);
    
    UILabel *integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(PYSpaceX, integralY, fDeviceWidth,45*rateH)];
    integralLabel.backgroundColor = PYColor(@"ffffff");
    integralLabel.text = [NSString stringWithFormat:@"可用积分:%@,抵￥%.2f",strIntegral,[strIntegral floatValue]/ratio_1];
    integralLabel.font = PYSysFont(13 *rateH);
    integralLabel.textColor = PYColor(@"515151");
    self.integralLabel = integralLabel;
    [bgView addSubview:integralLabel];
    
    CGFloat twoLineY = CGRectGetMaxY(integralLabel.frame);
    UIView *twoLine = [[UIView alloc]initWithFrame:CGRectMake(PYSpaceX,twoLineY, fDeviceWidth - 30 *rateW, 0.5 *rateH)];
    twoLine.backgroundColor = PYColor(@"cccccc");
    [bgView addSubview:twoLine];
    
    CGFloat useY = CGRectGetMaxY(twoLine.frame);
    UILabel *useLabel = [[UILabel alloc]initWithFrame:CGRectMake(PYSpaceX, useY, 38*rateW,55*rateH)];
    useLabel.backgroundColor = PYColor(@"ffffff");
    useLabel.text = @"使用";
    useLabel.font = PYSysFont(13 *rateH);
    useLabel.textColor = PYColor(@"515151");
    [bgView addSubview:useLabel];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(useLabel.frame), useY + 14 *rateH, 68 *rateW, 27 *rateH)];
    //    textField.placeholder = @"新建一个标签...";
    textField.backgroundColor = PYColor(@"f5f5f5");
    textField.layer.cornerRadius = 4 *rateH;
    textField.layer.borderColor = PYColor(@"acacae").CGColor;
    textField.layer.borderWidth = 1*rateH;
    textField.font = PYSysFont(24 *rateH);
    textField.textColor = PYColor(@"222222");
//    [textField becomeFirstResponder];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    // textField
    textField.delegate = self;
      self.textField = textField;
    self.textField.enabled = NO;
    [PYNotificationCenter addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:nil];
    [bgView addSubview:textField];
    
    CGFloat useIntegralX = CGRectGetMaxY(textField.frame) + 6 *rateW;
    UILabel *useIntegralLable = [[UILabel alloc]initWithFrame:CGRectMake(useIntegralX, useY, fDeviceWidth - useIntegralX - PYSpaceX ,55*rateH)];
    useIntegralLable.font = PYSysFont(13 *rateH);
    useIntegralLable.textColor = PYColor(@"515151");
    [bgView addSubview:useIntegralLable];
    self.useIntegralLable = useIntegralLable;
    [self setUseIntegralLbl];
    CGFloat threeLineY = CGRectGetMaxY(useIntegralLable.frame);
    UIView *threeLine = [[UIView alloc]initWithFrame:CGRectMake(0,threeLineY, fDeviceWidth , 0.5 *rateH)];
    threeLine.backgroundColor = PYColor(@"cccccc");
    [bgView addSubview:threeLine];
    
    
    
    // 下面的
    UIView *twoBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(threeLine.frame) + 84*rateH, fDeviceWidth, 65 *rateH)];
     twoBgView.backgroundColor = PYColor(@"ffffff");
    [self.view addSubview:twoBgView];
     UIView *fourLine = [[UIView alloc]initWithFrame:CGRectMake(0,0, fDeviceWidth , 0.5 *rateH)];
    fourLine.backgroundColor = PYColor(@"cccccc");
    [twoBgView addSubview:fourLine];
    
    UILabel *buyMoeny = [[UILabel alloc]initWithFrame:CGRectMake(PYSpaceX, 13 *rateH, 100, 13 *rateH)];
    buyMoeny.text = @"代购金额";
    buyMoeny.font = PYSysFont(13 *rateH);
    buyMoeny.textColor = PYColor(@"999999");
    [twoBgView addSubview:buyMoeny];
    
    UILabel *moeny = [[UILabel alloc]initWithFrame:CGRectMake(fDeviceWidth - 120, 13 *rateH, 100, 13 *rateH)];
    moeny.text = self.strPrice;
    moeny.font = PYSysFont(13 *rateH);
    moeny.textColor = PYColor(@"999999");
    moeny.textAlignment = NSTextAlignmentRight;
    [twoBgView addSubview:moeny];
    
    UILabel *IntegralToUse = [[UILabel alloc]initWithFrame:CGRectMake(PYSpaceX, 40 *rateH, 100, 13 *rateH)];
    IntegralToUse.text = @"积分抵用";
    IntegralToUse.font = PYSysFont(13 *rateH);
    IntegralToUse.textColor = PYColor(@"999999");
    [twoBgView addSubview:IntegralToUse];
    
    UILabel *IntegralMoeny = [[UILabel alloc]initWithFrame:CGRectMake(fDeviceWidth - 120, 40 *rateH, 100, 13 *rateH)];
    IntegralMoeny.text = strUseIntegral;
    IntegralMoeny.font = PYSysFont(13 *rateH);
    IntegralMoeny.textColor = PYColor(@"f24949");
    IntegralMoeny.textAlignment = NSTextAlignmentRight;
    self.IntegralMoeny = IntegralMoeny;
    [twoBgView addSubview:IntegralMoeny];
    
    UIView *fiveLine = [[UIView alloc]initWithFrame:CGRectMake(0, 64.5 *rateH, fDeviceWidth, 0.5 *rateH)];
    fiveLine.backgroundColor = PYColor(@"cccccc");
    [twoBgView addSubview:fiveLine];
    
    
}

- (void)setupBottom
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, fDeviceHeight -44*rateH, fDeviceWidth, 44*rateH )];
    bottomView.backgroundColor = PYColor(@"ffffff");
    [self.view addSubview:bottomView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, 0.5 *rateH)];
    line.backgroundColor = PYColor(@"7f7f7f");
    [bottomView addSubview:line];
    
    UILabel *realpaymentLable = [[UILabel alloc]initWithFrame:CGRectMake(PYSpaceX,0, 45 *rateW,44 *rateH)];
    realpaymentLable.text = @"实付款:";
    realpaymentLable.font = PYSysFont(13 *rateH);
    realpaymentLable.textColor = PYColor(@"999999");
    [bottomView addSubview:realpaymentLable];
    
    UILabel *realpayment = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(realpaymentLable.frame),0, 100,44 *rateH)];
//    realpayment.text = ;
    realpayment.font = PYSysFont(17 *rateH);
    realpayment.textColor = PYColor(@"f24949");
    [bottomView addSubview:realpayment];
    self.moeny = realpayment;
    [self setMoney];
    
    
    CGFloat confirmBtnX = fDeviceWidth - 82*rateW -PYSpaceX;
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(confirmBtnX, 7 *rateH, 82 *rateW, 30 *rateH)];
    [confirmBtn setTitle:@"提交代购" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:PYColor(@"ffffff") forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = PYSysFont(15 *rateH);
    [confirmBtn setBackgroundImage:[UIImage resizedImage:@"bt_home_normal_somewhere2"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage resizedImage:@"bt_home_press_somewhere2"] forState:UIControlStateSelected];
    [bottomView addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
//    self.confirmBtn.enabled = NO;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmBtnClick
{
//    ConfirmBuyViewController *vc = [[ConfirmBuyViewController alloc]init];
//    [self.navigationController pushViewController:vc
//                                         animated:YES];
    [self confirmBuy];
}

-(void)getIntegral
{
    NSDictionary* params = @{@"userId":[CMData getUserId],//购买者ID
                             @"token":[CMData getToken]
                             };
    
    [CMAPI postUrl:API_USER_TRADE
             Param:params
          Settings:nil
        completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
            if(succeed)
            {
                NSDictionary* result = [detailDict objectForKey:RESULT];
                strIntegral = [result objectForKey:@"nowScore"];
                ratio_1 = [[result objectForKey:@"param"] intValue];
                
                self.integralLabel.text = [NSString stringWithFormat:@"可用积分:%@,抵￥%.2f",strIntegral,[strIntegral floatValue]/ratio_1];
                
                if ([strIntegral floatValue]>0)
                {
                    self.textField.enabled = YES;
                    self.confirmBtn.enabled = YES;
                }
                else
                {
                    self.textField.enabled = NO;
                    self.confirmBtn.enabled = YES;
                }
            }
        }];
}

-(void)confirmBuy
{
    NSDictionary* params = @{
                             @"noteId":self.strID,//帖子ID
                             @"noteUserId":self.strOwnerID,//帖子 拥有者ID
                             @"buyUserId":[CMData getUserId],//购买者ID
                             @"orderPrice":self.strPrice,//购买者 总定金
                             @"virtualPrice":strUseIntegral,//购买者 使用的积分
                             @"token":[CMData getToken]
                             };
    
    [CMAPI postUrl:API_USER_CONFIRM_TRADE
             Param:params
          Settings:nil
        completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
            if (succeed) {
                NSDictionary* result = [detailDict objectForKey:RESULT];
                NSString* orderID = [result objectForKey:@"out_trade_no"];
                NSString* tradeID = [result objectForKey:@"tradeId"];
                //orderString 订单参数列表
                NSString* strPrice = self.moeny.text;
                strPrice = [strPrice stringByReplacingOccurrencesOfString:@"￥" withString:@""];
                NSString *orderString = [Alipay getOrderString:orderID price:strPrice];
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
                            
                            [self paySucced:tradeID];
                        }
                        else if ([resultStatus isEqualToString:@"8000"]){
                            showStr=@"支付正在处理中，稍后可查看支付结果";
                            
                            [self paySucced:tradeID];
                        }
                        else if ([resultStatus isEqualToString:@"6002"]){
                            showStr=@"支付失败，请检查网络连接";
                            
                            [self payFail:tradeID];
                        }
                        else if ([resultStatus isEqualToString:@"4000"]){
                            showStr=@"支付失败";
                            
                            [self payFail:tradeID];
                        }
                        else{//加入最后一个没有判断的分支，是为了适应支付宝的扩展
                            showStr=@"支付失败";
                            
                            [self payFail:tradeID];
                        }
                        
                        [SVProgressHUD showInfoWithStatus:showStr];
                        
                    }
                }];
                
                [[self.navigationController popViewControllerAnimated:YES].navigationController popViewControllerAnimated:YES];
            }
        }];
}
- (void)payFail:(NSString* )tradedId
{
    NSDictionary *dic = @{@"tradeId":tradedId,@"type":@"note"};
    
    [CMAPI postUrl:API_PAYFAIL Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            
        }else{
            
        }
    }];
}

- (void)paySucced:(NSString* )tradedId
{
    NSDictionary *dic = @{@"tradeId":tradedId,@"type":@"note"};
    
    [CMAPI postUrl:API_PAYSUCCED Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
        }else{
            
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = textField.text;
    NSRange left = NSMakeRange(0,range.location);
    NSRange right = NSMakeRange(range.location,text.length-range.location);
    text = [NSString stringWithFormat:@"%@%@%@",[text substringWithRange:left],string,[text substringWithRange:right]];
    
    BOOL result = NO;
    
    NSArray* array = [text componentsSeparatedByString:@"."];
    
    if(array.count > 2&&self.maxNum>0)
    {
        
    }
    else if(array.count == 2)
    {
        NSString* string = array[1];
        if (string.length > self.maxNum||self.maxNum==0) {
            
        }
        else
        {
            NSString* strResult = [NSString stringWithFormat:@"%.2f",([text floatValue] - [self.strPrice floatValue]*ratio_1)];
            int intResult = [strResult floatValue]*100;
            
            if ((intResult >= 0||([text intValue] > [strIntegral intValue]))&&self.type == BuyTypeConfirm) {
                if (intResult == 0) {
                    [SVProgressHUD showInfoWithStatus:@"积分抵现不能等于价格"];
                }else if (intResult > 0) {
                    [SVProgressHUD showInfoWithStatus:@"不能超过价格"];
                }else{
                    [SVProgressHUD showInfoWithStatus:@"不能超过可用积分"];
                }
            }
            else
            {
                result = YES;
            }
        }
        
    }
    else
    {
        NSString* strResult = [NSString stringWithFormat:@"%.2f",([text floatValue] - [self.strPrice floatValue]*ratio_1)];
        int intResult = [strResult floatValue]*100;
        
        if ((intResult >= 0||([text intValue] > [strIntegral intValue]))&&self.type == BuyTypeConfirm) {
            if (intResult == 0) {
                [SVProgressHUD showInfoWithStatus:@"积分抵现不能等于价格"];
            }else if (intResult > 0) {
                [SVProgressHUD showInfoWithStatus:@"不能超过价格"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"不能超过可用积分"];
            }
        }
        else
        {
            result = YES;
        }

    }
    return result;
}

-(void)changeText
{
    
    NSString* text = self.textField.text;
    
    switch (self.type) {
        case BuyTypeConfirm:
        {
            strUseIntegral = [NSString stringWithFormat:@"%.2f",[text floatValue]/ratio_1];
            [self setUseIntegralLbl];
            [self setMoney];
//            self.confirmBtn.enabled = text.length>0;
        }
            break;
        case BuyTypeApply:
        {
            self.confirmBtn.enabled = [text floatValue]>0;
        }
            break;
        default:
        {
            self.confirmBtn.enabled = [text floatValue]>0;
        }
            break;
    }
}

-(void)setUseIntegralLbl
{
    self.useIntegralLable.text = [NSString stringWithFormat:@"积分,抵￥%@",strUseIntegral];
    self.IntegralMoeny.text = strUseIntegral;
}

-(void)setMoney
{
    self.moeny.text = [NSString stringWithFormat:@"￥%.2f",[self.strPrice floatValue] - [strUseIntegral floatValue]];
}

@end
