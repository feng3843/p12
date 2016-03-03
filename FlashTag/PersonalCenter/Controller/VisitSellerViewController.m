//
//  VisitSellerViewController.m
//  22222222222222222
//
//  Created by MyOS on 15/8/29.
//  Copyright (c) 2015年 MyOS. All rights reserved.
//  访问卖家页面

#import "VisitSellerViewController.h"
#import "UserCenterPostModel.h"
#import "CDChatRoomController.h"
#import "UIView+Extension.h"

@interface VisitSellerViewController ()<UIScrollViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UIAlertViewDelegate>


@property(nonatomic , strong)NSMutableArray *postArray;
@property(nonatomic , strong)NSMutableArray *fileArray;

@property(nonatomic , assign)BOOL isAttention;

@property(nonatomic , copy)NSString *myID;


@property(nonatomic , assign)int postCount;
@property(nonatomic , assign)int topCount;

//刷新
@property(nonatomic , assign)int page;

@property(nonatomic , strong)UIAlertView *attentionAlert;

@end


static NSString *userCenterPostCellID = @"userCenterSellerPostCellID";

static NSString *folderSystemCollectionViewCellID = @"FolderSystemCollectionViewCellID";


@implementation VisitSellerViewController

- (void)loadView
{
    [super loadView];
    
    self.visitSellerView = [[VisitSellerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.visitSellerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postCount = 10;

    
    //
    self.myID = [[HandyWay shareHandyWay] changeUserId:self.userId];
    
    
    self.topCount = 0;
    self.page = 0;

    self.postArray = [NSMutableArray array];
    self.fileArray = [NSMutableArray array];
    
    
    [self addCollectionView];
    
    
    [self networkRequestForPost];
    
    //刷新加载
    [self reloadDataEvent];
}


#pragma mark - 刷新加载
- (void)reloadDataEvent
{
    MJRefreshAutoGifFooter* footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 10;
        
        if (self.postCount == 10) {
            
            [self networkRequestForPost];
            
        }else if (self.postCount == 20){
            
            [self networkRequestForFile];
            
        }
        
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
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_ALL_LISTEND]] forState:MJRefreshStateNoMoreData];
    
    self.visitSellerView.postCollectionView.footer = footer;
}


- (void)addAction
{
    //左上按钮
    [self.leftTopButton addTarget:self action:@selector(leftTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加按钮
    [self.addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //聊天按钮
    [self.chatButton addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //热度按钮
    [self.hotButton addTarget:self action:@selector(hotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //关注数按钮
    [self.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //粉丝数按钮
    [self.fansButton addTarget:self action:@selector(fansButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //segment点击事件
    
    [self.buttonView.btn1 addTarget:self action:@selector(btn1Act:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView.btn2 addTarget:self action:@selector(btn2Act:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 各按钮点击事件
- (void)btn1Act:(UIButton *)sender {

    [self.postArray removeAllObjects];
    self.page = 0;
    self.postCount = 10;
    [self networkRequestForPost];
}
- (void)btn2Act:(UIButton *)sender {

    [self.fileArray removeAllObjects];
    self.postCount = 20;
    [self networkRequestForFile];

}

- (void)leftTopButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)addButtonAction:(UIButton *)sender
{
    if ([[CMData getUserId] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"登录之后才能操作!"];
    }else{

    NSString *type;
    if (self.isAttention) {
        type = @"取消关注该用户?";
       self.returnBackBlock(@"no");
    }else{
        type = @"关注该用户?";
       self.returnBackBlock(@"yes");
    }

    self.attentionAlert = [[UIAlertView alloc] initWithTitle:nil message:type delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [self.attentionAlert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.attentionAlert]) {
        if (buttonIndex) {
            [self networkRequestForAttention];
        }
    }
}

- (void)chatButtonAction:(UIButton *)sender
{
    if ([[CMData getUserId] isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"登录之后才能操作!"];
    }
    else
    {
        [self openSessionByClientId:[CMData getUserId] navigationToIMWithTargetClientIDs:[[NSArray alloc] initWithObjects:self.userId, nil] StringChatName:self.nameLabel.text];
    }
}
- (void)openSessionByClientId:(NSString*)clientId navigationToIMWithTargetClientIDs:(NSArray *)clientIDs StringChatName:(NSString*)chatName {
    WEAKSELF
    NSLog(@"%@",clientId);
    NSString* otherId = clientIDs[0];
    CMContact* contact;
    CDChatRoomController *vc=[[CDChatRoomController alloc] init];
    vc.otherId = otherId;
    vc.type = CDChatRoomTypeSingle;
    contact = [CMData queryContactById:otherId];
    if (!contact)
    {
        contact = [[CMContact alloc] init];
    }
    contact.strContactID = otherId;
    contact.strName = chatName;
    vc.other = contact;
    [CMData saveContacts:[@[contact] mutableCopy] OrgId:nil];
    [weakSelf.navigationController pushViewController:vc animated:YES];
}


- (void)hotButtonAction:(UIButton *)sender
{
    
}

- (void)attentionButtonAction:(UIButton *)sender
{
    
}

- (void)fansButtonAction:(UIButton *)sender
{
    
}



- (void)addCollectionView
{
    //帖子页面
    [self.visitSellerView.postCollectionView registerClass:[PostCollectionViewCell class] forCellWithReuseIdentifier:userCenterPostCellID];
    self.visitSellerView.postCollectionView.delegate = self;
    self.visitSellerView.postCollectionView.dataSource = self;
    
    
    // 注册页眉（section的header）
    [self.visitSellerView.postCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"123456789"];
    
    //文件夹页面
    [self.visitSellerView.postCollectionView registerClass:[FolderSystemCollectionViewCell class] forCellWithReuseIdentifier:folderSystemCollectionViewCellID];
    
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.postCount == 10) {
        
        return self.postArray.count;
        
    }else if(self.postCount == 20){
        if (self.fileArray.count > 0) {
            return self.fileArray.count - 1;
        }
        return 0;
    }
    return 0;
}

//设置collectionView的分区头(或分区脚)
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //判断到底是设置分区头还是分区脚
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //        这种情况是设置分区头
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"123456789" forIndexPath:indexPath];
        headerView.backgroundColor = PYColor(@"ffffff");
        
        
        if (self.topCount == 0) {
            [self addSubviewsWithView:headerView];
            
            self.topCount++;
        }
        
        return  headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"000000000" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor greenColor];
        return  footerView;
    }
}

- (void)addSubviewsWithView:(UICollectionReusableView *)view
{
    
    //上边浅色视图
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kCalculateV(93))];
//    topView.backgroundColor = [UIColor lightGrayColor];
//    [view addSubview:topView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kCalculateV(93))];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.clipsToBounds = YES;
    
    self.topView1 = [[UIImageView alloc] initWithFrame:CGRectMake(-50, -50, fDeviceWidth + 100, kCalculateV(93) + 100)];
    self.topView1.backgroundColor = [UIColor lightGrayColor];
    self.topView1.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:self.topView1];
    
    [view addSubview:bgView];

    
    //左上角按钮
    CGFloat buttonW = kCalculateH(12);
    CGFloat buttonH = kCalculateV(20);
    
    self.leftTopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.leftTopButton.frame = CGRectMake(kCalculateH(15), kCalculateV(14), buttonW, buttonH);
    [self.leftTopButton setBackgroundImage:[UIImage imageNamed:@"btn_other_back"] forState:UIControlStateNormal];
    [view addSubview:self.leftTopButton];
    
    //用户头像
    CGFloat userHeadSize = kCalculateH(100);
    self.userHeardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.userHeardButton.layer.masksToBounds = YES;
    self.userHeardButton.layer.cornerRadius = userHeadSize/2;
    self.userHeardButton.layer.borderWidth = userHeadSize/100;
    self.userHeardButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [view addSubview:self.userHeardButton];
    self.userHeardButton.frame = CGRectMake((fDeviceWidth - userHeadSize)/2, kCalculateV(43), userHeadSize, userHeadSize);
    [self.userHeardButton setBackgroundImage:[UIImage imageNamed:@"ic_head"] forState:UIControlStateNormal];
    
    //添加Button
    CGFloat tagImageViewSize = kCalculateH(33);
    self.addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addButton.frame = CGRectMake(fDeviceWidth - kCalculateH(98), kCalculateV(76.5), tagImageViewSize, tagImageViewSize);
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"btn_add_gray"] forState:UIControlStateNormal];
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = tagImageViewSize/2;
    [view addSubview:self.addButton];
    //
    self.addButton.userInteractionEnabled = NO;
    
    //聊天Button
    self.chatButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.chatButton.frame = CGRectMake(fDeviceWidth - kCalculateH(55), kCalculateV(76.5), tagImageViewSize, tagImageViewSize);
    [self.chatButton setBackgroundImage:[UIImage imageNamed:@"btn_chat"] forState:UIControlStateNormal];
    self.chatButton.layer.masksToBounds = YES;
    self.chatButton.layer.cornerRadius = tagImageViewSize/2;
    [view addSubview:self.chatButton];
    
    //用户名
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userHeardButton.frame), CGRectGetMaxY(self.userHeardButton.frame) + kCalculateV(10), CGRectGetWidth(self.userHeardButton.frame), kCalculateH(16))];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(16)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = PYColor(@"7f7f7f");
    [view addSubview:self.nameLabel];
    
    //热度等级
    self.hotButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.hotButton.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + kCalculateH(5), CGRectGetMinY(self.nameLabel.frame), self.nameLabel.frame.size.height, self.nameLabel.frame.size.height);
    [view addSubview:self.hotButton];
    
    
    //关注数
    CGFloat buttonWith = kCalculateH(70);
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.attentionButton.frame = CGRectMake((fDeviceWidth - buttonWith * 2 - kCalculateH(10))/2, CGRectGetMaxY(self.nameLabel.frame) + kCalculateV(15), buttonWith, kCalculateH(13));
    [self.attentionButton setTitleColor:PYColor(@"7f7f7f") forState:UIControlStateNormal];
    self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    [view addSubview:self.attentionButton];
    
    //粉丝数
    self.fansButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.fansButton.frame = CGRectMake(CGRectGetMaxX(self.attentionButton.frame) + kCalculateH(5), CGRectGetMinY(self.attentionButton.frame), buttonWith, kCalculateH(13));
    [self.fansButton setTitleColor:PYColor(@"7f7f7f") forState:UIControlStateNormal];
    self.fansButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    [view addSubview:self.fansButton];
    
    
    //地点
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.attentionButton.frame) + kCalculateV(12), fDeviceWidth - 100, kCalculateV(15))];
    self.placeLabel.textAlignment = NSTextAlignmentCenter;
    self.placeLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.placeLabel.textColor = PYColor(@"7f7f7f");
    [view addSubview:self.placeLabel];
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.userHeardButton.frame) + kCalculateV(88), fDeviceWidth, kCalculateV(40));
    self.buttonView = [[ButtonView alloc] initWithFrame:frame andTwoButtonArr:@[@"帖子", @"文件夹"]];
    _buttonView.btn1.selected = YES;
    [view addSubview:_buttonView];

    
    
    [self addAction];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //在这里分类处理
    if (self.postCount == 10) {
        //帖子页面
        
        PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userCenterPostCellID forIndexPath:indexPath];
        
        if (self.postArray.count > 0) {
            UserCenterPostModel *model = self.postArray[indexPath.row];
            [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, model.noteId]] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
            
            NSLog(@"%@" , [NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], @(04), model.noteId]);
            cell.commentButton.likesLabel.text = model.comments;
            [cell.commentButton addTarget:self action:@selector(cellCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentButton.tag = indexPath.row + 2000;
            
            cell.collectButton.likesLabel.text = model.likes;
            if ([model.isLiked isEqualToString:@"yes"]) {
                cell.collectButton.tagImage.image = [UIImage imageNamed:@"ic_press_like"];
            }else{
                cell.collectButton.tagImage.image = [UIImage imageNamed:@"ic_like"];
                
            }
            [cell.collectButton addTarget:self action:@selector(cellCollectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.collectButton.tag = indexPath.row + 3000;
            
        }
        
        return cell;
        
    }
    
    
    //文件夹页面
    
    FolderSystemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:folderSystemCollectionViewCellID forIndexPath:indexPath];
    
    NSMutableArray *array = [NSMutableArray array];
    if (indexPath.row == 0) {
        NSArray *array1 = [NSArray arrayWithArray:self.fileArray[0][@"hotList"]];
        NSArray *array2 = [NSArray arrayWithArray:self.fileArray[1][@"hotList"]];
        
        for (NSDictionary *dic in array1) {
            [array addObject:dic];
        }
        
        for (NSDictionary *dic in array2) {
            [array addObject:dic];
        }
        
        cell.topLabel.text = @"货位";
    }else{
        NSArray *array1 = [NSArray arrayWithArray:self.fileArray[indexPath.row + 1][@"hotList"]];
        
        for (NSDictionary *dic in array1) {
            [array addObject:dic];
        }
        cell.topLabel.text = self.fileArray[indexPath.row + 1][@"placeName"];
    }
    
    NSInteger count = array.count;
    cell.reminderLabel.text = [NSString stringWithFormat:@"%d个帖子" , count];
    
    if (count > 0) {
        
        for (int i = 0; (i < count) && (i < 4); i++) {
            if (i == 0) {
                [cell.bottomImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[0][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
                
                cell.bottomSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
                cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
            }else if (i == 1){
                [cell.bottomSmallImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[1][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
                
                cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
                cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
            }else if (i == 2){
                [cell.bottomSmallImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[2][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
                
                cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
            }else if (i == 3){
                [cell.bottomSmallImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], self.myID, array[3][@"noteId"]]] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
            }
            
        }
    }else{
        cell.bottomImageView.image = [UIImage imageNamed:@"ic_xianzhi"];
        cell.bottomSmallImageView1.image = [UIImage imageNamed:@"ic_xianzhi"];
        cell.bottomSmallImageView2.image = [UIImage imageNamed:@"ic_xianzhi"];
        cell.bottomSmallImageView3.image = [UIImage imageNamed:@"ic_xianzhi"];
    }
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %d , row = %d" , indexPath.section , indexPath.row);
    
    if (self.postCount == 10) {

        UserCenterPostModel *model = self.postArray[indexPath.row];
        
        [[HandyWay shareHandyWay] pushToNoteDetailWithController:self NoteId:model.noteId UserId:model.userId];
    }else{
        
        PostListViewController *postListVC = [PostListViewController new];
        postListVC.userId = self.userId;
        
        if (indexPath.row == 0) {
            
            postListVC.itemID = @"seller";
            postListVC.title = @"货位";
            postListVC.itemID111 = self.fileArray[0][@"placeId"];
            postListVC.itemID222 = self.fileArray[1][@"placeId"];
            
        }else{
            
            postListVC.itemID = self.fileArray[indexPath.row + 1][@"placeId"];
            postListVC.title = self.fileArray[indexPath.row + 1][@"placeName"];
        }
        
        [self.navigationController pushViewController:postListVC animated:YES];
        
        
    }

}


#pragma mark - 评论,点赞
- (void)cellCommentButtonAction:(UIButton *)sender{

     if([[CMData getUserId] isEqualToString:@""]) {
         
    [SVProgressHUD showErrorWithStatus:@"登录之后才能操作!"];
         
     }else{

    NSLog(@"comment");
    
    CommentViewController *vc = [CommentViewController new];
    
    UserCenterPostModel *model = self.postArray[sender.tag - 2000];
    
    vc.noteId = model.noteId;
    vc.noteOwnerId = model.userId;
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.commentCount = ^(NSString *commentCount)
         {
             if (![commentCount isEqualToString:@"0"]) {
                 
                 model.comments =[NSString stringWithFormat:@"%d",[model.comments intValue ] +[commentCount intValue]];
                 [self.visitSellerView.postCollectionView reloadData];
                 return;
                 
                 
             }
         };
    }
}

- (void)cellCollectButtonAction:(UIButton *)sender
{
    NSLog(@"collect");
    if ([[CMData getUserId] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"登录之后才能操作!"];
    }else{

    [[HandyWay shareHandyWay] postLikesWithButton:sender Array:self.postArray tag:3000];
    }
}


#pragma mark - netWorking
//networkingForUserInfo
- (void)networkingRequestForSeller
{
    //[CMData getUserIdForInt]   [CMData getUserIdForInt]
    
    NSDictionary *param = @{@"targetUserId":self.userId,@"userId":@([CMData getUserIdForInt])};
    
    [CMAPI postUrl:API_USER_PRPFILE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"%@" , detailDict);
            //配置用户信息
            [self setUserInfoWithDctionary:detailDict[@"result"]];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

//帖子列表
- (void)networkRequestForPost
{
    [self.visitSellerView.postCollectionView reloadData];
    NSDictionary *param = @{@"userId":self.userId,@"orderRanking":@(self.page),@"order":@(1),@"orderRule":@"myNotes"};
    
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"帖子列表*************%@" , detailDict);
            NSMutableArray *arr = [NSMutableArray arrayWithArray:detailDict[@"result"][@"noteList"]];
            for (NSDictionary *dic in arr) {
                UserCenterPostModel *model = [[UserCenterPostModel alloc] initWithDictionary:dic];
                [self.postArray addObject:model];
            }
            
            [self.visitSellerView.postCollectionView reloadData];
            [self.visitSellerView.postCollectionView.footer endRefreshing];
        }else{
            
            

            
            if ([[[detailDict objectForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                if (self.postArray.count > 0)
                {
                    
                    [self.visitSellerView.postCollectionView.footer noticeNoMoreData];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
                
            }
        }
//        [self.visitSellerView.postCollectionView showEmptyList:self.postArray Image:IMG_DEFAULT_PERSONALCENTER_NOTE_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_NOTE_NODATASTRING ByCSS:NoDataCSSTop];
    }];
}

//文件夹
- (void)networkRequestForFile
{
    
    [self.visitSellerView.postCollectionView reloadData];
    NSDictionary *param = @{@"userId":self.userId,@"type":@"all"};
    
    [CMAPI postUrl:API_GET_FOLODERSORSHELVES Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"文件夹列表______________________%@" , detailDict);
            
            [self.fileArray removeAllObjects];
            
            [self.fileArray addObject:detailDict[@"result"][@"free"]];
            [self.fileArray addObject:detailDict[@"result"][@"pay"]];
            
            [self.fileArray addObject:detailDict[@"result"][@"sys"]];
            
            for (NSDictionary *dic in (NSArray*)detailDict[@"result"][@"custom"]) {
                [self.fileArray addObject:dic];
            }
            [self.visitSellerView.postCollectionView reloadData];
            
            if (self.fileArray.count > 0) {
                [self.visitSellerView.postCollectionView.footer noticeNoMoreData];
            }
        }else{
            if (![[[detailDict objectForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
            }
            else
            {
                if (self.fileArray.count > 0)
                {
                    [self.visitSellerView.postCollectionView.footer noticeNoMoreData];
                }
            }
        }
    }];
    
}

//关注和取消关注
- (void)networkRequestForAttention
{
    NSString *type;
    if (self.isAttention) {
        type = @"no";
    }else{
        type = @"yes";
    }
    
    NSDictionary *dic = @{@"token":[CMData getToken],@"userId":@([CMData getUserIdForInt]),@"attention":type,@"attentionType":@(2),@"attentionObject":self.userId};
    
    [CMAPI postUrl:API_USER_ATTENTION Param:dic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            if (self.isAttention) {
                self.isAttention = NO;
                [self.addButton setBackgroundImage:[UIImage imageNamed:@"btn_add_red"] forState:UIControlStateNormal];
                
            }else{
                self.isAttention = YES;
                [self.addButton setBackgroundImage:[UIImage imageNamed:@"btn_add_gray"] forState:UIControlStateNormal];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

#pragma mark - 得到数据后给页面赋值
- (void)setUserInfoWithDctionary:(NSDictionary *)dic
{
    [self.userHeardButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , self.userId]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
    NSLog(@"头像头像..............%@" , [NSString stringWithFormat:@"%@userIcon/icon/%@.jpg" , [CMData getCommonImagePath] , self.userId]);
    
    [self.topView1 getGSImageWithDegree:10.0 ByUserId:self.userId];
    
    self.nameLabel.text = dic[@"targetDisplayName"];
    
    [self.hotButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_%@" , dic[@"level"]]] forState:UIControlStateNormal];
    
    [self.attentionButton setTitle:[NSString stringWithFormat:@"关注:%@" , dic[@"followings"]] forState:UIControlStateNormal];
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝:%@" , dic[@"followedUsers"]] forState:UIControlStateNormal];
    
    if ([dic[@"attention"] isEqualToString:@"yes"]) {
        self.isAttention = YES;
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"btn_add_gray"] forState:UIControlStateNormal];
    }else{
        self.isAttention = NO;
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"btn_add_red"] forState:UIControlStateNormal];
    }
    self.addButton.userInteractionEnabled = YES;
    
    
    NSArray *arr = [NSArray arrayWithArray:dic[@"credit"]];
    if (arr.count == 0) {
        
    }else if (arr.count == 1){
        self.placeLabel.text = [NSString stringWithFormat:@"🔴 %@" , arr[0]];
    }else if (arr.count == 2){
        self.placeLabel.text = [NSString stringWithFormat:@"🔴 %@ %@" , arr[0] , arr[1]];
    }else if (arr.count > 2){
        self.placeLabel.text = [NSString stringWithFormat:@"🔴 %@ %@ %@" , arr[0] , arr[1] , arr[2]];
    }
    
}

#pragma mark - 每次进入页面更新用户信息
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self networkingRequestForSeller];
    
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
