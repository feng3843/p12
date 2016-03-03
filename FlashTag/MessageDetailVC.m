//
//  MessageDetailVC.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "MessageDetailVC.h"
#import "AttentionUserTableViewCell.h"
#import "FansCell.h"
#import "PingLunCell.h"
#import "ChatCell.h"
#import "TimeIntervalTool.h"
#import "NoteDetailViewController.h"
#import "NSString+Extensions.h"

#import "NewFansTableViewCell.h"
#import "TapGestureWithData.h"

@interface MessageDetailVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *fansArray;
@property (nonatomic, strong) UIView *noView;
@property (nonatomic, strong) UILabel *noCountLabel;


@property(nonatomic , copy)NSString *userIdTag;

@end

@implementation MessageDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.noView = [[UIView alloc] initWithFrame:self.view.bounds];
    _noView.backgroundColor = [UIColor whiteColor];
    self.noCountLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, kCalculateV(20), fDeviceWidth, 40)];
    _noCountLabel.textAlignment=NSTextAlignmentCenter;
    _noCountLabel.textColor=PYColor(@"a8a8a8");
    _noCountLabel.font = [UIFont systemFontOfSize:13];
    _noCountLabel.text = @"目前没有更多粉丝啦!";
    [self.view addSubview:_noView];
    [_noView addSubview:_noCountLabel];
    _noView.hidden=YES;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //假设本用户的id为4:
    self.userId = [CMData getUserId];
    self.token = [CMData getToken];
    [self getFirstNetWrok];
}

- (void)getFirstNetWrok {
    //根据页面请求数据
    //新的粉丝页面
    if (self.myName == 0) {
        NSDictionary *param = @{@"userId":_userId, @"token":_token, @"count":@(50), @"orderRanking":@(0)};
        [CMAPI postUrl:API_CHECK_NEWFOLLOWEDS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
            id result = [detailDict objectForKey:@"result"] ;
            PYLog(@"*********************************************新的粉丝的result数据是: %@",result);
            if (succeed) {
                NSArray *dataArr = result[@"list"];
                if (dataArr.count<1) {
                    _noView.hidden=NO;
                } else {
                    _noView.hidden=YES;
                }
                for (NSDictionary *dic in dataArr) {
                    NewFansModel *fansModel = [[NewFansModel alloc] initWithDictionary:dic];
                    [self.dataArr addObject:fansModel];
                    [self.tableView reloadData];
                }
            } else {
                //                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
                _noView.hidden = NO;
            }
        }];
        //新的赞页面数据请求
    } else if (self.myName == 1) {
        NSDictionary *param = @{@"userId":_userId, @"token":_token, @"count":@(50), @"orderRanking":@(0)};
        [CMAPI postUrl:API_CHECK_NEWLIKE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
            id result = [detailDict objectForKey:@"result"] ;
            PYLog(@"*********************************************新的赞的result数据是: %@",result);
            if (succeed) {
                _noView.hidden=YES;
                
                NSArray *dataArr = result[@"list"];
                for (NSDictionary *dic in dataArr) {
                    NewZanModel *zanModel = [[NewZanModel alloc] initWithDictionary:dic];
                    [self.dataArr addObject:zanModel];
                    [self.tableView reloadData];
                }
                
            } else {
                _noCountLabel.text = @"目前没有更多赞啦!";
                _noView.hidden=NO;
                //                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
            }
        }];
        //新的评论页面数据请求
    } else if (self.myName == 2) {
        
        NSDictionary *param = @{@"userId":_userId, @"token":_token, @"count":@(50), @"orderRanking":@(0)};
        [CMAPI postUrl:API_CHECK_NEWCOMMENT Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
            id result = [detailDict objectForKey:@"result"] ;
            PYLog(@"*********************************************新的评论的result数据是: %@",result);
            if (succeed) {
                _noView.hidden=YES;
                NSArray *dataArr = result[@"list"];
                for (NSDictionary *dic in dataArr) {
                    NewCommentModel *commentModel = [[NewCommentModel alloc] initWithDictionary:dic];
                    [self.dataArr addObject:commentModel];
                    [self.tableView reloadData];
                }
                
            } else {
                _noCountLabel.text=@"目前没有更多评论啦!";
                _noView.hidden=NO;
                //                [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
            }
        }];
        
        
        //聊天页面数据请求
    } else {
    }
}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myName == 0) { //新的粉丝页面
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
        NewFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[NewFansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NewFansModel *model;
        model = self.dataArr[indexPath.row];
        //配置cell上显示的信息
        cell.userName.text = model.userDisplayName;
        cell.infoLabel.text = [NSString stringWithFormat:@"帖子数%@个, 粉丝数%@个", model.noteCount, model.followeds];
        NSString *path = [CMData getCommonImagePath];//path/userIcon/icon7.jpg;
        NSString *userImageStr = [NSString stringWithFormat:@"%@/userIcon/icon%@.jpg", path, model.userId];
        
        [cell.userHeardImage sd_setImageWithURL:[NSURL URLWithString:userImageStr] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
        
        //跳转到个人中心:
        TapGestureWithData *tapGes = [[TapGestureWithData alloc] initWithTarget:self action:@selector(userHeaderTapGesWithRol:)];
        tapGes.userId = model.userId;
        tapGes.role = model.role;
        tapGes.isFriend = model.isFriend;
        tapGes.model = model;
        cell.userHeardImage.userInteractionEnabled=YES;
        [cell.userHeardImage addGestureRecognizer:tapGes];
        
        
        //判断是不是好友
        if ([model.isFriend isEqualToString:@"yes"]) {
            
            cell.attentionButton.selected = YES;
            cell.attentionButton.backgroundColor = PYColor(@"cccccc");
        }else{
            
            cell.attentionButton.selected = NO;
            cell.attentionButton.backgroundColor = PYColor(@"ee5748");
        }
        
        
        [cell.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else if (self.myName == 1) {//新的赞页面
        
        FansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fansCell"];
        if (cell == nil) {
            cell = [[FansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fansCell"];
        }
        NewZanModel *model;
        model = self.dataArr[indexPath.row];
        //配置cell上显示的信息
        cell.userName.text = model.nikeName;//用户名
        cell.infoLabel.text = [TimeIntervalTool getTimeInterVal:[NSString stringWithFormat:@"%@", model.time]];//赞的时间
        NSString *path = [CMData getCommonImagePath];
        NSString *userImageStr = [NSString stringWithFormat:@"%@/userIcon/icon%@.jpg", path, model.userId];
        [cell.userHeardImage sd_setImageWithURL:[NSURL URLWithString:userImageStr] placeholderImage:[UIImage imageNamed:@"img_default_user"]];//用户头像
        
        //跳转到个人中心:
        TapGestureWithData *tapGes = [[TapGestureWithData alloc] initWithTarget:self action:@selector(userHeaderTapGesWithRol:)];
        tapGes.userId = model.userId;
        tapGes.role = model.role;
        cell.userHeardImage.userInteractionEnabled=YES;
        [cell.userHeardImage addGestureRecognizer:tapGes];
        
        NSString *tieZiImageStr = [NSString stringWithFormat:@"%@/%@/note%@_1.jpg", path, [[CMData getUserId] get2Subs], model.noteId];
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:tieZiImageStr] placeholderImage:[UIImage imageNamed:@"img_default_notelist"]];//帖子图片
        
        //跳转到帖子详情:
        TapGestureWithData *noteTapGes = [[TapGestureWithData alloc] initWithTarget:self action:@selector(noteImageTapGesWithNote:)];
        noteTapGes.userId = model.userId;
        noteTapGes.noteId = model.noteId;
        cell.leftImageView.userInteractionEnabled=YES;
        [cell.leftImageView addGestureRecognizer:noteTapGes];
        
        return cell;
        
    } else if (self.myName == 2) {//新的评论页面
        PingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PingLunCell"];
        if (cell == nil) {
            cell = [[PingLunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PingLunCell"];
        }
        NewCommentModel *model;
        model = self.dataArr[indexPath.row];
        cell.userName.text = model.userDisplayName;
        CGRect rect =  [cell.userName.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kCalculateV(14)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
        CGFloat width = 0;
        if (rect.size.width > 150 *rateW) {
            width = 150 *rateW;
        }else
        {
            width = rect.size.width;
        }
        cell.userName.frame = CGRectMake(kCalculateV(64), kCalculateV(16), width, kCalculateV(14));
        cell.pingLunLabel.frame = CGRectMake(CGRectGetMaxX(cell.userName.frame)+9, CGRectGetMinY(cell.userName.frame), kCalculateH(50), kCalculateV(14));
        cell.infoLabel.text = [[HandyWay shareHandyWay]getTimeWithStr:model.commentTime];
        cell.infoLabel.frame = CGRectMake(CGRectGetMinX(cell.userName.frame), CGRectGetMaxY(cell.userName.frame)+5, CGRectGetWidth(cell.userName.frame)+100, 11);
        cell.contentLabel.text = model.content;
        NSString *path = [CMData getCommonImagePath];
        NSString *userImageStr = [NSString stringWithFormat:@"%@/userIcon/icon%@.jpg", path, model.commentUserId];
        [cell.userHeardImage sd_setImageWithURL:[NSURL URLWithString:userImageStr] placeholderImage:[UIImage imageNamed:@"img_default_user"]];//用户头像
        
        //跳转到个人中心:
        TapGestureWithData *tapGes = [[TapGestureWithData alloc] initWithTarget:self action:@selector(userHeaderTapGesWithRol:)];
        tapGes.userId = model.commentUserId;
        tapGes.role = model.role;
        cell.userHeardImage.userInteractionEnabled=YES;
        [cell.userHeardImage addGestureRecognizer:tapGes];
        
        NSString *userID = [model.noteOwnerId get2Subs];
        NSString *tieZiImageStr = [NSString stringWithFormat:@"%@/%@/note%@_1.jpg", path, userID, model.noteId];
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:tieZiImageStr] placeholderImage:[UIImage imageNamed:@"img_default_notelist"]];//帖子图片
        
        //跳转到帖子详情:
        TapGestureWithData *noteTapGes = [[TapGestureWithData alloc] initWithTarget:self action:@selector(noteImageTapGesWithNote:)];
        noteTapGes.userId = model.targetUserId;
        noteTapGes.noteId = model.noteId;
        cell.leftImageView.userInteractionEnabled=YES;
        [cell.leftImageView addGestureRecognizer:noteTapGes];
        
        return cell;
        
        
    } else {                    //聊天页面
        ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
        if (cell == nil) {
            cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
        }
        cell.userHeardImage.image = [UIImage imageNamed:@"Thome"];
        cell.userName.text = self.dataArr[indexPath.row];
        cell.infoLabel.text = @"帖子25个, 粉丝35个";
        cell.timeLabel.text = @"19:00";
        return cell;
    }
    
}

#pragma mark 跳转到个人中心
- (void)userHeaderTapGesWithRol:(TapGestureWithData *)sender {
    if ([sender.role isEqualToString:@"2"]) {
        VisitSellerViewController *vc = [VisitSellerViewController new];
        vc.userId=sender.userId;
        [self.navigationController pushViewController:vc animated:YES];
        vc.returnBackBlock = ^(NSString *str) {
            sender.isFriend = str;
            sender.model.isFriend = str;
            [self.tableView reloadData];
        };
    } else if ([sender.role isEqualToString:@"0"]){
        VisitBuyerViewController *vc = [VisitBuyerViewController new];
        vc.userId=sender.userId;
        [self.navigationController pushViewController:vc animated:YES];
        vc.returnBackBlock = ^(NSString *str) {
            sender.isFriend = str;
            sender.model.isFriend = str;
            [self.tableView reloadData];
        };
    }
}
#pragma mark 跳转到帖子详情
- (void)noteImageTapGesWithNote:(TapGestureWithData *)sender {
    NoteDetailViewController *noteDetailVC = [[NoteDetailViewController alloc] init];
    noteDetailVC.noteId = sender.noteId;
    noteDetailVC.noteUserId = sender.userId;
    [self.navigationController pushViewController:noteDetailVC animated:YES];
    noteDetailVC.returnBackBlock = ^(NSString *str) {
    };
}

#pragma mark 修改是否关注的按钮
- (void)attentionButtonAction:(UIButton *)sender
{
    
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%d" , indexPath.row);
    NewFansModel *model = self.dataArr[indexPath.row];
    self.userIdTag = model.userId;
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        sender.backgroundColor = PYColor(@"cccccc");
    }else{
        sender.backgroundColor = PYColor(@"ee5748");
    }
    
    [self networkForInterfaceAttention:sender.selected];
    
}

- (void)networkForInterfaceAttention:(BOOL)pIsAttention
{
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"attention":(pIsAttention? @"yes":@"no"),
                            @"attentionType":@(2),
                            @"attentionObject":self.userIdTag
                            };
    
    [CommonInterface callingInterfaceAttention:param succeed:^{}];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myName == 2) {
        return kCalculateV(93);
    } else {
        return kCalculateH(60);
    }
}

@end
