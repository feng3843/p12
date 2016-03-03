//
//  ZhuTiVC.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  主题活动哦页面

#import "ZhuTiVC.h"
#import "ZhuTiCell.h"
#import "CollectionCell.h"
#import "CelllButton.h"
#import "NoteModel.h"
#import "GetDataTool.h"
#import "CommonInterface.h"
#import "CommentViewController.h"
#import "MJRefresh.h"
#import "NoteDetailViewController.h"
#import "NSString+Extensions.h"
#import "UIImage+Extensions.h"


#import "JingXuanUserModel.h"
#import "LibCM.h"
#import "JingXuanUserViewController.h"
@interface ZhuTiVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GetDataDelegate, noteCollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int orderRanking;


@property(nonatomic , assign)float height;
@property(nonatomic , strong)NSMutableArray *userArray;

@end

@implementation ZhuTiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    
    self.userArray = [NSMutableArray array];
    //创建collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    //注册cell
    [self.collectionView registerClass:[ZhuTiCell class] forCellWithReuseIdentifier:@"ZhuTiCell"];//主题活动海报cell
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"TieZiCell"];//主题帖子cell
    //返回按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //获取帖子数据
    GetDataTool *dataTool = [GetDataTool new];
    dataTool.delegate = self;
    self.orderRanking = 0;
    [dataTool getZhuTiDataWithItemId:self.specialModel.itemId withOrderRanking:_orderRanking];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    UIImage *image = [UIImage resizedImage:@"bg_home_2nav"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    UIImage *image = [UIImage resizedImage:@"bg_home_2nav"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//下拉刷新
- (void)actionDown {
    GetDataTool *dataTool = [GetDataTool new];
    dataTool.delegate = self;
    [dataTool getZhuTiDataWithItemId:self.specialModel.itemId withOrderRanking:0];
    [self.collectionView.header endRefreshing];
}
//上拉加载
- (void)actionUp {
    _orderRanking = _orderRanking +5;
    GetDataTool *dataTool = [GetDataTool new];
    dataTool.delegate = self;
    [dataTool getZhuTiDataWithItemId:self.specialModel.itemId withOrderRanking:_orderRanking];
    [self.collectionView.footer endRefreshing];
}

#pragma mark getDataDelegate
- (void)getDataArr:(NSMutableArray *)dataArr {
    [self.dataArr addObjectsFromArray:dataArr[0]];
    
    
    for (NSDictionary *dic in dataArr[1]) {
        JingXuanUserModel *model = [[JingXuanUserModel alloc] initWithDictionary:dic];
        
        [self.userArray addObject:model];
    }
    
    if (_dataArr.count>0) {
        self.collectionView.backgroundColor = PYColor(@"e7e7e7");
    }
    [self.collectionView reloadData];
}

#pragma mark CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //判断是否为第一个分区(主题海报)(两个cell不相同)
    if (indexPath.section == 0) {
        ZhuTiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZhuTiCell" forIndexPath:indexPath];
        cell.nameLa.text = self.specialModel.itemTitle;
        cell.deta.text = self.specialModel.itemDesc;
        NSString* strIsAd = self.isAd?@"ads/ads":@"specials/specials";
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@%@.jpg", [CMData getCommonImagePath], strIsAd ,self.specialModel.itemId];
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        
        if (self.userArray.count) {
            cell.height = self.height;
            
            for (int i = 0; i < self.userArray.count; i++) {
                if (i == 6) {
                    break;
                }else{
                    
                    JingXuanUserModel *model = self.userArray[i];
                    
                    [((UIImageView *)[cell.userView viewWithTag:1000 + i]) sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:model.userId]] placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
                }
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [cell.userView addGestureRecognizer:tap];
        }
        
        return cell;
    } else {
        NoteModel *tempModel = self.dataArr[indexPath.row];
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TieZiCell" forIndexPath:indexPath];
        
        NSString *userID = [tempModel.userId get2Subs];
        NSString *noteID = tempModel.noteId;
        NSString *noteImageURLStr = [NSString stringWithFormat:@"%@/%@/note%@_1.jpg", [CMData getCommonImagePath], userID, noteID];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:noteImageURLStr] placeholderImage:[UIImage imageNamed:@"img_default_notelist"]];//帖子图片
        cell.pingLun.text = tempModel.comments;
        cell.dianZan.text = tempModel.likes;
        //传值实现点赞
        cell.noteId = tempModel.noteId;
        cell.noteOwnerId = tempModel.userId;
        ((CelllButton *)cell.contentView2).buttonCell = cell;
        cell.delegate = self;
        
        [cell.contentView2 addTarget:self action:@selector(dianZanAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([tempModel.isLiked isEqualToString:@"yes"]) {
            cell.contentView2.selected = YES;
            cell.dianZanImage.image = [UIImage imageNamed:@"ic_press_like"];
        } else {
            cell.contentView2.selected = NO;
            cell.dianZanImage.image = [UIImage imageNamed:@"ic_like"];
        }
        return cell;
    }
}

- (void)tapAction
{
    JingXuanUserViewController *vc = [[JingXuanUserViewController alloc] init];
    vc.array = self.userArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点赞
- (void)dianZanAction:(UIButton *)sender {
    CollectionViewCell *cell = ((CelllButton *)sender).buttonCell;
    if (sender.selected == YES) {
        //取消点赞
        NSDictionary *param = @{@"token":[CMData getToken],
                                @"userId":@([CMData getUserIdForInt]),
                                @"noteId":cell.noteId,
                                @"targetId":cell.noteOwnerId,
                                @"isLiked":@"no"};
        [CommonInterface callingInterfacePraise:param succeed:^{
            [SVProgressHUD showSuccessWithStatus:@"取消点赞成功"];
            int i = [cell.dianZan.text intValue];
            cell.dianZan.text = [NSString stringWithFormat:@"%d", i - 1];
            cell.dianZanImage.image = [UIImage imageNamed:@"ic_like"];
        }];
    } else {
        //点赞
        NSDictionary *param = @{@"token":[CMData getToken],
                                @"userId":@([CMData getUserIdForInt]),
                                @"noteId":cell.noteId,
                                @"targetId":cell.noteOwnerId,
                                @"isLiked":@"yes"};
        [CommonInterface callingInterfacePraise:param succeed:^{
            [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
            int i = [cell.dianZan.text intValue];
            cell.dianZan.text = [NSString stringWithFormat:@"%d", i + 1];
            cell.dianZanImage.image = [UIImage imageNamed:@"ic_press_like"];
        }];
    }
    sender.selected = !sender.selected;
}

#pragma mark 评论
- (void)paseUserId:(NSString *)userId AndNoteId:(NSString *)noteIdbyFans {
    //评论
    CommentViewController *commentVC = [CommentViewController new];
    commentVC.noteId = noteIdbyFans;
    commentVC.noteOwnerId = userId;
    [self.navigationController pushViewController:commentVC animated:YES];
    commentVC.commentCount = ^(NSString *commentCount)
    {
        if (![commentCount isEqualToString:@"0"]) {
            for (NoteModel *model in self.dataArr) {
                if([model.noteId isEqualToString:noteIdbyFans])
                {
                    
                    model.comments =[NSString stringWithFormat:@"%d",[model.comments intValue ] +[commentCount intValue]];
                    [self.collectionView reloadData];
                    return;
                }
            }
        }
    };
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat phoneWhite = [UIScreen mainScreen].bounds.size.width;
    if (indexPath.section == 0) {
        CGFloat height11 = [self getTagHeight];
        
        self.height = (219.0/320)*[UIScreen mainScreen].bounds.size.width + height11 + 30;
        
        if (self.userArray.count) {
            
            return CGSizeMake(phoneWhite, self.height + kCalculateV(44));

        }else{
            
            return CGSizeMake(phoneWhite, self.height);

        }
        
    } else {
        return CGSizeMake(phoneWhite/2 - 15, (phoneWhite/2 - 15) * 1.45);
    }
}

- (CGFloat)getTagHeight
{
    NSDictionary *browseCountDic = @{NSFontAttributeName: PYSysFont(14)};
    CGSize  tagOneBtn =[[NSString stringWithFormat:@"%@",self.specialModel.itemDesc]boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:browseCountDic context:nil].size;
    return tagOneBtn.height;
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
        NoteModel *tempModel;
        tempModel = self.dataArr[indexPath.row];
        NoteDetailViewController *noteDetailVC = [[NoteDetailViewController alloc] init];
        noteDetailVC.noteId = tempModel.noteId;
        noteDetailVC.noteUserId = tempModel.userId;
        [self.navigationController pushViewController:noteDetailVC animated:YES];
        noteDetailVC.returnBackBlock = ^(NSString *str) {
        };
    }
}

@end
