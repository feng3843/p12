//
//  MessageHomeVC.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "MessageHomeVC.h"
#import "MessageDetailVC.h"

#import "CYMessageTableViewCell.h"
#import "CYSystemTableViewCell.h"
#import "CYSystemContentTableViewCell.h"
#import "MJRefresh.h"
#import "TimeIntervalTool.h"

#import "CDChatListController.h"
#import "CDSessionManager.h"
#import "UILabel+Puyun.h"

@interface MessageHomeVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *cellName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *logoImageArr;
@property (nonatomic, assign) int userId;//存储用户的id
@property (nonatomic, copy) NSString *token; //用户令牌

@property (nonatomic, strong) NSMutableArray *dataArr;//接受系统通知数据的数组
@property (nonatomic, strong) NSArray *messageCountArr;//存储消息个数的数组
@property (nonatomic, strong) NSDictionary *messageCountDic;//存储消息分类字典
@property (nonatomic, assign) int orderRanking;
@end

@implementation MessageHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"消息";
    
    
    //假设本用户的id为4:
    self.logoImageArr = @[@"ic_message_fans", @"ic_message_support", @"ic_message_comment", @"ic_message_chat"];
    self.token = [CMData getToken];
    self.userId = [CMData getUserIdForInt];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.dataArr = [NSMutableArray array];
    self.messageCountArr = [NSArray array];
    [self getTheSystemNotificationFromNetWithUserId:_userId];
    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self getTheSystemNotificationFromNetWithUserId:_userId];
//        [self.tableView.header endRefreshing];
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionUpdated:) name:NOTIFICATION_SESSION_UPDATED object:nil];//未读聊天消息条数更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChatBadge) name:NOTIFICATION_SESSION_UPDATED object:nil];//未读聊天消息条数更新
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.cellName = @[@"新的粉丝", @"新的赞", @"新的评论", @"聊天"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (int64_t)updateChatBadge
{
    //计算未读消息条数
    int64_t unReadMsgNum = 0;
    NSArray* chatRooms = [[CDSessionManager sharedInstance] chatRooms];
    for (NSDictionary* chatRoom in chatRooms) {
        NSString *otherid = [chatRoom objectForKey:@"otherid"];
        CMContact* contact = [CMData queryContactById:otherid];
        
        if (!contact) {
            [self networkingRequestForSeller:otherid];
        }
        NSString* unreadnum = [[CDSessionManager sharedInstance] getMessageNumForPeerId:contact.strContactID ReadTime:[NSString stringWithFormat:@"%lld",contact.readMsgTimestamp+1]];
        unReadMsgNum += [unreadnum intValue];
    }
    return unReadMsgNum;
}


- (void)sessionUpdated:(NSNotification *)notification {
    [self reloadData];
}

-(void)reloadData
{
    [self.tableView reloadData];
}

- (void)networkingRequestForSeller:(NSString*)userId
{
    
    NSDictionary *param = @{@"targetUserId":userId,@"userId":@([CMData getUserIdForInt])};
    
    [CMAPI postUrl:API_USER_PRPFILE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed)
        {
            NSLog(@"%@" , detailDict);
            CMContact* contact = [[CMContact alloc] init];
            contact.strContactID = userId;
            contact.strName = detailDict[@"result"][@"targetDisplayName"];
            
            [CMData saveContacts:[@[contact] mutableCopy] OrgId:nil];
            [self updateChatBadge];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

- (void)getTheSystemNotificationFromNetWithUserId:(int)userId {
    //进行系统通知的数据请求
    NSDictionary *param = @{@"userId":@(_userId), @"token":_token, @"count":@(50), @"orderRanking":@(0)};
    [CMAPI postUrl:API_CHECK_SYSINFO Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        PYLog(@"*********************************************获取userId%d系统通知的result数据是: %@",_userId, result);
        if (succeed) {
            [self.dataArr removeAllObjects];
            NSArray *dataArr = result[@"list"];
            for (NSDictionary *dic in dataArr) {
                [self.dataArr addObject:dic];
            }
            [self.tableView reloadData];
        } else {
            //            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
    
    //获取消息个数
    NSDictionary *messageContentDic = @{@"userId":@(_userId)};
    [CMAPI postUrl:@"app/newMessage" Param:messageContentDic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        PYLog(@"*********************************************获取userId%d的消息个数的result数据是: %@",_userId ,result);
        if (succeed) {
            self.messageCountDic = result;
            //添加新的粉丝个数
            //新的点赞
            //新的评论
            self.messageCountArr = @[_messageCountDic[@"newFansNum"], _messageCountDic[@"newPraiseNum"], _messageCountDic[@"newCommentNum"], @"0"];
            [self.tableView reloadData];
        } else {
        }
    }];
}




#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return self.dataArr.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return kCalculateV(10);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kCalculateV(44);
    } else {
        CGFloat rowheight = 0;
        
        if (indexPath.row == 0) {
            rowheight = kCalculateV(65);
        }
        else
        {
            UILabel* contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.textColor = PYColor(@"222222");
            contentLabel.numberOfLines = 0;
            if(self.dataArr.count > 0)
            {
                contentLabel.text = self.dataArr[indexPath.row-1][@"content"];
            }
            rowheight = [contentLabel heightForCellWithContent];
            rowheight += 36;
        }
        
        return rowheight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CYMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
        if (cell == nil) {
            cell = [[CYMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemCell"];
            cell.leftLogoImageView.image = [UIImage imageNamed:_logoImageArr[indexPath.row]];
            cell.leftContentLabel.text = self.cellName[indexPath.row];
        }
        if (indexPath.row==3){
            int64_t num = [self updateChatBadge];
            if (num > 0)
            {
                cell.rightRedBackView.hidden = NO;
                cell.rightCountLabel.text = [NSString stringWithFormat:@"%lld",num];
            }
            else
            {
                cell.rightRedBackView.hidden = YES;
            }
        }else{
            if (self.messageCountArr.count) {
                if ([_messageCountArr[indexPath.row] integerValue]==0) {
                } else if ([_messageCountArr[indexPath.row] integerValue]<100) {
                    cell.rightRedBackView.hidden = NO;
                    cell.rightCountLabel.text = _messageCountArr[indexPath.row];
                } else {
                    cell.rightRedBackView.hidden = NO;
                    cell.rightCountLabel.font = [UIFont systemFontOfSize:kCalculateV(9)];
                    cell.rightCountLabel.text = @"99+";
                }
            }
        }
        return cell;
        //系统通知的cell
    } else {
        if (indexPath.row == 0) {
            CYSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemTableViewCell"];
            if (cell == nil) {
                cell = [[CYSystemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//不能被选取
            return cell;
            
        } else {
            CYSystemContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemMessageCell"];
            if (cell == nil) {
                cell = [[CYSystemContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemMessageCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//不能被选取
            if (self.dataArr.count > 0) {
                cell.timelLabel.text = (self.dataArr[indexPath.row-1])[@"leftMinutes"];
                cell.contentLabel.text = self.dataArr[indexPath.row-1][@"content"];
                CGRect frame = cell.contentLabel.frame;
                frame.size.height = [cell.contentLabel heightForCellWithContent] + 36;
                cell.contentLabel.frame = frame;
            }
            
            NSString *timeStr = [TimeIntervalTool getTimeInterValToNowWithString:cell.timelLabel.text];
            cell.timelLabel.text = timeStr;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController* pshVc=nil;
    if (indexPath.section == 0) {
        if (indexPath.row==3) {
            pshVc=(CDChatListController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"CDChatListController"];
            [pshVc setTitle:self.cellName[indexPath.row]];
            
            pshVc.hidesBottomBarWhenPushed = YES;
        }else{
            MessageDetailVC* pshmdVc;
            pshmdVc =[[MessageDetailVC alloc] init];
            pshmdVc.hidesBottomBarWhenPushed = YES;
            [pshmdVc setMyName:indexPath.row];
            [pshmdVc setTitle:self.cellName[indexPath.row]];
            pshVc = pshmdVc;
        }
    }
    [self.navigationController pushViewController:pshVc animated:YES];
}



@end
