//
//  FreePlaceViewController.m
//  FlashTag
//
//  Created by MyOS on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  免费货位页面

#import "FreePlaceViewController.h"
#import "UserCenterPostModel.h"

@interface FreePlaceViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property(nonatomic , strong)NSMutableArray *postArray;

//自定义弹出框
@property(nonatomic , strong)UIView *bgView;
@property(nonatomic , strong)UIView *remindView1;

@end

static NSString *freeCellID = @"freeCellID";
static NSString *nilCellID = @"nilCell";
static NSString *firstCell = @"first";

@implementation FreePlaceViewController

- (void)loadView
{
    [super loadView];
    
    self.freePlaceView = [[FreePlaceView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.freePlaceView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费货位";
    self.navigationController.navigationBar.translucent = NO;

    
    self.postArray = [NSMutableArray array];
    
    //设置货位展示
    [self.freePlaceView.allCollectionView registerClass:[PostCollectionViewCell class] forCellWithReuseIdentifier:freeCellID];
    [self.freePlaceView.allCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:firstCell];
    [self.freePlaceView.allCollectionView registerClass:[FolderChargeCollectionViewCell class] forCellWithReuseIdentifier:nilCellID];
    self.freePlaceView.allCollectionView.delegate = self;
    self.freePlaceView.allCollectionView.dataSource = self;
    
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    [self networkRequestForPlace];
    
    [self setReminderView];
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
    //    imageView.backgroundColor = [UIColor blueColor];
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



- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.postArray.count + 1 + self.postCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        FolderChargeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstCell forIndexPath:indexPath];
        
        cell.topLabel.text = @"免费货位";
        cell.midImageView.image = [UIImage imageNamed:@"ic_lock2"];
        [cell.bottomButton setTitle:@"兑换" forState:UIControlStateNormal];
        [cell.bottomButton addTarget:self action:@selector(duiHuan) forControlEvents:UIControlEventTouchUpInside];
        return cell;

       
    }else if (indexPath.row < self.postCount + 1) {
        
            FolderChargeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:nilCellID forIndexPath:indexPath];
            
            cell.topLabel.text = @"闲置货位";
            cell.midImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
            cell.bottomLabel.text = @"快发布新代购吧^_^";
            return cell;
            
        }else{
            UserCenterPostModel *model = self.postArray[indexPath.row - self.postCount - 1];
            PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:freeCellID forIndexPath:indexPath];
            
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], [[HandyWay shareHandyWay] changeUserId:[CMData getUserId]], model.noteId]] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
            
            cell.commentButton.likesLabel.text = model.comments;
            [cell.commentButton addTarget:self action:@selector(cellCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentButton.tag = indexPath.row - self.postCount - 1 + 2000;
            
            cell.collectButton.likesLabel.text = model.likes;
            [cell.collectButton addTarget:self action:@selector(cellCollectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.collectButton.tag = indexPath.row - self.postCount - 1 + 3000;
            
            return cell;
        }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self duiHuan];
    }else if (indexPath.row < self.postCount + 1){
        //写帖子?
        
    }else{
        //帖子详情
        

        UserCenterPostModel *model = self.postArray[indexPath.row - self.postCount - 1];
        
        [[HandyWay shareHandyWay] pushToNoteDetailWithController:self NoteId:model.noteId UserId:model.userId];
    }
}

- (void)duiHuan
{
    [self.view addSubview:self.bgView];
}


#pragma mark - 评论,点赞
- (void)cellCommentButtonAction:(PostLikesButton *)sender
{
    NSLog(@"comment");
    
    CommentViewController *vc = [CommentViewController new];
    
            //帖子页面
        UserCenterPostModel *model = self.postArray[sender.tag - 2000];
        
        vc.noteId = model.noteId;
        vc.noteOwnerId = model.userId;
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.commentCount = ^(NSString *commentCount)
    {
        if (![commentCount isEqualToString:@"0"]) {
          
                    model.comments =[NSString stringWithFormat:@"%d",[model.comments intValue ] +[commentCount intValue]];
                    [self.freePlaceView.allCollectionView reloadData];
                    return;
                
            
        }
    };

}

- (void)cellCollectButtonAction:(PostLikesButton *)sender
{
    NSLog(@"collect");
    
    [[HandyWay shareHandyWay] postLikesWithButton:sender Array:self.postArray tag:3000];
}


#pragma mark - network
- (void)networkRequestForPlace
{
    NSDictionary *param = @{@"itemIds":self.itemID,@"orderRule":@"folder",@"userId":@([CMData getUserIdForInt])};
    
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"帖子列表*************%@" , detailDict);
            
            [self.postArray removeAllObjects];
            
            NSArray *arr = [NSMutableArray arrayWithArray:detailDict[@"result"][@"noteList"]];
            for (NSDictionary *dic in arr) {
                UserCenterPostModel *model = [[UserCenterPostModel alloc] initWithDictionary:dic];
               
                    [self.postArray addObject:model];
            }
            
            [self.freePlaceView.allCollectionView reloadData];
            
        }else{
            
            
            if (![[[detailDict objectForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
            }else{
                
                
                //查询无数据
            }

           
        }
    }];

}

//兑换货位
//货位价格??


//进行兑换
- (void)networkRequestForGetShelvesByScore
{
    NSDictionary *dic = @{@"userId":@([CMData getUserIdForInt]),@"token":[CMData getToken],@"score":@(1000),@"shelfCount":@(1)};
    
    [CMAPI postUrl:API_GET_SHELVESBYSCODE Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            [SVProgressHUD showSuccessWithStatus:@"兑换成功!"];
            
            [self networkRequestForPlace];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}


@end
