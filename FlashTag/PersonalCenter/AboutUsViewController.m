//
//  AboutUsViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  关于我们

#import "AboutUsViewController.h"
#import "AboutUsView.h"
#import "UserAdviceViewController.h"

@interface AboutUsViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic , strong)AboutUsView *aboutUsView;

@property(nonatomic , strong)UIWebView *phoneCallWebView;

@end

@implementation AboutUsViewController

- (void)loadView
{
    [super loadView];
    self.aboutUsView = [[AboutUsView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.aboutUsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于买咩";
    
    self.aboutUsView.imageView.image = [UIImage imageNamed:@"iTunesArtwork"];
    self.aboutUsView.versionsLabel.text = [CMData getVersion];
    self.aboutUsView.bottomLabel.text = @"Copyright © 2015 买咩信息科技（常州）有限公司";
    
    self.aboutUsView.tableView.delegate = self;
    self.aboutUsView.tableView.dataSource = self;
    
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCalculateV(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"abuoutUs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"版本更新";
        
        cell.detailTextLabel.text = @"已经是最新版本";
        //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, 0, 30, 20)];
        //        label.text = @"NEW";
        //        label.font = [UIFont boldSystemFontOfSize:12];
        //        label.textColor = [UIColor whiteColor];
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.backgroundColor = [UIColor redColor];
        //        label.layer.cornerRadius = 8;
        //        label.layer.masksToBounds = YES;
        //        [cell.detailTextLabel addSubview:label];
        
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
        cell.detailTextLabel.textColor = PYColor(@"999999");
        
    }else if (indexPath.row == 1){
        
        cell.textLabel.text = @"意见与反馈";
    }else{
        
        cell.textLabel.text = @"联系客服";
        cell.detailTextLabel.text = @"400-800-8800";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
        cell.detailTextLabel.textColor = PYColor(@"999999");
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    cell.textLabel.textColor = PYColor(@"222222");
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[UserAdviceViewController new] animated:YES];
    }else if (indexPath.row == 2){
        
        [self CallPhone];
    }
    
    
    
    
}



-(void)CallPhone{
    NSString *phoneNum = @"4008008800";
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !_phoneCallWebView ) {
        _phoneCallWebView = [[UIWebView alloc]init];
    }
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    [self.view addSubview:_phoneCallWebView];
}


@end
