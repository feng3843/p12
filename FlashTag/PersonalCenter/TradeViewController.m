//
//  TradeViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  兑换页面

#import "TradeViewController.h"
#import "TradeView.h"
#import "ChargePlaceViewController.h"

@interface TradeViewController ()<UITableViewDelegate , UITableViewDataSource>

//自定义弹出框
@property(nonatomic , strong)UIView *bgView;
@property(nonatomic , strong)UIView *remindView1;

@property(nonatomic , strong)TradeView *tradeView;

//存放请求的数据
@property(nonatomic , strong)NSMutableArray *array;

@end

@implementation TradeViewController


- (void)loadView
{
    [super loadView];
    self.tradeView = [[TradeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.tradeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"兑换";
    
    self.tradeView.tableView.delegate = self;
    self.tradeView.tableView.dataSource = self;
    //关闭cell分割线
    self.tradeView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //
    self.tradeView.tableView.bounces = NO;
    
    [self.tradeView.tradeButton addTarget:self action:@selector(tradeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tradeView.score=self.score;
    
    [self networkingRequestTradeHistory];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(10, 10, 20, 20);
    [left setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    [self setReminderView];
}

- (void)leftItemAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tradeButtonAction:(UIButton *)sender
{
    [self.view addSubview:self.bgView];
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
    label.text = @"想要兑换免费的货位吗？";
    label.font = [UIFont systemFontOfSize:kCalculateH(13)];
    label.textColor = PYColor(@"222222");
    label.textAlignment = NSTextAlignmentCenter;
    [self.remindView1 addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(17), kCalculateV(39), kCalculateH(246), kCalculateV(100))];
    imageView.image = [UIImage imageNamed:@"ic_set meal2"];
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
    [ensureButton setTitle:@"兑换" forState:UIControlStateNormal];
    [ensureButton addTarget:self action:@selector(ensureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.remindView1 addSubview:ensureButton];
}

- (void)ensureButtonAction:(UIButton *)sender
{
    [self.bgView removeFromSuperview];
    
    [self networkRequestForGetShelvesByScore];
}

-(void)cancelButtonAction
{
    [self.bgView removeFromSuperview];
}

- (void)noResponseEvent
{
    
}
- (void)networkRequestForGetShelvesByScore
{
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"score":@(1000),@"shelfCount":@(1)};
    
    [CMAPI postUrl:API_GET_SHELVESBYSCODE Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            int scoreInt = [self.score intValue];
            self.tradeView.score=self.score=[NSString stringWithFormat:@"%d",scoreInt-1000];
            
            [SVProgressHUD showSuccessWithStatus:@"兑换成功!"];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}



#pragma mark-

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"tradeHistoryCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@" , self.array[indexPath.row][@"time"]];
    cell.textLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    cell.textLabel.textColor = PYColor(@"999999");
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"兑换%@个货位" , self.array[indexPath.row][@"count"]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    cell.detailTextLabel.textColor = PYColor(@"999999");
    
    //关闭cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCalculateV(22);
}

#pragma mark - network
//兑换历史
- (void)networkingRequestTradeHistory
{
    //[CMData getUserIdForInt] [CMData getToken] 4s20150914174205
//    NSDictionary *param = @{@"userId":@(4),@"token":@"4s20150914174205",@"orderRanking":@(0)};
    NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"orderRanking":@(0),@"count":@(1000)};
    
    [CMAPI postUrl:API_EXCNAGE_HISTORY Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"%@" , detailDict);
            self.array = [NSMutableArray arrayWithArray:detailDict[@"result"][@"records"]];
            [self.tradeView.tableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}





@end
