//
//  JingXuanUserViewController.m
//  FlashTag
//
//  Created by MyOS on 15/10/20.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "JingXuanUserViewController.h"
#import "JingXuanUserModel.h"

@interface JingXuanUserViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic , strong)UITableView *tableView;

@end

@implementation JingXuanUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最佳推荐用户";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kQPHeight)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = PYColor(@"e7e7e7");
//    self.tableView.backgroundColor = [UIColor blueColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    //返回按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];

}


- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *myFansCellId = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
    MyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myFansCellId];
    if (cell == nil) {
        cell = [[MyFansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myFansCellId];
    }
    if (self.array.count) {
        
        cell.jingXuanUserModel=self.array[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    JingXuanUserModel *model = self.array[indexPath.row];
    
    if ([model.role isEqualToString:@"2"]) {
        VisitSellerViewController *vc = [VisitSellerViewController new];
        
        vc.userId = model.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.role isEqualToString:@"0"]){
        
        VisitBuyerViewController *vc = [VisitBuyerViewController new];
        
        vc.userId = model.userId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCalculateV(60);
}

@end
