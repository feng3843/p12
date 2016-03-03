//
//  SetViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  设置

#import "SetViewController.h"
#import "SetView.h"
#import "CommentHistoryViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "CDSessionManager.h"

@interface SetViewController ()<UITableViewDelegate , UITableViewDataSource , UIAlertViewDelegate>

@property(nonatomic , strong)SetView *setView;
@property(nonatomic , assign)int count;

@end

@implementation SetViewController

- (void)loadView
{
    [super loadView];
    self.setView = [[SetView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.setView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    self.count = 0;
    
    self.setView.tableView.delegate = self;
    self.setView.tableView.dataSource = self;
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
}


- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCalculateV(15);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCalculateV(44);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"setCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    if (indexPath.section == 0) {
    
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的邀请码";
            cell.detailTextLabel.text = [[HandyWay shareHandyWay] getInvitationCode];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
            cell.detailTextLabel.textColor = PYColor(@"f24949");
        }else{
            cell.textLabel.text = @"我评论过的";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"关于买咩";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"last"];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    

    if (indexPath.section == 0) {
        
        if (self.count < 2) {
            self.count++;
            
            if (indexPath.row == 0) {
                UIView *devideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, 0.5)];
                devideView.backgroundColor = PYColor(@"cccccc");
                [cell addSubview:devideView];
            }else{
                UIView *devideView = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(44) - 0.5, fDeviceWidth, 0.5)];
                devideView.backgroundColor = PYColor(@"cccccc");
                [cell addSubview:devideView];
                
            }

        }
        
        
    } else{
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = PYColor(@"cccccc").CGColor;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    cell.textLabel.textColor = PYColor(@"222222");
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:[CommentHistoryViewController new] animated:YES];
        }else{
            
        }
    }else if (indexPath.section == 1){
        [self.navigationController pushViewController:[AboutUsViewController new] animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self networkingRequestForLoginOut];
    }
}

#pragma mark - network
//退出登录
- (void)networkingRequestForLoginOut
{
    NSDictionary *param = @{@"token":[CMData getToken],@"userId":@([CMData getUserIdForInt])};
    NSLog(@"%@" , param);
    
    [CMAPI postUrl:API_USER_LOGOUT Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            NSLog(@"退出成功!%@" , detailDict);
            
            [[HandyWay shareHandyWay] setUserInfoWithNotLogin];
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
            [ShareSDK cancelAuthWithType:ShareTypeQQ];
            [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
            
            //聊天清除session
            [CDSessionManager clearSession];
            
            LoginViewController *vc = [LoginViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:NO completion:nil];
        
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];

}

@end
