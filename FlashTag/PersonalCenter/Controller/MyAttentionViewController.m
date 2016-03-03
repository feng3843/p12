//
//  MyAttentionViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  我的关注页面

#import "MyAttentionViewController.h"
#import "MyAttentionView.h"
#import "AttentionUserTableViewCell.h"
#import "MyAttentionCollectionViewCell.h"
#import "FollowedUserModel.h"
#import "FollowedTagsModel.h"
#import "BiaoQianVC.h"

#import "MJRefresh.h"

@interface MyAttentionViewController ()<UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource>

@property(nonatomic , strong)MyAttentionView *myAttentionView;

@property(nonatomic ,strong)NSMutableArray *dataSourceUserArr;
@property(nonatomic ,strong)NSMutableArray *dataSourceTagArr;

@property(nonatomic , assign)int page;

@end

static NSString *collectionCellID = @"collectionCell";

@implementation MyAttentionViewController

- (NSMutableArray *)dataSourceUserArr
{
    if (_dataSourceUserArr == nil) {
        _dataSourceUserArr = [NSMutableArray array];
    }
    return _dataSourceUserArr;
}

- (NSMutableArray *)dataSourceTagArr
{
    if (_dataSourceTagArr == nil) {
        _dataSourceTagArr = [NSMutableArray array];
    }
    return _dataSourceTagArr;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"我的关注";
    self.myAttentionView = [[MyAttentionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.myAttentionView;
    
    [self.myAttentionView.tableView showEmptyList:self.dataSourceUserArr Image:IMG_DEFAULT_PERSONALCENTER_ATTENTION_USER_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_ATTENTION_USER_NODATASTRING ByCSS:NoDataCSSTop];
    [self.myAttentionView.collectionView showEmptyList:self.dataSourceTagArr Image:IMG_DEFAULT_PERSONALCENTER_ATTENTION_TAG_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_ATTENTION_TAG_NODATASTRING ByCSS:NoDataCSSTop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self addAction];
    
    
    self.page = 0;
    
    MJRefreshAutoGifFooter* footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.page = self.page + 10;
        
        [self getUserArrData:NO];
        
        [self.myAttentionView.tableView.footer endRefreshing];
    }];
    footer.refreshingTitleHidden = YES;
    NSArray* refreshingImages = [CMTool getRefreshingImages];
    
    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateIdle];
    // 设置无新数据状态的动画图片
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_HOME_FIND_LISTEND]] forState:MJRefreshStateNoMoreData];
    
    self.myAttentionView.tableView.footer = footer;
    
    self.myAttentionView.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=0;
        
        [_dataSourceUserArr removeAllObjects];
        
        [self getUserArrData:NO];
        
        [self.myAttentionView.tableView.header endRefreshing];
        
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


- (void)addAction
{
    [self.myAttentionView.userButton addTarget:self action:@selector(userButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.myAttentionView.tagButton addTarget:self action:@selector(tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.myAttentionView.tableView.delegate = self;
    self.myAttentionView.tableView.dataSource = self;
    
    self.myAttentionView.collectionView.delegate = self;
    self.myAttentionView.collectionView.dataSource = self;
    [self.myAttentionView.collectionView registerClass:[MyAttentionCollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
}

- (void)userButtonAction:(UIButton *)sender
{
    self.myAttentionView.tableView.hidden = NO;
    self.myAttentionView.collectionView.hidden = YES;
    
    [sender setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    
    [self.myAttentionView.tagButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    
}

- (void)tagButtonAction:(UIButton *)sender
{
    self.myAttentionView.tableView.hidden = YES;
    self.myAttentionView.collectionView.hidden = NO;
    
    [sender setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    
    [self.myAttentionView.userButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
}

#pragma mark-

-(void)loadData{
    [self loadUserArrData];
    [self loadTagArrData];
}

- (void)loadUserArrData
{
    [self getUserArrData:NO];
    
}

-(void)loadTagArrData{
    [self getUserArrData:YES];
}

- (void)getUserArrData:(BOOL)pIsTagType {
    NSDictionary *param = nil;
    if (pIsTagType)
        param = @{@"userId":@([self.userId intValue]),
                  @"type":@"followedTags"};
    else
        param = @{@"userId":@([self.userId intValue]),
                  @"type":@"followings",
                  @"orderRanking":@(self.page)};
    
    [CMAPI postUrl:API_GET_ATTENTIONS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        if (succeed) {
            
            NSLog(@"____________________________%@" , detailDict);
            
            if (pIsTagType) {
                [self.dataSourceTagArr addObjectsFromArray:[FollowedTagsModel objectArrayWithKeyValuesArray:[result objectForKey:@"followedTags"]]];
                [self.myAttentionView.collectionView reloadData];
            }else{
                [self.dataSourceUserArr addObjectsFromArray:[FollowedUserModel objectArrayWithKeyValuesArray:[result objectForKey:@"userList"]]];
                [self.myAttentionView.tableView reloadData];
            }
        }
        else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }else{
                
                if (pIsTagType)
                {
                    if(self.dataSourceTagArr.count > 0)
                    {
                        [self.myAttentionView.collectionView.footer noticeNoMoreData];
                    }
                }
                else
                {
                    if(self.dataSourceUserArr.count > 0)
                    {
                        [self.myAttentionView.tableView.footer noticeNoMoreData];
                    }
                }
            }
        }
        [self.myAttentionView.tableView showEmptyList:self.dataSourceUserArr Image:IMG_DEFAULT_PERSONALCENTER_ATTENTION_USER_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_ATTENTION_USER_NODATASTRING ByCSS:NoDataCSSTop];
        [self.myAttentionView.collectionView showEmptyList:self.dataSourceTagArr Image:IMG_DEFAULT_PERSONALCENTER_ATTENTION_TAG_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_ATTENTION_TAG_NODATASTRING ByCSS:NoDataCSSTop];
    }];
    
}

#pragma mark-

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceUserArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
////    static NSString *cellID = @"attentionUserCell";
//     NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
//    AttentionUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//   
//    if (nil == cell) {
//        cell = [[AttentionUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.userHeardImage.image = [UIImage imageNamed:@"test2.jpg"];
//    cell.userName.text = @"zpz";
//    cell.infoLabel.text = @"帖子10个，粉丝20个";
//    [cell.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *attentionUserCellId = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];;
    AttentionUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionUserCellId];
    if (cell == nil) {
        cell = [[AttentionUserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:attentionUserCellId];
    }
    
    if (_dataSourceUserArr.count > 0) {
        cell.followedsModel=_dataSourceUserArr[indexPath.row];
    }
    
    
    return cell;
}

//- (void)attentionButtonAction:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        sender.backgroundColor = PYColor(@"ee5748");
//    }else{
//        sender.backgroundColor = PYColor(@"cccccc");
//    }
//    
//    UITableViewCell *cell = (UITableViewCell *)sender.superview;
//    NSIndexPath *indexPath = [self.myAttentionView.tableView indexPathForCell:cell];
//    NSLog(@"%ld" , indexPath.row);
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCalculateV(64);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    FollowedUserModel *model = self.dataSourceUserArr[indexPath.row];
    
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


#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceTagArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MyAttentionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
//    
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test2.jpg"]];
//    
//    if (indexPath.row == 0) {
//        cell.taglabel.text = @"标签名字是八个字";
//    }else{
//        cell.taglabel.text = @"zpz";
//    }
    
    MyAttentionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyAttentionCollectionViewCell alloc] init];
    }
    cell.followedTagsModel=_dataSourceTagArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collection");
    
    FollowedTagsModel *model = self.dataSourceTagArr[indexPath.row];
    
    BiaoQianVC *vc = [BiaoQianVC new];
    vc.biaoQianName = model.tagName;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}





@end
