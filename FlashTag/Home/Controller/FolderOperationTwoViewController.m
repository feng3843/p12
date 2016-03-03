//
//  FolderOperationTwoViewController.m
//  FlashTag
//
//  Created by 夏雪 on 15/10/1.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//   文件夹操作2级界面

#import "FolderOperationTwoViewController.h"
#import "RemindTableViewCell.h"
#import "FolderOperateModel.h"
#import "NSDate+Extensions.h"
#import "HandyWay.h"
@interface FolderOperationTwoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic , strong)UITableView *reminderTableView;
@property(nonatomic , strong)UIButton *reminderBg;
@property(nonatomic,strong)UILabel *headLable;

@property(nonatomic ,weak)UIButton *addButton;
@end

@implementation FolderOperationTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setReminderTableViewAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)resultList
{
    if (_resultList == nil) {
        _resultList = [NSMutableArray array];
    }
    return _resultList;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.resultList.count;
}
- (void)setReminderTableViewAction
{
    UIButton *reminderBg = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight)];
//    reminderBg.backgroundColor = PYColor(@"000000");
//    reminderBg.alpha = 0.6;
    [reminderBg addTarget:self action:@selector(bgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reminderBg];
    self.reminderBg = reminderBg;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(20), (fDeviceHeight - kCalculateV(324))*1/3, kCalculateH(280), kCalculateV(324))];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = kCalculateH(16);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(kCalculateH(21), kCalculateV(20), kCalculateH(18), kCalculateH(18));
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"ic_folder_back"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(bgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame) + kCalculateH(49), 0, 120, kCalculateV(49))];
    titleLabel.text = self.headtitle;
    self.headLable = titleLabel;
    titleLabel.font = PYSysFont(17 *rateH);
    titleLabel.textColor = PYColor(@"222222");
    [view addSubview:titleLabel ];
    
    UIView *divideLine = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(16), kCalculateV(48), kCalculateH(280-32), kCalculateV(0.5))];
    divideLine.backgroundColor = PYColor(@"c3c3c3");
    [view addSubview:divideLine];
    
    
    self.reminderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kCalculateV(49), kCalculateH(280), kCalculateV(220 - 2 + 54))];
    [view addSubview:self.reminderTableView];
    //
    self.reminderTableView.bounces = NO;
    //
    self.reminderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //
    self.reminderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.reminderTableView.delegate = self;
    self.reminderTableView.dataSource = self;
    
    
//    UIView *divideLine2 = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(16), CGRectGetMaxY(self.reminderTableView.frame), kCalculateH(280-32), kCalculateV(0.5))];
//    divideLine2.backgroundColor = PYColor(@"c3c3c3");
//    [view addSubview:divideLine2];
//    
//    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addButton.frame = CGRectMake(kCalculateV(21), CGRectGetMaxY(divideLine2.frame) , kCalculateV(150), kCalculateH(54));
//    [addButton setImage:[UIImage imageNamed:@"ic_folder_addnew"] forState:UIControlStateNormal];
//    [addButton setTitle:self.endtitle forState:UIControlStateNormal];
//    [addButton setTitleColor:PYColor(@"222222") forState:UIControlStateNormal];
//    addButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//    addButton.imageView.contentMode = UIViewContentModeLeft;
//    addButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kCalculateV(9));
//    self.addButton = addButton;
////    [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:addButton];

    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"reminder";
    RemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[RemindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    FolderOperateModel *model = self.resultList[indexPath.row];
    //model.expireTime = @"2015-10-08 09:53:16";
    if ([model.placeType isEqualToString:@"pay"]) {
        cell.leftImage.image = [UIImage imageNamed:@"img_default_buy"];
//        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];
//        NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
//        NSInteger expiretime = ([model.expireTime doubleValue]/1000 - [nowTime doubleValue])/3600/24 + 1;
         cell.label.text = [NSString stringWithFormat:@"%@(剩余%@天)",model.placeName,model.leftDays];
    }
    if ([model.placeType isEqualToString:@"free"]) {
        cell.leftImage.image = [UIImage imageNamed:@"img_default_free"];
        cell.label.text = model.placeName;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     FolderOperateModel *model = self.resultList[indexPath.row];
     // 发通知
    [PYNotificationCenter postNotificationName:DEFAULT_NOTEPLACE_NOTIFICATION object:nil userInfo:@{DEFAULT_NOTEPLACEID:model.placeId,DEFAULT_NOTEPLACENAME:model.placeName,DEFAULT_NOTEPLACTYPE:model.placeType}];
    //[self bgBtnClick];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCalculateV(55);
}
- (void)setHeadtitle:(NSString *)headtitle
{
    _headtitle = headtitle;
    self.headLable.text = headtitle;
}
- (void)setEndtitle:(NSString *)endtitle
{
    _endtitle = endtitle;
   [self.addButton  setTitle:self.endtitle forState:UIControlStateNormal];
}

- (void)bgBtnClick
{
    if([self.delegate respondsToSelector:@selector(FolderOperationTwoBgBtnClick)])
    {
        [self.delegate FolderOperationTwoBgBtnClick];
    }
}
@end
