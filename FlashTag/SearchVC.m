//
//  SearchVC.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/8/31.
//  Copyright (c) 2015年 Puyun. All rights reserved.
// 搜索模块

#import "SearchVC.h"
//view
#import "TableViewCell.h"
#import "HotCell.h"
#import "HotTableViewCell.h"
#import "SeaTableViewHeaderView.h"
#import "SystemTagTableViewCell.h"

#import "BiaoQianVC.h"
#import "DingWeiVC.h"
#import "ButtonView.h"
//model
#import "NoteModel.h"
#import "UserModel.h"
//tool
#import "ShortUserArrayTool.h"

#import "NSString+Extensions.h"
#import "PYAllCommon.h"
#import "CMData.h"
#import "UIImageView+WebCache.h"
#import "CommentViewController.h"

@interface SearchVC () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, pushDelegate, noteCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;//搜索页面主页面的tableview
@property (nonatomic, strong) UIButton *btn;//定位按钮
@property (nonatomic, strong) UILabel *btnLabel;//取消按钮

@property (nonatomic, strong) UICollectionView *collectionView;//搜索帖子的collection
@property (nonatomic, strong) UITableView *tableView;//搜索用户的tableview

@property (nonatomic, strong) UIView *searchView;//搜索页面背景层
@property (nonatomic, strong) ButtonView *segmentButtonView;//帖子 代购 用户 按钮
@property (nonatomic, strong) UITextField *MySearchBar;//搜索框

@property (nonatomic, strong) NSMutableArray *hotArr;//热门标签数组
@property (nonatomic, strong) NSMutableArray *sysArr;//系统标签数组
@property (nonatomic, strong) NSMutableArray *tieZiSearchArr;//搜索帖子
@property (nonatomic, strong) NSMutableArray *daiGouSearchArr;//搜索代购
@property (nonatomic, strong) NSMutableArray *userSearchArr;//搜索用户

@end

@implementation SearchVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTextField];
    [self getDataFromUrl];
    
}

- (void)configureTextField {
    self.navigationItem.titleView.frame = CGRectMake(0, 0, fDeviceWidth, 30);
    //配置搜索框
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, 64)];
    self.MySearchBar = [[UITextField alloc] initWithFrame:CGRectMake(kCalculateH(15-8), 17, kCalculateH(251), 30)];
    [_MySearchBar addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:self.MySearchBar];
    self.MySearchBar.delegate = self;
    self.MySearchBar.returnKeyType = UIReturnKeySearch;
    self.MySearchBar.placeholder = @"搜索帖子、代购、用户";
    self.MySearchBar.font = [UIFont systemFontOfSize:14];
    self.MySearchBar.textAlignment = NSTextAlignmentCenter;
    self.MySearchBar.backgroundColor = PYColor(@"e4e6e3");
    self.MySearchBar.textColor = PYColor(@"888888");
    self.MySearchBar.layer.cornerRadius = 15;
    self.MySearchBar.clearsOnBeginEditing = YES;
    self.MySearchBar.clearButtonMode = UITextFieldViewModeAlways;
    [self.navigationItem setTitleView:contentView];

    
    
    //配置定位与取消按钮
    UIImage *image1 = [UIImage imageNamed:@"ic_search_location"];
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, kCalculateH(30), kCalculateV(24));
    [_btn setImage:image1 forState:UIControlStateNormal];
    [_btn setTitle:@"定位" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(btnAciton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc] initWithCustomView:_btn];
    self.navigationItem.rightBarButtonItem = itemBtn;
}

- (void)btnAciton:(UIButton *)sender
{
    if (([sender.titleLabel.text isEqualToString:@"取消"])) {
        [_searchView removeFromSuperview];
        [_segmentButtonView removeFromSuperview];
        [self.tieZiSearchArr removeAllObjects];
        [self.userSearchArr removeAllObjects];
        self.MySearchBar.text=nil;
        [self.MySearchBar resignFirstResponder];
        [_btnLabel removeFromSuperview];
        [_btn addSubview:_btn.imageView];
        [_btn setImage:[UIImage imageNamed:@"ic_search_location"] forState:UIControlStateNormal];
        [_btn setTitle:@"定位" forState:UIControlStateNormal];
    } else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //2.先引入头文件#import "FriendListViewController.h", Identifier就是storyboard中FriendListViewController的storyboardID
        DingWeiVC *friendListVC = [storyBoard instantiateViewControllerWithIdentifier:@"friendListVC"];
        friendListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendListVC animated:YES];
    }
}


- (void)getDataFromUrl {
    NSDictionary *param = @{@"type":@"more"};
    [CMAPI postUrl:API_GET_SYSANDHOTTAGS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        PYLog(@"()()()()()()()()()()())()()()()()()()系统标签和热门标签的获取结果为:%@", result);
        if(succeed)
        {
            self.hotArr = [NSMutableArray array];
            self.sysArr = [NSMutableArray array];
            
            NSDictionary *rootDic = [[NSDictionary alloc] initWithDictionary:result];
            NSArray *sysTagsArr = rootDic[@"sysTags"]; //系统标签数组
            NSArray *hotTagsArr = rootDic[@"hottestTags"]; //热门标签数组
            
            for (NSDictionary *dataDic in hotTagsArr) {
                [self.hotArr addObject:dataDic];
            }
            for (NSDictionary *dataDic in sysTagsArr) {
                [self.sysArr addObject:dataDic];
            }
            [self.MyTableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
        
    }];
    
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return self.userSearchArr.count;
    } else {
        if (section == 0) {
            return 1;
        } else {
            return self.sysArr.count;
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
        return 1;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        return kCalculateV(60);
    } else {
        
        if (indexPath.section == 0) {
            return kCalculateV(95);
        } else {
            return kCalculateV(55);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return 0;
    } else {
        return kCalculateV(25);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag != 100) {
        SeaTableViewHeaderView *backView = [[SeaTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kCalculateV(25))];
        if (section==0) {
            backView.headerLabel.text = @"热门标签";
            return backView;
        } else {
            backView.headerLabel.text = @"系统标签";
            return backView;
        }
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return nil;
    } else {
        return @[@"热门标签", @"系统标签"][section];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //用户搜索的cell
    if (tableView.tag == 100) {
        //        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dd"];
        //        if (cell == nil) {
        TableViewCell *cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchUsers"];
        UserModel *userModel = self.userSearchArr[indexPath.row];
        cell.userName.text = (NSString *)userModel.userDisPlayName;
        cell.fans.text = [NSString stringWithFormat:@"%@个粉丝", userModel.followed];
        
        NSString *LVImageStr = [NSString stringWithFormat:@"img_search_hot_%@", userModel.levle];
        cell.lvImage.image = [UIImage imageNamed:LVImageStr];//热卖度(等级)图片
        
        NSString *path = [CMData getCommonImagePath];
        NSString *userImageStr = [NSString stringWithFormat:@"%@/userIcon/icon%@.jpg", path, userModel.userId];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:userImageStr] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
        
        
//        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , userModel.userId]] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//            
//            if (image) {
//                
//            }else{
//                image = [UIImage imageNamed:@"img_default_me_user"];
//            }
//            
//            cell.imgView.image = image;
//            
//        }];
        //        }
        return cell;
        
    } else {//搜索页面主页面
        if (indexPath.section == 0) {
            //配置热门标签
            HotTableViewCell *hottCell = [[HotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hottCell"];
            [self configureHotCell:hottCell];
            hottCell.selectionStyle = UITableViewCellSelectionStyleNone;//不能被选取
            return hottCell;
            
        } else {
            //配置系统标签
//            SystemTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];//舍弃storyboard做法
            
            SystemTagTableViewCell *cell = [[SystemTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemTagTableView"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.sysMarkImageView.layer setCornerRadius:3];
            [cell.sysMarkImageView.layer setMasksToBounds:YES];
            
            NSString *path = [CMData getCommonImagePath];
            
            NSString *strUserId = (self.sysArr[indexPath.row])[@"userId"];
            if (![strUserId isKindOfClass:[NSNull class]]) {
                NSString *user = [strUserId get2Subs];
                NSString *noteID = (self.sysArr[indexPath.row])[@"noteId"];
                NSString *noteImageUrl = [NSString stringWithFormat:@"%@%@/note%@_1.jpg", path, user, noteID]; //标签图片地址拼接
                NSURL *url = [NSURL URLWithString:noteImageUrl];
                
                [cell.sysMarkImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_default_notelist"]];
                
            }
            NSString *tagName = (NSString *)(self.sysArr[indexPath.row])[@"tagName"]; //标签名字
            cell.markLabel.text = tagName;
            
            return cell;
        }
    }
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        //搜索用户
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UserModel *model = self.userSearchArr[indexPath.row];
        
        if ([model.role isEqualToString:@"2"]) {
            VisitSellerViewController *vc = [VisitSellerViewController new];
            vc.userId=model.userId;
            [self.navigationController pushViewController:vc animated:YES];
            vc.returnBackBlock = ^(NSString *str) {
            
            };
        } else if ([model.role isEqualToString:@"0"]){
            VisitBuyerViewController *vc = [VisitBuyerViewController new];
            vc.userId=model.userId;
            [self.navigationController pushViewController:vc animated:YES];
            vc.returnBackBlock = ^(NSString *str) {
                
            };
        }
        
    } else {
        if (indexPath.section == 0) {
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSLog(@"标签cell点击");
            NSString *tempStr = (NSString *)(self.sysArr[indexPath.row])[@"tagName"];
            [self presentViewByName:tempStr];
        }
    }
}

//配置热门标签的方法
- (void)configureHotCell:(HotTableViewCell *)cell {
    if (self.hotArr.count == 4) {
        UIGestureRecognizer *firstGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstImageAction:)];
        UIGestureRecognizer *secondGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondImageAction:)];
        UIGestureRecognizer *thirdGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdImageAction:)];
        UIGestureRecognizer *fourthGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fourthImageAction:)];
        
        [cell.firstView addGestureRecognizer:firstGesture];
        cell.firstView.tagLabel.text = (self.hotArr[0])[@"tagName"];
        NSString *firstNoteId = (self.hotArr[0])[@"noteId"];
        NSString *firstUserId = (self.hotArr[0])[@"userId"];
        [self creatHotCellWithName:firstUserId andNoteId:firstNoteId onImageView:cell.firstView.backImage];
        
        
        [cell.secondView addGestureRecognizer:secondGesture];
        cell.secondView.tagLabel.text = (self.hotArr[1])[@"tagName"];
        NSString *secondNoteId = (self.hotArr[1])[@"noteId"];
        NSString *secondUserId = (self.hotArr[1])[@"userId"];
        [self creatHotCellWithName:secondUserId andNoteId:secondNoteId onImageView:cell.secondView.backImage];
        
        [cell.thirdView addGestureRecognizer:thirdGesture];
        cell.thirdView.tagLabel.text = (self.hotArr[2])[@"tagName"];
        NSString *thirdNoteId = (self.hotArr[2])[@"noteId"];
        NSString *thirdUserId = (self.hotArr[2])[@"userId"];
        [self creatHotCellWithName:thirdUserId andNoteId:thirdNoteId onImageView:cell.thirdView.backImage];
        
        
        [cell.fourthView addGestureRecognizer:fourthGesture];
        cell.fourthView.tagLabel.text = (self.hotArr[3])[@"tagName"];
        NSString *fourthNoteId = (self.hotArr[3])[@"noteId"];
        NSString *fourthUserId = (self.hotArr[3])[@"userId"];
        [self creatHotCellWithName:fourthUserId andNoteId:fourthNoteId onImageView:cell.fourthView.backImage];
    }
}

- (void)creatHotCellWithName:(NSString *)name andNoteId:(NSString *)noteId onImageView:(UIImageView *)imageView {
    NSString *path = [CMData getCommonImagePath];
    imageView.userInteractionEnabled = YES;
    NSString *userIdStr = [name get2Subs];
    NSString *fourthNoteImageUrl = [NSString stringWithFormat:@"%@%@/note%@_1.jpg", path, userIdStr, noteId]; //标签图片地址拼接
    [imageView sd_setImageWithURL:[NSURL URLWithString:fourthNoteImageUrl] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
}



//热门标签的第一张图片点击方法
- (void)firstImageAction:(UITapGestureRecognizer *)sender {
    NSLog(@"dd");
    NSString *str = (self.hotArr[0])[@"tagName"];
    [self presentViewByName:str];
}
- (void)secondImageAction:(UITapGestureRecognizer *)sender {
    NSString *str = (self.hotArr[1])[@"tagName"];
    [self presentViewByName:str];
}
- (void)thirdImageAction:(UITapGestureRecognizer *)sender {
    NSString *str = (self.hotArr[2])[@"tagName"];
    [self presentViewByName:str];
}
- (void)fourthImageAction:(UITapGestureRecognizer *)sender {
    NSString *str = (self.hotArr[3])[@"tagName"];
    [self presentViewByName:str];
}


#pragma mark ConfigurHotCellDelegate
- (void)pushViewControllerWithName:(NSString *)str {
    BiaoQianVC *biaoVC = [BiaoQianVC new];
    biaoVC.hidesBottomBarWhenPushed = YES;
    biaoVC.biaoQianName = str;
    [self.navigationController pushViewController:biaoVC animated:YES];
}


//跳转到标签控制器
- (void)presentViewByName:(NSString *)sender {
    //创建标签视图
    BiaoQianVC *biaoVC = [BiaoQianVC new];
    biaoVC.hidesBottomBarWhenPushed = YES;
    biaoVC.biaoQianName = sender;
    [self.navigationController pushViewController:biaoVC animated:YES];
}


#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
//textField开始编辑调用
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_btn.titleLabel.text isEqualToString:@"定位"]) {
        [_btn.imageView removeFromSuperview];
        _btnLabel = [[UILabel alloc] initWithFrame:_btn.bounds];
        _btnLabel.backgroundColor = [UIColor clearColor];
        _btnLabel.font=[UIFont systemFontOfSize:14];
        _btnLabel.textColor = PYColor(@"999999");
        _btnLabel.text = @"取消";
        [_btn addSubview:_btnLabel];
        [self.btn setTitle:@"取消" forState:UIControlStateNormal];
        
        //创建button
        self.segmentButtonView = [[ButtonView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, 40) andButtonArr:@[@"帖子", @"代购", @"用户"]];
        [self.segmentButtonView.btn1 addTarget:self action:@selector(btn1ActionInHome:) forControlEvents:UIControlEventTouchUpInside];
        [self.segmentButtonView.btn2 addTarget:self action:@selector(btn2ActionInHome:) forControlEvents:UIControlEventTouchUpInside];
        [self.segmentButtonView.btn3 addTarget:self action:@selector(btn3ActionInHome:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_segmentButtonView];
        
        [self creatSearchView]; //创建搜索页面背景层
        [self selectmyView1];
    }
}
//回收键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.MySearchBar isExclusiveTouch]) {
        [self.MySearchBar resignFirstResponder];
    }
}

//点击search按钮开始搜索帖子 用户 代购
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    if (self.MySearchBar.text.length>0) {
    [self changeButton:_segmentButtonView withNsstring:nil];
    //    }
    [self.MySearchBar resignFirstResponder];
    return YES;
}

- (void)btn1ActionInHome:(UIButton *)sender {
    if (_collectionView) {
        [_collectionView reloadData];
    }
    [self selectmyView1];
    if (self.MySearchBar.text.length>0) {
        NSDictionary *tempParam = @{@"order":@(0), @"orderRule":@"generalNotes", @"itemIds":self.MySearchBar.text, @"count":@(50), @"userId":[CMData getUserId]};//用户获取帖子列表
        [self getDataOfSearchViewWithPath:API_GET_NOTELIST andParam:tempParam withViewTitle:@"tiezi"];
    } else {
        [self.tieZiSearchArr removeAllObjects];
        [self.collectionView reloadData];
        [_collectionView showEmptyList:self.tieZiSearchArr Image:IMG_DEFAULT_SEARCH_NOTE_NODATA Desc:IMG_DEFAULT_SEARCH_NOTE_NODATASTRING ByCSS:NoDataCSSTop];
    }
}
- (void)btn2ActionInHome:(UIButton *)sender {
    if (_collectionView) {
        [_collectionView reloadData];
    }
    [self selectmyView2];
    if (self.MySearchBar.text.length>0) {
        NSDictionary *tempParam = @{@"order":@(0), @"orderRule":@"sellNotes", @"itemIds":self.MySearchBar.text, @"count":@(50), @"userId":[CMData getUserId]};//用户获取帖子列表
        [self getDataOfSearchViewWithPath:API_GET_NOTELIST andParam:tempParam withViewTitle:@"daigou"];
    } else {
        [self.tieZiSearchArr removeAllObjects];
        [self.collectionView reloadData];
        [_collectionView showEmptyList:self.tieZiSearchArr Image:IMG_DEFAULT_SEARCH_BUY_NODATA Desc:IMG_DEFAULT_SEARCH_BUY_NODATASTRING ByCSS:NoDataCSSTop];
    }
    
}
- (void)btn3ActionInHome:(UIButton *)sender {
    if (_tableView) {
        [_tableView reloadData];
    }
    [self selectmyView3];
    if (self.MySearchBar.text.length>0) {
        NSDictionary *tempParam = @{@"param":self.MySearchBar.text, @"count":@(50), @"orderRanking":@(0)};//搜索平台用户
        //搜索平台用户
        [self getDataOfSearchViewWithPath:API_SEARCH_USERS andParam:tempParam withViewTitle:@"yonghu"];
    } else {
        [self.userSearchArr removeAllObjects];
        [self.tableView reloadData];
        [_tableView showEmptyList:self.userSearchArr Image:IMG_DEFAULT_SEARCH_USER_NODATA Desc:IMG_DEFAULT_SEARCH_USER_NODATASTRING ByCSS:NoDataCSSTop];
    }
}


- (void)changeButton:(ButtonView *)button withNsstring:(NSString *)str {
    NSDictionary *tempParam;
    if (str == nil) {
        str = self.MySearchBar.text;
    }
    if (button.index == 0) {
        NSLog(@"0");
        tempParam = @{@"order":@(0), @"orderRule":@"generalNotes", @"itemIds":str, @"count":@(50), @"userId":[CMData getUserId]};//用户获取帖子列表
        [self selectmyView1];
        [self getDataOfSearchViewWithPath:API_GET_NOTELIST andParam:tempParam withViewTitle:@"tiezi"];
    } else if (button.index == 1) {
        tempParam = @{@"order":@(0), @"orderRule":@"sellNotes", @"count":@(50), @"itemIds":str, @"userId":[CMData getUserId]};//获取代购列表
        [self selectmyView2];
        [self getDataOfSearchViewWithPath:API_GET_NOTELIST andParam:tempParam withViewTitle:@"daigou"];
        //用户代购
    } else {
        tempParam = @{@"param":str, @"count":@(50), @"orderRanking":@(0)};//搜索平台用户
        [self selectmyView3];
        //搜索平台用户
        [self getDataOfSearchViewWithPath:API_SEARCH_USERS andParam:tempParam withViewTitle:@"yonghu"];
    }
}


//创建点击搜索框弹出view的方法
- (void)creatSearchView {
    CGRect frame = CGRectMake(0, CGRectGetMaxY(_segmentButtonView.frame), self.view.frame.size.width, self.view.frame.size.height - 40);
    self.searchView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:_searchView];
}

//当textfield改变状态时:
- (void)textFieldEditChanged:(UITextField *)textField {
    if (textField.text.length>0) {
        [self changeButton:_segmentButtonView withNsstring:textField.text];
    } else {
        [self.tieZiSearchArr removeAllObjects];
        [self.userSearchArr removeAllObjects];
        [self.collectionView reloadData];
        [self.tableView reloadData];
    }
}





#pragma mark 获取网络数据
- (void)getDataOfSearchViewWithPath:(NSString *)path andParam:(NSDictionary *)param withViewTitle:(NSString *)title {
    
    [CMAPI postUrl:path Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        PYLog(@"*********************************************搜索条件是:%@ 搜索结果是: %@",self.MySearchBar.text, result);
        NSLog(@"%@", param);
        if(succeed)
        {
            //获取帖子页面数据
            if ([title isEqualToString:@"tiezi"]) {
                self.tieZiSearchArr = [NSMutableArray array];
                NSArray *dataArr = result[@"noteList"];//
                for (NSDictionary *dic in dataArr) {
                    NoteModel *noteModel = [[NoteModel alloc] initWithDictionary:dic];
                    [self.tieZiSearchArr addObject:noteModel];
                }
                [self.collectionView reloadData];
                //获取代购页面数据
            } else if ([title isEqualToString:@"daigou"]) {
                self.tieZiSearchArr = [NSMutableArray array];
                NSArray *dataArr = result[@"noteList"];
                for (NSDictionary *dic in dataArr) {
                    NoteModel *noteModel = [[NoteModel alloc] initWithDictionary:dic];
                    [self.tieZiSearchArr addObject:noteModel];
                }
                [self.collectionView reloadData];
                //获取用户页面数据
            } else {
                self.userSearchArr = [NSMutableArray array];
                NSArray *dataArr = result[@"userList"];
                for (NSDictionary *dic in dataArr) {
                    UserModel *userModel = [[UserModel alloc] initWithDictionary:dic];
                    [self.userSearchArr addObject:userModel];
                }
                self.userSearchArr = [ShortUserArrayTool shortSearchUserArray:self.userSearchArr];
                [self.tableView reloadData];
            }
        }
        else
        {
            [self.tieZiSearchArr removeAllObjects];
            [self.userSearchArr removeAllObjects];
            [self.collectionView reloadData];
            [self.tableView reloadData];
        }
        ButtonView* button = _segmentButtonView;
        if (button.index == 0) {
            [_collectionView showEmptyList:self.tieZiSearchArr Image:IMG_DEFAULT_SEARCH_NOTE_NODATA Desc:IMG_DEFAULT_SEARCH_NOTE_NODATASTRING ByCSS:NoDataCSSTop];
        } else if (button.index == 1) {
            [_collectionView showEmptyList:self.tieZiSearchArr Image:IMG_DEFAULT_SEARCH_BUY_NODATA Desc:IMG_DEFAULT_SEARCH_BUY_NODATASTRING ByCSS:NoDataCSSTop];
            //用户代购
        } else {
            [_tableView showEmptyList:self.userSearchArr Image:IMG_DEFAULT_SEARCH_USER_NODATA Desc:IMG_DEFAULT_SEARCH_USER_NODATASTRING ByCSS:NoDataCSSTop];
        }
    }];
}



//创建帖子collection页面
- (void)selectmyView1 {
    [_searchView removeFromSuperview];
    [self creatSearchView];
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:_searchView.bounds collectionViewLayout:flowLayout];
    _collectionView.tag = 200;
    _collectionView.backgroundColor = PYColor(@"#e7e7e7");
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_searchView addSubview:_collectionView];
    //注册cell
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [_collectionView showEmptyList:self.tieZiSearchArr Image:IMG_DEFAULT_SEARCH_NOTE_NODATA Desc:IMG_DEFAULT_SEARCH_NOTE_NODATASTRING ByCSS:NoDataCSSTop];
}

//创建代购collection页面
- (void)selectmyView2 {
    [_searchView removeFromSuperview];
    [self creatSearchView];
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:_searchView.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = PYColor(@"#e7e7e7");
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_searchView addSubview:_collectionView];
    //注册cell
    [_collectionView registerClass:[CollectionTwoCell class] forCellWithReuseIdentifier:@"item2"];
    [_collectionView showEmptyList:self.tieZiSearchArr Image:IMG_DEFAULT_SEARCH_BUY_NODATA Desc:IMG_DEFAULT_SEARCH_BUY_NODATASTRING ByCSS:NoDataCSSTop];
}

//创建用户tableview页面
- (void)selectmyView3
{
    [_searchView removeFromSuperview];
    [self creatSearchView];
    
    self.tableView = [[UITableView alloc] initWithFrame:_searchView.bounds style:UITableViewStylePlain];
    [_searchView addSubview:_tableView];
    _tableView.tag = 100;
    _tableView.backgroundColor = PYColor(@"#e7e7e7");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView showEmptyList:self.userSearchArr Image:IMG_DEFAULT_SEARCH_USER_NODATA Desc:IMG_DEFAULT_SEARCH_USER_NODATASTRING ByCSS:NoDataCSSTop];
}


//collection的代理方法
#pragma mark - UICollectionViewDataSource
//设置collectionView分区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tieZiSearchArr.count;
}

//针对于每一个item返回对应的cell对象, cell重用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
        
        NoteModel *tempModel;
        tempModel = self.tieZiSearchArr[indexPath.row];
        
        cell.text.text = tempModel.noteDesc;
        
        NSString *path = [CMData getCommonImagePath];
        NSString *userID = [tempModel.userId get2Subs];
        NSString *noteID = tempModel.noteId;
        NSString *noteImageURLStr = [NSString stringWithFormat:@"%@/%@/note%@_1.jpg", path, userID, noteID];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:noteImageURLStr] placeholderImage:[UIImage imageNamed:@"img_default_notelist"]];
        
        //传值以实现评论
        cell.noteId = tempModel.noteId;
        cell.noteOwnerId = tempModel.userId;
        cell.isLike = tempModel.isLiked;
        cell.likes = [tempModel.likes intValue];
        cell.delegate = self;
        
        cell.pingLun.text = tempModel.comments;
        cell.dianZan.text = [NSString stringWithFormat:@"%d", cell.likes];
        
        ((CelllButton *)cell.contentView2).buttonCell = cell;
        [cell.contentView2 addTarget:self action:@selector(dianZanAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([cell.isLike isEqualToString:@"yes"]) {
            cell.contentView2.selected = YES;
            cell.dianZanImage.image = [UIImage imageNamed:@"ic_press_like"];
        } else {
            cell.contentView2.selected = NO;
            cell.dianZanImage.image = [UIImage imageNamed:@"ic_like"];
        }
        
        return cell;
    } else {
        CollectionTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item2" forIndexPath:indexPath];
        NoteModel *tempModel = self.tieZiSearchArr[indexPath.row];
        NSString *path = [CMData getCommonImagePath];
        NSString *userID = [tempModel.userId get2Subs];
        NSString *noteID = tempModel.noteId;
        NSString *noteImageURLStr = [NSString stringWithFormat:@"%@/%@/note%@_1.jpg", path, userID, noteID];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:noteImageURLStr] placeholderImage:[UIImage imageNamed:@"img_default_notelist"]];//帖子图片
        cell.text.text = tempModel.noteDesc;//帖子描述
        cell.countOfSale.text = [NSString stringWithFormat:@"销量:%@", tempModel.dealCount];//交易量
        return cell;
    }
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



- (void)reloadTieZi {
    NSDictionary *tempParam = @{@"order":@(0), @"orderRule":@"generalNotes", @"itemIds":self.MySearchBar.text, @"count":@(50), @"userId":[CMData getUserId]};//用户获取帖子列表
    [self getDataOfSearchViewWithPath:API_GET_NOTELIST andParam:tempParam withViewTitle:@"tiezi"];
}


- (void)paseUserId:(NSString *)userId AndNoteId:(NSString *)noteIdbyFans {
    //评论
    CommentViewController *commentVC = [CommentViewController new];
    commentVC.noteId = noteIdbyFans;
    commentVC.noteOwnerId = userId;
    [self.navigationController pushViewController:commentVC animated:YES];
    commentVC.commentCount = ^(NSString *commentCount)
    {
        if (![commentCount isEqualToString:@"0"]) {
            for (NoteModel *model in self.tieZiSearchArr) {
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
//item选中之后触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.MySearchBar resignFirstResponder];//回收键盘
    NoteModel *tempModel;
    tempModel = self.tieZiSearchArr[indexPath.row];
    NoteDetailViewController *noteDetailVC = [[NoteDetailViewController alloc] init];
    noteDetailVC.noteId = tempModel.noteId;
    noteDetailVC.noteUserId = tempModel.userId;
    noteDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noteDetailVC animated:YES];
    noteDetailVC.returnBackBlock = ^(NSString *str) {
    };
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat phoneWhite = [UIScreen mainScreen].bounds.size.width;
    //    CGFloat phoneHeight = [UIScreen mainScreen].bounds.size.height;
    return CGSizeMake(phoneWhite/2 - 15, (phoneWhite/2 - 15)*1.45);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10); //collectionView的最外层cell距离父视图(上, 左, 下, 右)的距离!
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    //    PYLog(@"ssss%@",string);
    if([CMTool stringContainsEmoji:string]) return NO;
    return YES;
}

@end
