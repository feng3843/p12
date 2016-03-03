//
//  CommentHistoryViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  评论过的

#import "CommentHistoryViewController.h"
#import "CommentView.h"
#import "CommentHistoryTableViewCell.h"
#import "CommentHistoryModel.h"

@interface CommentHistoryViewController ()<UITableViewDataSource , UITableViewDelegate>

@property(nonatomic , strong)CommentView *commentView;


@property(nonatomic , strong)NSMutableArray *array;

//刷新
@property(nonatomic , assign)int page;


@property(nonatomic , strong)UIImageView *defaultImage;
@property(nonatomic , strong)UILabel *defaultLabel;

@end

@implementation CommentHistoryViewController

- (void)loadView
{
    [super loadView];
    self.commentView = [[CommentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.commentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我评论过的";
    
    self.page = 0;
    self.array = [NSMutableArray array];
    
    self.commentView.tableView.delegate = self;
    self.commentView.tableView.dataSource = self;
    
    [self networkRequest];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //刷新加载
    [self reloadDataEvent];
    
    [self defaultImageViwe];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 刷新加载
- (void)reloadDataEvent
{
    self.commentView.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        
        [self.array removeAllObjects];
        
        [self networkRequest];
        
        [self.commentView.tableView.header endRefreshing];
    }];
    
    MJRefreshAutoGifFooter* footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.page = self.page + 20;
        
        [self networkRequest];
        
        [self.commentView.tableView.footer endRefreshing];

    }];
    footer.refreshingTitleHidden = YES;
    
    NSArray* refreshingImages = [CMTool getRefreshingImages];
    
    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateIdle];
    // 设置无新数据状态的动画图片
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_LISTEND]] forState:MJRefreshStateNoMoreData];
    
    self.commentView.tableView.footer = footer;
}

- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.array.count) {

    return self.array.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"commentHistory";
    CommentHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (nil == cell) {
        cell = [[CommentHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.array.count) {
        
        CommentHistoryModel *model = self.array[indexPath.row];
        
        cell.detaillabel.text = model.content;
        cell.timeLabel.text = [[HandyWay shareHandyWay] getTimeWithStr:model.commentTime];
        [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], [[HandyWay shareHandyWay] changeUserId:model.noteOwnerId], model.noteId]] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        
        NSLog(@"%@" ,[NSString stringWithFormat:@"%@%@/note%@_1.jpg" , [CMData getCommonImagePath], [[HandyWay shareHandyWay] changeUserId:model.noteOwnerId], model.noteId]);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCalculateV(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.array.count > 0) {
        
        CommentHistoryModel *model = self.array[indexPath.row];
        
        [[HandyWay shareHandyWay] pushToNoteDetailWithController:self NoteId:model.noteId UserId:model.noteOwnerId];
    }

}

- (void)networkRequest
{
    NSDictionary *param = @{@"userId":@([CMData getUserIdForInt]),@"orderRanking":@(self.page),@"count":@(20)};
    [CMAPI postUrl:@"app/userAllComment" Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            [self removeDefaultImage];
            
            NSLog(@"%@" , detailDict);
            for (NSDictionary *dic in detailDict[@"result"][@"userCommentList"]) {
                CommentHistoryModel *model = [[CommentHistoryModel alloc] initWithDictionary:dic];
                [self.array addObject:model];
            }
            
            [self.commentView.tableView reloadData];
            
        }else{
            if ([[[detailDict objectForKey:@"result"] objectForKey:@"code"] isEqualToString:@"4011"]) {
                
                if (self.array.count > 0) {
                    [self.commentView.tableView.footer noticeNoMoreData];
                }else{
                    [self addImageWithName:@"img_default_me_comment" label:@"你还没有任何评论哦"];
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
                
            }

        }
        
//        [self.commentView.tableView showEmptyList:self.array Image:IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_NODATASTRING ByCSS:NoDataCSSTop];
    }];
}



#pragma mark - 默认提示图片
- (void)defaultImageViwe
{
    self.defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake((fDeviceWidth - kCalculateH(100))/2, kCalculateV(30), kCalculateH(100), kCalculateH(100))];
    
    self.defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.defaultImage.frame) + kCalculateV(20), fDeviceWidth, 30)];
    self.defaultLabel.textAlignment = NSTextAlignmentCenter;
    self.defaultLabel.font = [UIFont systemFontOfSize:15];
}

- (void)addImageWithName:(NSString *)str label:(NSString *)reminder
{
    self.defaultImage.image = [UIImage imageNamed:str];
    self.defaultLabel.text = reminder;
    
    [self.commentView.tableView addSubview:self.defaultImage];
    [self.commentView.tableView addSubview:self.defaultLabel];
}

- (void)removeDefaultImage
{
    [self.defaultImage removeFromSuperview];
    [self.defaultLabel removeFromSuperview];
}



@end
