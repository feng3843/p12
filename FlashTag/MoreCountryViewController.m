//
//  MoreCountryViewController.m
//  FlashTag
//
//  Created by MyOS on 15/10/14.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "MoreCountryViewController.h"

#import "TableViewCell.h"
#import "UserModel.h"

@interface MoreCountryViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic , strong)UITableView *tableView;
@property(nonatomic , strong)NSMutableArray *array;


@property (nonatomic, strong) UIView *noView;
@property (nonatomic, strong) UILabel *noCountLabel;

@end

@implementation MoreCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSMutableArray array];
    [self configureTableView];
    [self network];
}

- (void)configureTableView {
//    self.navigationController.navigationBar.translucent=YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight-49)];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.noView = [[UIView alloc] initWithFrame:self.view.bounds];
    _noView.backgroundColor = [UIColor whiteColor];
    self.noCountLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, kCalculateV(40), fDeviceWidth, kCalculateV(49))];
    _noCountLabel.textAlignment=NSTextAlignmentCenter;
    _noCountLabel.textColor=PYColor(@"a8a8a8");
    _noCountLabel.font = [UIFont systemFontOfSize:13];
    _noCountLabel.text = @"这儿暂时没有更多用户啦!";
    [self.view addSubview:_noView];
    [_noView addSubview:_noCountLabel];
    _noView.hidden=YES;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
}

- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCalculateV(60);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserModel *userList = (UserModel *)self.array[indexPath.row];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    NSString *path = [CMData getCommonImagePath];//path/userIcon/icon7.jpg;
    NSString *userImageStr = [NSString stringWithFormat:@"%@/userIcon/icon%@.jpg", path, userList.userId];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:userImageStr] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];//用户图像
    cell.userName.text = userList.userDisPlayName;//用户名字
    NSString *LVImageStr = [NSString stringWithFormat:@"img_search_hot_%@", userList.levle];
    cell.lvImage.image = [UIImage imageNamed:LVImageStr];//热卖度(等级)图片
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModel *model = self.array[indexPath.row];
    if ([model.role isEqualToString:@"2"]) {
        VisitSellerViewController *vc = [VisitSellerViewController new];
        vc.userId=model.userId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.role isEqualToString:@"0"]){
        VisitBuyerViewController *vc = [VisitBuyerViewController new];
        vc.userId=model.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)network {
    NSDictionary *dic = @{@"domain": self.country, @"orderRanking":@(0), @"count":@(50)};
    [CMAPI postUrl:API_GET_SELLERSBYCOUNTRY Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        PYLog(@"++_+_+_+_+_+_+_+__+搜索的同城普通卖家为:%@", detailDict);
        if (succeed) {
            
            for (NSDictionary *dic in result[@"sellers"]) {
                UserModel *user = [[UserModel alloc] initWithDictionary:dic];
                [self.array addObject:user];
            }
            [self.tableView reloadData];
            _noView.hidden = YES;
            
        } else {
            
            _noView.hidden = NO;
        }
    }];
    
}


@end
