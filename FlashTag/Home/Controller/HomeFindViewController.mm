//
//  HomeFindViewController.m
//  FlashTag
//
//  Created by 夏雪 on 15/8/27.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  首页发现
#import "HomeFindViewController.h"
#import "AdvertistingColumn.h"
#import "PYAllCommon.h"
#import "HomeImageCell.h"
#import "HomeLineLayout.h"
//#import "HomeCircleLayout.h"
#import "UIView+Extension.h"
#import "NoteInfoView.h"
#import "NoteDetailViewController.h"
#import "AdsModel.h"
#import "MJExtension.h"
#import "TagModel.h"
#import "NoteInfoModel.h"
#import "MJRefresh.h"
#import "UIView+AutoLayout.h"
#import "NoteConst.h"
#import "CommentViewController.h"
#import "UIImage+Extensions.h"
#import "UIDefaultImage+Puyun.h"
#define topH 219 * rateH
#import "ZhuTiVC.h"
#import "SpecialsModel.h"
#import "UIViewController+Puyun.h"
#import "FolderOperationViewController.h"

@interface HomeFindViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,HomeLineLayoutDelegate,NoteInfoViewDelegate,AdvertistingColumnDelegate,FolderOperationViewControllerDelegate>
{
    BOOL isFirst;
}
@property(nonatomic ,weak)UITableView *tableView;

@property(nonatomic ,weak)AdvertistingColumn *headView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic ,strong)NSMutableArray *noteArray;
//@property(nonatomic ,weak)UIView *topView;
@property (nonatomic, strong) NSMutableArray *tagsArray;

//@property(nonatomic,assign)int page;

@property(nonatomic,copy)NSString *currentTag;
// 导航栏
@property(nonatomic,assign)BOOL navIsHidden;
@property(nonatomic,assign)CGFloat navAlpha;
/**
 *  加载更多数据
 */
@property(nonatomic,assign)BOOL isLoadMore;
@end

@implementation HomeFindViewController
static NSString *const collectionID = @"image";

- (NSMutableArray *)images
{
    if (!_images) {
        self.images = [[NSMutableArray alloc] init];

    }
    return _images;
}

- (NSMutableArray *)tagsArray
{
    if (!_tagsArray) {
        self.tagsArray = [[NSMutableArray alloc] init];

    }
    return _tagsArray;
}

- (NSMutableArray *)noteArray
{
    if (_noteArray == nil) {
        _noteArray = [NSMutableArray array];
    }
    return _noteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[HandyWay shareHandyWay] postSiteEveryday];
    // Do any additional setup after loading the view.
    self.navAlpha = 1;
    self.isLoadMore = NO;
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, topH *rateH)];
//    self.topView = topView;
//    [self.view addSubview:topView];
    
    switch (self.type) {
        case HomeTypeFind:
        {
            [self setupAdvertisting];
        //       [self callingInterfaceNoteList:@"48hot"];
        }
            break;
        case HomeTypeAttention:
        default:
        {
//            topView.frame = CGRectZero;
            UIImageView* bgIV = [[UIImageView alloc] initWithFrame:self.view.frame];
            bgIV.image = [UIImage imageNamed:@"bg_attention"];
            [self.view addSubview:bgIV];
        }
            break;
    }
    [self setupTableSectionHead];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [tableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_7_0
    tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
#else
#endif
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    switch (self.type) {
        case HomeTypeAttention:
        {
            [self.tableView showEmptyList:@[] Image:IMG_DEFAULT_HOME_ATTENTION_NODATA Desc:IMG_DEFAULT_HOME_ATTENTION_NODATASTRING ByCSS:NoDataCSSMiddle];
        }
            break;
        case HomeTypeFind:
        {
            
        }
        default:
            break;
    }

    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    // 隐藏时间
    //footer.refreshingTitleHidden = YES;
    
    // 隐藏状态
    footer.refreshingTitleHidden = YES;
    
    NSArray* refreshingImages = [CMTool getRefreshingImages];
    
    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateIdle];
    // 设置无新数据状态的动画图片
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_HOME_FIND_LISTEND]] forState:MJRefreshStateNoMoreData];
    
    self.tableView.footer = footer;
    
    switch (self.type) {
        case HomeTypeFind:
        {
            [self callingInterfacehomeTags];
        }
            break;
        case HomeTypeAttention:
        default:
        {
            [self callingInterfaceNoteList];
        }
            break;
    }
    isFirst = YES;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage *navBgImage = [UIImage resizedImage:@"bg_home_nav.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:navBgImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBarHidden = self.navIsHidden;
    self.navigationController.navigationBar.alpha = self.navAlpha;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width + (self.collectionView.frame.size.width*0.5 + HMItemWH +12), self.collectionView.contentOffset.y)];
        isFirst = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navIsHidden = self.navigationController.navigationBar.isHidden;
    self.navAlpha = self.navigationController.navigationBar.alpha;
}

- (void)setupAdvertisting
{
    [self callingInterfaceSpecialsOrAds];
    AdvertistingColumn *headView = [[AdvertistingColumn alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, 219 * rateH)];
  //  NSArray *imgArray = [NSArray arrayWithObjects:@"Thome.png",@"Thome.png",@"Thome.png",nil];
    self.view.backgroundColor =[UIColor colorWithHexString:@"eaeaea"];
    self.headView = headView;
    headView.delegate = self;
   // [headView setArray:imgArray];
//    [self.topView addSubview:headView];
}


- (void)setupTableSectionHead
{
    CGRect rect = CGRectMake(0,0, fDeviceWidth, 89 *rateH);

    HomeLineLayout *lineLatout = [[HomeLineLayout alloc]init];
    lineLatout.delegate = self;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:lineLatout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"HomeImageCell" bundle:nil] forCellWithReuseIdentifier:collectionID];
//        [self.topView addSubview:collectionView];
    collectionView.backgroundColor = PYColor(@"e7e7e7");
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagsArray.count*3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.tagModel = self.tagsArray[indexPath.item%self.tagsArray.count];
    return cell;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        NSInteger result =0;
        switch (self.type) {
            case HomeTypeAttention:
                result = 0;
                break;
            case HomeTypeFind:
                result = 1;
            default:
                break;
        }
        return result;
    }
    else
    {
        return self.noteArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    else
    {
        NSInteger result = 0;
        switch (self.type) {
            case HomeTypeAttention:
                result = 0;
                break;
            case HomeTypeFind:
                result = CGRectGetHeight(self.collectionView.frame);
            default:
                break;
        }
        return result;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:self.collectionView.frame];
    [view addSubview:self.collectionView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeId = @"homeFindCell";
    NoteInfoView *cell;
    
    if (indexPath.section == 0) {
        cell = [[NoteInfoView alloc]initWithFrame:CGRectZero];
        [cell addSubview:self.headView];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:homeId];
        if (cell == nil)
        {
            cell = [[NoteInfoView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeId];
            cell.delegate = self;
            cell.backgroundColor = PYColor(@"eeeeee");
        }
        switch (self.type) {
            case HomeTypeFind:
            {
                cell.type = HomeCellTypeTopMiddleBottom;
            }
                break;
            case HomeTypeAttention:
            default:
            {
                cell.type = HomeCellTypeMiddleBottom;
            }
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.noteArray[indexPath.row];
    }
    return cell;
}
- (void)dealloc
{
    [PYNotificationCenter removeObserver:self];
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{//
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//     view.backgroundColor = [UIColor redColor];
//    return view;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 100;
//}
//- (UIView *)tableView:(UITableView *)tableView :(NSInteger)section
//{

//
//    return view;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
    NoteInfoModel *model = self.noteArray[indexPath.row];
    
    NoteDetailViewController *note = [[NoteDetailViewController alloc]init];
    note.noteId = model.noteId;
    note.noteUserId = model.userId;
    
    [self.navigationController pushViewController:note animated:YES];
    
     note.returnBackBlock = ^(NSString *str) {
         if([str isEqualToString:@"yes"])
         {
             model.followed = YES;
         }else
         {
             model.followed = NO;
         }
        [self.tableView reloadData];
    };
   
// HomeAttentionViewController *homeAttentionViewController=[self.childViewControllers objectAtIndex:0];
////    [self.view removeConstraints:self.view.subviews];
//    [self.view addSubview:homeAttentionViewController.view];
////    self.view = homeAttentionViewController.view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return topH;
    }
    else
    {
        NoteInfoModel *model = self.noteArray[indexPath.row];
        NSDictionary *browseCountDic = @{NSFontAttributeName: noteInfoFont};
        CGSize  descH =[model.noteDesc boundingRectWithSize:CGSizeMake(fDeviceWidth -26 *rateW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:browseCountDic context:nil].size;
            if(descH.height >51 *rateH)descH.height=51*rateH;
        CGFloat result;
        switch (self.type) {
            case HomeTypeFind:
            {
                result = 263*rateH  + 56 *rateH+12 *rateH+descH.height*rateH +12 *rateH +12*rateH +15 *rateH+36*rateH +5*rateH;
            }
                break;
            case HomeTypeAttention:
            default:
            {
                result = 263*rateH  +12 *rateH+descH.height*rateH +12 *rateH +12*rateH +15 *rateH+36*rateH +5*rateH;
            }
                break;
        }
        
        return result;
    }
}



#pragma mark - cell滚动后刷新
- (void)homeLineLayout:(HomeLineLayout *)homeLineLayout didCenterCellItem:(NSInteger)item
{
    TagModel *model = self.tagsArray[item%self.tagsArray.count];
    self.isLoadMore = NO;
    self.currentTag = model.tagName;
//    [self.tableView.footer beginRefreshing];
//    PYLog(@"擦擦擦擦车%@",model.tagName);
    if ([self.currentTag isEqualToString:@"48小时最热"]) {
        [self callingInterfaceNoteList:@"48hot"];
    }else if ([self.currentTag isEqualToString:@"最新帖子"])
    {
        [self callingInterfaceNoteList:@"newest"];
    }else
    {
        switch (self.type) {
            case HomeTypeFind:
            {
                [self callingInterfacenoteList:self.currentTag];
            }
                break;
            case HomeTypeAttention:
            {
                [self callingInterfaceNoteList];
            }
                break;
                
            default:
                break;
        }
    }
}

//滑动事件处理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSInteger top;
//    switch (self.type) {
//        case HomeTypeFind:
//        {
//            top = 0 *rateH;
//        }
//            break;
//        case HomeTypeAttention:
//        default:
//        {
//            top = 0;
//        }
//            break;
//    }

    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat offset=scrollView.contentOffset.y;
        if(offset < 0)
        {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        }
        //  PYLog(@"%f",offset);
//        scrollView.y = -offset + topH;
        CGFloat alpha=  (219 - offset)/219;
        self.navigationController.navigationBar.alpha = alpha;
        if (alpha<0.09) {
            self.navigationController.navigationBarHidden =YES;
        }else
        {
            self.navigationController.navigationBarHidden =NO;
        }
    }
    else if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        CGFloat sectionWidth = scrollView.contentSize.width/3;
        if (scrollView.contentOffset.x < sectionWidth*0.5)
        {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + sectionWidth, scrollView.contentOffset.y);
        }
        else if(scrollView.contentOffset.x > sectionWidth*1.5)
        {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - sectionWidth, scrollView.contentOffset.y);
        }
    //    NSLog(@"x:%f",scrollView.contentOffset.x);
    }
}

#pragma mark - 接口调用
// 调用精选或广告
- (void)callingInterfaceSpecialsOrAds
{

    
  // PYLog(@"%@",[CMData getCommonImagePath]);
    
        NSDictionary *param = @{@"type":@"ads"};
        [CMAPI postUrl:API_GET_SPECIALSORADS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
              id result = [detailDict objectForKey:@"result"] ;
             //PYLog(@"%@",result);
            if(succeed)
            {
              [self.images addObjectsFromArray:[AdsModel objectArrayWithKeyValuesArray:[result objectForKey:@"list"]]];
      
                self.headView.imgArray = self.images;
                [self.headView openTimer];
                [self loadEnd];
            }else
            {
                [self loadEnd];
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            
        }];
//      NSString *path = [CMData getCommonImagePath];
//      PYLog(@"%@",path);

    

}


// 调用用户首页标签
- (void)callingInterfacehomeTags
{
    [CMAPI postUrl:API_GET_HOMETAGS Param:nil Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        PYLog(@"%@",result);
        if(succeed)
        {
            
               [self.tagsArray addObject:[TagModel objectWithKeyValues:[result objectForKey:@"hottestTag"]]];
               [self.tagsArray addObjectsFromArray:[TagModel objectArrayWithKeyValuesArray:[result objectForKey:@"popularTags"]]];
              [self.tagsArray addObject:[TagModel objectWithKeyValues:[result objectForKey:@"latestTag"]]];
         
            [self.collectionView reloadData];
            [self homeLineLayout:nil didCenterCellItem:0];//为解决首次列表不刷新的问题，之后如果解决就可以删除这句代码
             [self loadEnd];
        }else
        {  [self loadEnd];
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
        
    }];
}

// 调用帖子列表接口
- (void)callingInterfacenoteList:(NSString *)tag
{
    int count = 0;
    if (!self.isLoadMore) {
        count = 0;
    }else
    {
        count = self.noteArray.count;
    }
    if([tag isEqualToString:@""]|| tag == nil )
    {
        tag = @"48hot";
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"orderRule"] = @"home";
    param[@"tagNames"] = tag;
    param[@"orderRanking"] =@(count);
    if (![[CMData getUserId] isEqualToString:@""]) {
        param[@"userId"] = @([CMData getUserIdForInt]);
    }
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;

        if(succeed)
        {
            if (!self.isLoadMore) {
                [self.noteArray removeAllObjects];
            }
       
            [self.noteArray addObjectsFromArray:[NoteInfoModel objectArrayWithKeyValuesArray:[result objectForKey:@"noteList"]]];
   
           [self.tableView reloadData];
          [self loadEnd];
        }else
        {
            [self loadEnd];
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            else
            {
                if (self.noteArray.count > 0) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
          //[SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
        
    }];
}

-(void)callingInterfaceNoteList:(NSString *)orderRule
{
    
    int count = 0;
    if (!self.isLoadMore) {
        count = 0;
    }else
    {
        count = self.noteArray.count;
    }
    NSDictionary *param = @{@"orderRule":orderRule,
                            @"userId":[CMData getUserId],
                            @"orderRanking":@(count)
                            };
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        PYLog(@"%@",detailDict);
        if(succeed)
        {
            if (!self.isLoadMore) {
                 [self.noteArray removeAllObjects];
            }
           
            [self.noteArray addObjectsFromArray:[NoteInfoModel objectArrayWithKeyValuesArray:[result objectForKey:@"noteList"]]];
           // PYLog(@"嘻嘻嘻嘻嘻嘻%@",self.noteArray);
            [self.tableView reloadData];

            [self loadEnd];
            
        }else
        {
            [self loadEnd];
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
              [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            else
            {
                if (self.noteArray.count > 0) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
        }
        [self.tableView showEmptyList:self.noteArray Image:IMG_DEFAULT_HOME_ATTENTION_NODATA Desc:IMG_DEFAULT_HOME_ATTENTION_NODATASTRING ByCSS:NoDataCSSMiddle];
        
        
    }];
}

//获取关注（用户、标签）的帖子
-(void)callingInterfaceNoteList
{
//    self.noteArray = [@[] mutableCopy];
//    [self.tableView reloadData];
//    
//    [self.tableView showEmptyList:self.noteArray Image:IMG_DEFAULT_HOME_ATTENTION_NODATA Desc:@"你还没有任何关注哦！" ByCSS:NoDataCSSMiddle];
    [self callingInterfaceNoteList:@"attention"];
}

- (void)loadMoreData
{
    self.isLoadMore = YES;
    if ([self.currentTag isEqualToString:@"48小时最热"]) {
        [self callingInterfaceNoteList:@"48hot"];
    }else if ([self.currentTag isEqualToString:@"最新帖子"])
    {
        [self callingInterfaceNoteList:@"newest"];
    }else
    {
        switch (self.type) {
            case HomeTypeFind:
            {
                [self callingInterfacenoteList:self.currentTag];
            }
                break;
            case HomeTypeAttention:
            {
                [self callingInterfaceNoteList];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
   
        // 刷新表格

        // 拿到当前的上拉刷新控件，结束刷新状态
     [self.tableView.footer endRefreshing];
  
}

#pragma mark - NoteInfoViewDelegate

- (void)CommentBtnClick:(NSString *)noteId withUserId:(NSString *)userId
{
    CommentViewController *commentVc = [[CommentViewController alloc]init];
    commentVc.noteId = noteId;
    commentVc.noteOwnerId = userId;
    [self.navigationController pushViewController:commentVc animated:YES];
    commentVc.commentCount = ^(NSString *commentCount)
    {
        if (![commentCount isEqualToString:@"0"]) {
            for (NoteInfoModel *model in self.noteArray) {
                            if([model.noteId isEqualToString:noteId])
                            {
                
                                model.comments = @([model.comments intValue ] +[commentCount intValue]);
                                [self.tableView reloadData];
                                return;
                            }
                        }
        }
    };

    
}

-(void)moreBtnClick:(NoteInfoModel *)model
{
    self.model = model;
    [self moreClick];
}

#pragma mark - AdvertistingColumnDelegate代理事件
- (void)ClickImage:(NSInteger)imageTag
{
    AdsModel *adsmodel = self.images[imageTag];
    ZhuTiVC *vc = [[ZhuTiVC alloc]init];
    vc.isAd = YES;
    SpecialsModel *model = [[SpecialsModel alloc]init];
    model.itemDesc = adsmodel.itemDesc;
    model.itemId = adsmodel.itemId;
    model.itemTitle = adsmodel.itemTitle;
    vc.specialModel = model;
    vc.navigationItem.title = model.itemTitle;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
