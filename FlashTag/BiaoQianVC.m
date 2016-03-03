//
//  BiaoQianVC.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  标签视图


#import "BiaoQianVC.h"
#import "CollectionCell.h"
#import "NoteModel.h"
#import "CommonInterface.h"
#import "CommentViewController.h"
#import "CelllButton.h"
#import "NoteDetailViewController.h"
#import "NSString+Extensions.h"

@interface BiaoQianVC () <UICollectionViewDataSource, UICollectionViewDelegate, noteCollectionViewDelegate>

@property (nonatomic, strong) UIButton *guanZhuBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *noteCountView;
@property (nonatomic, assign) int orderRanking;

@end

@implementation BiaoQianVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.biaoQianName;
    //创建返回按钮
    [self creatBackButton];
    //创建关注按钮
    [self creatGuanZhuButton];
    //创建collectionView
    [self creatCollectionView];
    //获取数据
    [self getDataWithOrderRanking:0];
    //刷新加载
    [self reloadDataEvent];
}

#pragma mark - 刷新加载
- (void)reloadDataEvent
{
    //获取帖子页面数据
    self.dataArr = [NSMutableArray array];
    self.orderRanking=0;
    MJRefreshAutoGifFooter* footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
//        self.orderRanking = self.orderRanking+10;
        [self getDataWithOrderRanking:self.dataArr.count ];
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
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_PERSONALCENTER_NOTE_LISTEND]] forState:MJRefreshStateNoMoreData];
    
    self.collectionView.footer = footer;
    
}
#pragma mark 页面布局
- (void)creatCollectionView {
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGRect frame = CGRectMake(0, 0, fDeviceWidth, self.view.frame.size.height-kCalculateV(70));
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.tag = 200;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    //注册cell
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"item"];
}
- (void) creatBackButton {
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
}
- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatGuanZhuButton {
    self.guanZhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _guanZhuBtn.frame = CGRectMake(fDeviceWidth-kCalculateH(69)-15, kCalculateV(12), kCalculateH(69), kCalculateV(27));
    _guanZhuBtn.layer.masksToBounds = YES;
    _guanZhuBtn.layer.cornerRadius = 3.0;
    [_guanZhuBtn setBackgroundColor:PYColor(@"f24949")];
    [_guanZhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_guanZhuBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [_guanZhuBtn setTitleColor:PYColor(@"f5f5f5") forState:UIControlStateNormal];
    [_guanZhuBtn setTitleColor:PYColor(@"f5f5f5") forState:UIControlStateSelected];
    _guanZhuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_guanZhuBtn addTarget:self action:@selector(guanZhuAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_guanZhuBtn];
}

#pragma mark 获取网络数据
- (void)getDataWithOrderRanking:(int)orderRanking {
    NSString *utf8Str = [NSString stringWithString:[self.biaoQianName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *param = @{@"order":@(0), @"orderRanking":@(orderRanking), @"count":@(10), @"orderRule":@"hottestTag", @"tagNames":utf8Str, @"userId":[CMData getUserId]};//用户获取帖子列表
    [self getDataWithPath:API_GET_NOTELIST andParam:param];
}

- (void)getDataWithPath:(NSString *)path andParam:(NSDictionary *)dic {
    [CMAPI postUrl:path Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        PYLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>热门标签为:%@搜索的结果是:%@", self.biaoQianName, result);
        if (succeed) {
            //判断是否已经关注过:
            if ([result[@"isFollowedTag"] isEqualToString:@"yes"]) {
                //创建已关注按钮
                self.guanZhuBtn.selected = YES;
                self.guanZhuBtn.backgroundColor = PYColor(@"cccccc");
            } else {
                //创建关注按钮
                self.guanZhuBtn.selected = NO;
                self.guanZhuBtn.backgroundColor = PYColor(@"f24949");
            }
            
            NSArray *dataArr = result[@"noteList"];//
            for (NSDictionary *dic in dataArr) {
                NoteModel *noteModel = [[NoteModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:noteModel];
            }
            [self addNoteCount:result[@"tagNoteNum"] andGuanZhuCount:result[@"tagFollowedNum"]];
            [self.collectionView reloadData];
            [self.collectionView.footer resetNoMoreData];
        } else {
            [self.noteCountView removeFromSuperview];
            [self.collectionView.footer noticeNoMoreData];
        }
    }];
}

//添加关注数和帖子数
- (void)addNoteCount:(NSString *)noteCount andGuanZhuCount:(NSString *)guanzhuCount {
    self.noteCountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, 30)];
    [self.collectionView addSubview:_noteCountView];
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(10), 0, 300, 30)];
    tempLabel.text = [NSString stringWithFormat:@"%@帖子, %@关注", noteCount, guanzhuCount];
    tempLabel.textColor=PYColor(@"a8a8a8");
    tempLabel.font = [UIFont systemFontOfSize:13];
    [_noteCountView addSubview:tempLabel];
}


#pragma mark 关注
- (void)guanZhuAction:(UIButton *)sender {
    if (sender.selected == NO) {
//实现关注
        NSDictionary *param = @{@"token":[CMData getToken],
                                @"userId":@([CMData getUserIdForInt]),
                                @"attention":@"yes",
                                @"attentionType":@(4),
                                @"attentionObject":self.biaoQianName
                                };
        [CommonInterface callingInterfaceAttention:param succeed:^{
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            self.guanZhuBtn.selected = YES;
            self.guanZhuBtn.backgroundColor = PYColor(@"cccccc");
        }];
//实现取消关注
    } else {
        NSDictionary *param = @{@"token":[CMData getToken],
                                @"userId":@([CMData getUserIdForInt]),
                                @"attention":@"no",
                                @"attentionType":@(4),
                                @"attentionObject":self.biaoQianName
                                };
        [CommonInterface callingInterfaceAttention:param succeed:^{
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            self.guanZhuBtn.selected = NO;
            self.guanZhuBtn.backgroundColor = PYColor(@"f24949");
        }];
    }
}

#pragma mark - UICollectionViewDataSource
//设置collectionView分区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//设置每个分区item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
//针对于每一个item返回对应的cell对象, cell重用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    NSString *path = [CMData getCommonImagePath];
    
    NoteModel *tempModel;
    tempModel = self.dataArr[indexPath.row];
    
    NSString *userID = [tempModel.userId get2Subs];
    NSString *noteID = tempModel.noteId;
    NSString *noteImageURLStr = [NSString stringWithFormat:@"%@/%@/note%@_1.jpg", path, userID, noteID];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:noteImageURLStr] placeholderImage:[UIImage imageNamed:@"img_default_notelist"]];//帖子图片
    
    cell.text.text = tempModel.noteDesc;//帖子描述
    cell.pingLun.text = [NSString stringWithFormat:@"%@", tempModel.comments];
    cell.dianZan.text = [NSString stringWithFormat:@"%@", tempModel.likes];
    
    //传值以实现点赞 评论
    cell.noteId = tempModel.noteId;
    cell.noteOwnerId = tempModel.userId;
    cell.isLike = tempModel.isLiked;
    cell.likes = [tempModel.likes intValue];
    cell.delegate = self;
    
    
    ((CelllButton *)cell.contentView2).buttonCell = cell;
    if ([cell.isLike isEqualToString:@"yes"]) {
        cell.contentView2.selected = YES;
        cell.dianZanImage.image = [UIImage imageNamed:@"ic_press_like"];
    } else {
        cell.contentView2.selected = NO;
        cell.dianZanImage.image = [UIImage imageNamed:@"ic_like"];
    }
    [cell.contentView2 addTarget:self action:@selector(dianZanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark 点赞
- (void)dianZanAction:(CelllButton *)sender {
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
    CommentViewController *commentVC = [CommentViewController new];
    commentVC.noteId = noteIdbyFans;
    commentVC.noteOwnerId = userId;
    commentVC.isNoHead = YES;
    self.navigationController.navigationBar.translucent=YES;
    [self.navigationController reloadInputViews];
    
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

#pragma mark -  UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NoteModel *tempModel;
    tempModel = self.dataArr[indexPath.row];
    NoteDetailViewController *noteDetailVC = [[NoteDetailViewController alloc] init];
    noteDetailVC.noteId = tempModel.noteId;
    noteDetailVC.noteUserId = tempModel.userId;
    [self.navigationController pushViewController:noteDetailVC animated:YES];
     noteDetailVC.returnBackBlock = ^(NSString *str) {
     };
}
#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat phoneWhite = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(phoneWhite/2 - 15, (phoneWhite/2 - 15) * 1.45);
}
//动态设置每个分区的缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, 10, 10, 10);
}
@end
