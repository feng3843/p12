//
//  JingXuanVC.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
// 精选主页面

#import "JingXuanVC.h"
#import "BigCollectionViewCell.h"
#import "LittleCollectionViewCell.h"
#import "ZhuTiVC.h"
#import "ZhuanGuiVC.h"
#import "SpecialsModel.h"

#import "GetDataTool.h"
#import "MJRefresh.h"


@interface JingXuanVC () <UICollectionViewDataSource, UICollectionViewDelegate, GetDataDelegate>

@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, strong) NSMutableArray *bigArr;
@property (nonatomic, strong) NSMutableArray *littleArr;
@property (nonatomic, assign) int orderRanking;

@end
@implementation JingXuanVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self putCollectionView];
    self.orderRanking = 0;
    [self getDataFromNetwithOrderRanking:_orderRanking];
}

- (void)putCollectionView {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    CGRect frame = CGRectMake(0, 0, fDeviceWidth, self.view.frame.size.height-49-fNavBarHeigth);
    self.collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = PYColor(@"e7e7e7");
    [self.view addSubview:self.collectionView];
    self.bigArr = [NSMutableArray array];
    self.littleArr = [NSMutableArray array];
    //注册cell
    [self.collectionView registerClass:[BigCollectionViewCell class] forCellWithReuseIdentifier:@"bigCell"];
    [self.collectionView registerClass:[LittleCollectionViewCell class] forCellWithReuseIdentifier:@"littleCell"];
}

- (void)getDataFromNetwithOrderRanking:(int)orderRanking {
    GetDataTool *getDataTool = [[GetDataTool alloc] init];
    getDataTool.delegate = self;
    [getDataTool getDataOfSearchViewWithPath:API_GET_SPECIALSORADS andParam:@{@"type": @"specials", @"orderRanking":@(orderRanking), @"count":@(50)} withViewTitle:@"jingxuan"];
    [getDataTool getDataOfSearchViewWithPath:API_GET_SPECIALSORADS andParam:@{@"type": @"shops", @"orderRanking":@(orderRanking), @"count":@(50)} withViewTitle:@"shops"];
}

#pragma mark GetDataToolDelegate
- (void)getedDataWithArr:(NSArray *)dataArr andPath:(NSString *)pathStr andTitle:(NSString *)title{
    self.imagePath = pathStr;
    if ([title isEqualToString:@"jingxuan"]) {
//        self.bigArr = [NSMutableArray arrayWithArray:dataArr];
        [self.bigArr addObjectsFromArray:dataArr];
        [self.collectionView reloadData];
        
    } else if ([title isEqualToString:@"shops"]) {
//        self.littleArr = [NSMutableArray arrayWithArray:dataArr];
        [self.littleArr addObjectsFromArray:dataArr];
        [self.collectionView reloadData];
    }
}



//===========================================================================================

#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _bigArr.count; //上面大图
    } else {
        return _littleArr.count;//下面小图
    }
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //精选
    if (indexPath.section == 0) {
        SpecialsModel *tempModel = (SpecialsModel *)self.bigArr[indexPath.row];
        BigCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bigCell" forIndexPath:indexPath];
        [cell sizeToFit];
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@specials/specials%@.jpg", _imagePath, tempModel.itemId];
        [cell.picView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
        cell.textLabel.text = tempModel.itemTitle;
        return cell;
        //专柜
    } else {
        SpecialsModel *tempModel = (SpecialsModel *)self.littleArr[indexPath.row];
        LittleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"littleCell" forIndexPath:indexPath];
        [cell sizeToFit];
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@shops/shops%@.jpg", _imagePath, tempModel.itemId];
        [cell.picView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
        cell.textLabel.text = tempModel.itemTitle;
        return cell;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 2, 0);//上左下右
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = (219.0 / 320)*([UIScreen mainScreen].bounds.size.width);
    CGFloat phoneWidth = [UIScreen mainScreen].bounds.size.width;
    if (indexPath.section == 0) {
        return CGSizeMake(phoneWidth, height);
        
    } else {
        NSInteger littleWidth = [UIScreen mainScreen].bounds.size.width / 2 - 1;
        NSInteger littleHeight = (88.0/159)*littleWidth;
        return CGSizeMake(littleWidth, littleHeight);
    }
}

//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}
//动态设置每个分区的最小item间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}



#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"选择了第一个分区的第%ld个cell", (long)indexPath.row);
        ZhuTiVC *zhuTiVC = [[ZhuTiVC alloc] init];
        zhuTiVC.hidesBottomBarWhenPushed = YES;
        zhuTiVC.specialModel = (SpecialsModel *)self.bigArr[indexPath.row];
        zhuTiVC.navigationItem.title = zhuTiVC.specialModel.itemTitle;
        [self.navigationController pushViewController:zhuTiVC animated:YES];
        
    } else {
        NSLog(@"选择了第二个分区的第%ld个cell",(long)indexPath.row);
        ZhuanGuiVC *zhuanguiVC = [[ZhuanGuiVC alloc] init];
        zhuanguiVC.hidesBottomBarWhenPushed = YES;
        zhuanguiVC.specialModel = (SpecialsModel *)self.littleArr[indexPath.row];
        zhuanguiVC.navigationItem.title = zhuanguiVC.specialModel.itemTitle;
        [self.navigationController pushViewController:zhuanguiVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
