//
//  ZhuanGuiVC.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "ZhuanGuiVC.h"
#import "ZhuanGuiCell.h"
#import "CollectionCell.h"

@interface ZhuanGuiVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZhuanGuiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //创建collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    //注册cell
    [self.collectionView registerClass:[ZhuanGuiCell class] forCellWithReuseIdentifier:@"ZhuanGuiCell"];//主题活动海报cell
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"TieZiCell"];//帖子
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
}
- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//collectionView 代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 20;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //判断是否为第一个分区(主题海报)(两个cell不相同)
    if (indexPath.section == 0) {
        ZhuanGuiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZhuanGuiCell" forIndexPath:indexPath];
        cell.detailLabel.text = self.specialModel.itemDesc;
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@shops/shops%@.jpg", [CMData getCommonImagePath], self.specialModel.itemId];
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        
        return cell;
    } else {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TieZiCell" forIndexPath:indexPath];
        cell.imgView.image = [UIImage imageNamed:@"test1.jpg"];
        cell.pingLun.text = @"评论";
        cell.dianZan.text = @"点赞";
        cell.text.text = @"商品描述";
        return cell;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat phoneWhite = [UIScreen mainScreen].bounds.size.width;
    if (indexPath.section == 0) {
        return CGSizeMake(self.view.frame.size.width, [self getTagHeight]+60 + (219.0 / 320)*([UIScreen mainScreen].bounds.size.width));
    } else {
        return CGSizeMake(phoneWhite/2 - 15, phoneWhite/2 - 15 + 20);
    }
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10); //collectionView的最外层cell距离父视图(上, 左, 下, 右)的距离!
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"选择了第一个分区的第%d个cell", indexPath.row);
    } else {
        NSLog(@"选择了第二个分区的第%d个cell",indexPath.row);
    }
}

- (CGFloat)getTagHeight
{
    NSDictionary *browseCountDic = @{NSFontAttributeName: PYSysFont(14)};
    CGSize  tagOneBtn =[[NSString stringWithFormat:@"%@",self.specialModel.itemDesc]boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:browseCountDic context:nil].size;
    return tagOneBtn.height ;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
