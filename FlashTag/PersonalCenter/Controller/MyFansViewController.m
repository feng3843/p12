//
//  MyFansViewController.m
//  11111111111111111111
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 MyOS. All rights reserved.
//  我的粉丝页面

#import "MyFansViewController.h"
#import "MyFansView.h"
#import "MyFansTableViewCell.h"
#import "FollowedUserModel.h"

#import "MJRefresh.h"

@interface MyFansViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic , strong)MyFansView *myFansView;

@property(nonatomic ,strong)NSMutableArray *dataSourceArr;

@property(nonatomic , assign)int page;

@end

@implementation MyFansViewController

- (NSMutableArray *)dataSourceArr
{
    if (_dataSourceArr == nil) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"我的粉丝";
    self.myFansView = [[MyFansView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.myFansView;
    
    [self.myFansView.tableView showEmptyList:self.dataSourceArr Image:IMG_DEFAULT_PERSONALCENTER_FANS_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_FANS_NODATASTRING ByCSS:NoDataCSSTop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMyFansData];
    self.page = 0;
    
    self.myFansView.tableView.delegate = self;
    self.myFansView.tableView.dataSource = self;
    
    MJRefreshAutoGifFooter* footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.page = self.page + 10;
        
        [self loadMyFansData];
        
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
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_PERSONALCENTER_FANS_LISTEND]] forState:MJRefreshStateNoMoreData];
    self.myFansView.tableView.footer = footer;
    
    
    self.myFansView.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=0;
        
        [_dataSourceArr removeAllObjects];

        [self loadMyFansData];
        
        [self.myFansView.tableView.header endRefreshing];

    }];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-

- (void)loadMyFansData
{
    [self getMyFansData];
    [self.myFansView.tableView.footer endRefreshing];
}

- (void)getMyFansData {
    NSDictionary *param = @{@"userId":@([self.userId intValue]),
                            @"type":@"followedUsers",
                            @"count":@(10),
                            @"orderRanking":@(self.page)};
    
    [CMAPI postUrl:API_GET_ATTENTIONS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {

        NSLog(@"%%%%%%%%%%%%%%%%%%%@" , detailDict);
        id result = [detailDict objectForKey:@"result"];
        if (succeed) {
            [self.dataSourceArr addObjectsFromArray:[FollowedUserModel objectArrayWithKeyValuesArray:[result objectForKey:@"userList"]]];
            [self.myFansView.tableView reloadData];
        }
        else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            else
            {   
                if (self.dataSourceArr.count > 0)
                {
                    [self.myFansView.tableView.footer noticeNoMoreData];
                }
            }
        }
        [self.myFansView.tableView showEmptyList:self.dataSourceArr Image:IMG_DEFAULT_PERSONALCENTER_FANS_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_FANS_NODATASTRING ByCSS:NoDataCSSTop];
    }];
    
}

#pragma mark-

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
//    MyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (nil == cell) {
//        cell = [[MyFansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.userHeardImage.image = [UIImage imageNamed:@"test2.jpg"];
//    cell.userName.text = @"zpz";
//    cell.infoLabel.text = @"帖子10个，粉丝20个";
//    [cell.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    
////    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *myFansCellId = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
    MyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myFansCellId];
    if (cell == nil) {
        cell = [[MyFansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myFansCellId];
    }
    if (_dataSourceArr.count > 0) {
        
        cell.myFansModel=_dataSourceArr[indexPath.row];
    }
    
    return cell;
}

//- (void)attentionButtonAction:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    
//    if (sender.selected) {
//        sender.backgroundColor = PYColor(@"ee5748");
//    }else{
//        sender.backgroundColor = PYColor(@"cccccc");
//    }
//    
//    UITableViewCell *cell = (UITableViewCell *)sender.superview;
//    NSIndexPath *indexPath = [self.myFansView.tableView indexPathForCell:cell];
//    NSLog(@"%ld" , indexPath.row);
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCalculateV(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowedUserModel *model = self.dataSourceArr[indexPath.row];
    
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


@end
