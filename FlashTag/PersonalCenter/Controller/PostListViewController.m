//
//  PostListViewController.m
//  FlashTag
//
//  Created by MyOS on 15/10/13.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  文件夹下帖子列表

#import "PostListViewController.h"

#import "UserCenterPostModel.h"

@interface PostListViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property(nonatomic , strong)NSMutableArray *postArray;

@end

static NSString *cellId = @"postList";

@implementation PostListViewController

- (void)loadView
{
    [super loadView];
    
    self.rootView = [[PostListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.view = self.rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.postArray = [NSMutableArray array];
    
    [self.rootView.collectionView registerClass:[PostCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    self.rootView.collectionView.delegate = self;
    self.rootView.collectionView.dataSource = self;
    
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];

    if ([self.itemID isEqualToString:@"seller"]) {
        
        [self networkRequestForVisitSeller];
    }else{
        [self networkRequestForPlace];

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.postArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UserCenterPostModel *model = self.postArray[indexPath.row];
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], [[HandyWay shareHandyWay] changeUserId:self.userId], model.noteId]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
    
    cell.commentButton.likesLabel.text = model.comments;
    [cell.commentButton addTarget:self action:@selector(cellCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentButton.tag = indexPath.row  + 2000;
    
    cell.collectButton.likesLabel.text = model.likes;
    [cell.collectButton addTarget:self action:@selector(cellCollectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.collectButton.tag = indexPath.row + 3000;
    
    return cell;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    UserCenterPostModel *model = self.postArray[indexPath.row];
    
    [[HandyWay shareHandyWay] pushToNoteDetailWithController:self NoteId:model.noteId UserId:model.userId];
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
              [self.rootView.collectionView reloadData];
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
    NSDictionary *param = @{@"itemIds":self.itemID,@"orderRule":@"folder",@"userId":self.userId , @"count":@"1000"};
    
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"帖子列表*************%@" , detailDict);
            
            NSArray *arr = [NSMutableArray arrayWithArray:detailDict[@"result"][@"noteList"]];
            for (NSDictionary *dic in arr) {
                UserCenterPostModel *model = [[UserCenterPostModel alloc] initWithDictionary:dic];
                
                [self.postArray addObject:model];
            }
            
            [self.rootView.collectionView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
    
}



//针对访问卖家第一个文件夹
- (void)networkRequestForVisitSeller
{
    NSDictionary *param = @{@"itemIds":self.itemID111,@"orderRule":@"folder",@"userId":self.userId , @"count":@"1000"};
    
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil
        completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        if (succeed)
        {
            NSLog(@"帖子列表*************%@" , detailDict);
            
            NSArray *arr = [NSMutableArray arrayWithArray:detailDict[@"result"][@"noteList"]];
            for (NSDictionary *dic in arr) {
                UserCenterPostModel *model = [[UserCenterPostModel alloc] initWithDictionary:dic];
                [self.postArray addObject:model];
            }
            
            [self againNetwork];
        }
        else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
        }
    }];

}

- (void)againNetwork
{
    NSDictionary *param = @{@"userId":self.userId};
    
    [CMAPI postUrl:API_GETPAYSHELFINFO Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        if (succeed) {
            NSLog(@"帖子列表*************%@" , detailDict);
            NSArray *arr = [NSMutableArray arrayWithArray:detailDict[@"result"][@"shelfList"]];
            for (NSDictionary *dic in arr) {
                UserCenterPostModel *model = [[UserCenterPostModel alloc] initWithDictionary:dic];
                
                [self.postArray addObject:model];
            }
            [self.rootView.collectionView reloadData];
        }else{
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
        }
    }];

}


@end
