//
//  FolderOperationViewController.m
//  FlashTag
//
//  Created by py on 15/9/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//   文件夹操作

#import "FolderOperationViewController.h"
#import "RemindTableViewCell.h"
#import "FolderOperateModel.h"
#import "FolderOperationTwoViewController.h"
#import "MJExtension.h"
@interface FolderOperationViewController ()<UITableViewDataSource,UITableViewDelegate,FolderOperationTwoViewControllerDelegate>
@property(nonatomic , strong)UITableView *reminderTableView;
@property(nonatomic , strong)UIButton *reminderBg;
@property(nonatomic,strong)UILabel *headLable;
@property(nonatomic ,strong)NSMutableArray *payList;
@property(nonatomic ,strong)NSMutableArray *sysList;
@property(nonatomic ,strong)NSMutableArray *customList;
@property(nonatomic ,strong)NSMutableArray *freeList;
@property(nonatomic ,strong)NSMutableArray *resultList;
@property(nonatomic ,strong)FolderOperationTwoViewController *folderOperationTwoView;
@end

@implementation FolderOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    self.freeRemain = @"0";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setReminderTableViewAction];
    
    [self callingInterFaceGetFoldersOrshelves];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setReminderTableViewAction
{
    UIButton *reminderBg = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight)];
    reminderBg.backgroundColor = PYColor(@"000000");
    reminderBg.alpha = 0.6;
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
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
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
    
//    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addButton.frame = CGRectMake(kCalculateV(21), CGRectGetMaxY(divideLine2.frame) , kCalculateV(120), kCalculateH(54));
//    [addButton setImage:[UIImage imageNamed:@"ic_folder_addnew"] forState:UIControlStateNormal];
//    [addButton setTitle:@"新建文件夹" forState:UIControlStateNormal];
//    [addButton setTitleColor:PYColor(@"222222") forState:UIControlStateNormal];
//    addButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//    addButton.imageView.contentMode = UIViewContentModeLeft;
//    addButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kCalculateV(9));
//    [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:addButton];
    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addButton.frame) + kCalculateH(10), CGRectGetMaxY(divideLine2.frame), 120, kCalculateV(49))];
//    label2.text = @"新建文件夹";
//    [view addSubview:label2];
    
    
}

- (NSMutableArray *)payList
{
    if (_payList == nil) {
        _payList = [NSMutableArray array];
    }
    return _payList;
}
- (NSMutableArray *)sysList
{
    if (_sysList == nil) {
        _sysList = [NSMutableArray array];
    }
    return _sysList;
}
- (NSMutableArray *)customList
{
    if (_customList == nil) {
        _customList = [NSMutableArray array];
    }
    return _customList;
}
- (NSMutableArray *)freeList
{
    if (_freeList== nil) {
        _freeList = [NSMutableArray array];
    }
    return _freeList;
}

- (NSMutableArray *)resultList
{
    if (_resultList == nil) {
        _resultList = [NSMutableArray array];
    }
    return _resultList;
}

- (void)addAction
{
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSInteger count = 0;
//    if (self.freeList.count >0) {
//        count ++;
//    }
//    if (self.payList.count >0) {
//        count ++ ;
//    }
//    if (self.sysList.count >0) {
//        count ++;
//    }
//    count = count + self.customList.count;
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"reminder";
    RemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[RemindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    FolderOperateModel *model = self.resultList[indexPath.row];
    if ([model.placeType isEqualToString:@"sys"]) {
        cell.leftImage.image = [UIImage imageNamed:@"img_default_freeimg_default_freeimg_default_free"];
        cell.label.text = @"默认文件夹";
    }
    if([model.placeType isEqualToString:@"pay"])
    {
        cell.leftImage.image = [UIImage imageNamed:@"img_default_buy"];
        cell.label.text = [NSString stringWithFormat:@"收费货位(闲置%d个)",self.payList.count];
        
    }
    if([model.placeType isEqualToString:@"free"])
    {
        cell.leftImage.image = [UIImage imageNamed:@"img_default_free"];
        cell.label.text = [NSString stringWithFormat:@"免费货位(闲置%@个)",self.freeRemain];
        
    }
    if ([model.placeType isEqualToString:@"custom"]) {
        cell.leftImage.image = [UIImage imageNamed:@"img_default_freeimg_default_freeimg_default_free"];
        cell.label.text = model.placeName;
    }
    
    if (indexPath.row == (self.resultList.count - 1)) {
        cell.divideLine.hidden = YES;
    }else
    {
        cell.divideLine.hidden = NO;
    }
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FolderOperateModel *model = self.resultList[indexPath.row];
    if ([model.placeType isEqualToString:@"pay"]) {
        FolderOperationTwoViewController *FolderOperationView =  [[FolderOperationTwoViewController alloc]init];
        FolderOperationView.view.frame = CGRectMake(0, 0, fDeviceWidth,fDeviceHeight);
        [self addChildViewController:FolderOperationView];
        FolderOperationView.headtitle = @"放置到收费货位";
        FolderOperationView.endtitle = @"购买新的货位";
        FolderOperationView.resultList = self.payList;
        FolderOperationView.delegate = self;
        _folderOperationTwoView = FolderOperationView;
        [self.view addSubview:FolderOperationView.view];
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [window addSubview:FolderOperationView.view];
//        [window bringSubviewToFront:FolderOperationView.view];
    }
//    else if ([model.placeType isEqualToString:@"free"]) {
//        FolderOperationTwoViewController *FolderOperationView =  [[FolderOperationTwoViewController alloc]init];
//        FolderOperationView.view.frame = CGRectMake(0, 0, fDeviceWidth,fDeviceHeight);
//        [self addChildViewController:FolderOperationView];
//        FolderOperationView.headtitle = @"放置到免费货位";
//        FolderOperationView.endtitle = @"兑换新的货位";
//        FolderOperationView.resultList = self.freeList;
//        FolderOperationView.delegate = self;
//        _folderOperationTwoView = FolderOperationView;
//         [self.view addSubview:FolderOperationView.view];
////        UIWindow *window = [UIApplication sharedApplication].keyWindow;
////        [window addSubview:FolderOperationView.view];
////        [window bringSubviewToFront:FolderOperationView.view];
//    }
    else
    {
        // 发通知
        [PYNotificationCenter postNotificationName:DEFAULT_NOTEPLACE_NOTIFICATION object:nil userInfo:@{DEFAULT_NOTEPLACEID:model.placeId,DEFAULT_NOTEPLACENAME:model.placeName,DEFAULT_NOTEPLACTYPE:model.placeType}];
//        [self bgBtnClick];
        if ([self.delegate respondsToSelector:@selector(selectFolder:)]) {
            [self.delegate selectFolder:model];
        }
    }

}

#pragma mark -代理事件
- (void)bgBtnClick
{
    if ([self.delegate respondsToSelector:@selector(bgBtnClick)]) {
        [self.delegate bgBtnClick];
    }
}
#pragma mark - 调用接口
- (void)callingInterFaceGetFoldersOrshelves
{
    NSDictionary *param = @{@"userId":@([CMData getUserIdForInt])};
    
    [CMAPI postUrl:API_GET_ALLFILELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        if (succeed) {
            
           [self.sysList removeAllObjects];
           [self.payList removeAllObjects];
           [self.customList removeAllObjects];
           [self.freeList removeAllObjects];
           [self.resultList removeAllObjects];
//
//            [self.sysList ]
            PYLog(@"文件夹列表______________________%@" , detailDict);
//            [self.sysList ]
           [self.sysList addObjectsFromArray:[FolderOperateModel objectArrayWithKeyValuesArray:[result objectForKey:@"sysList"]]];
           [self.payList addObjectsFromArray:[FolderOperateModel objectArrayWithKeyValuesArray:[result objectForKey:@"payList"]]];
           [self.customList addObjectsFromArray:[FolderOperateModel objectArrayWithKeyValuesArray:[result objectForKey:@"customList"]]];
            [self.freeList addObjectsFromArray:[FolderOperateModel objectArrayWithKeyValuesArray:[result objectForKey:@"freeList"]]];
            PYLog(@"%@",self.sysList);
            PYLog(@"%@",self.payList);
            PYLog(@"%@",self.customList);
            PYLog(@"%@",self.freeList);
            self.freeRemain = [result objectForKey:@"freeRemain"];
            if (!self.freeRemain||[@"" isEqualToString:self.freeRemain])
            {
                self.freeRemain = @"0";
            }
            if (self.foType == FolderOperationTypeAll || self.foType == FolderOperationTypeForSale) {
                if ([self.freeRemain intValue]>0&&self.freeList.count >0) {
                    [self.resultList addObject:self.freeList[0]];
                }
                if (self.payList.count > 0) {
                    [self.resultList addObject:self.payList[0]];
                }
            }
            if (self.foType == FolderOperationTypeAll || self.foType == FolderOperationTypeNormal) {
                if (self.sysList.count > 0) {
                    [self.resultList addObject:self.sysList[0]];
                }
                if (self.customList.count >0) {
                    [self.resultList addObjectsFromArray:self.customList];
                }
            }
            [self.reminderTableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

- (void)FolderOperationTwoBgBtnClick
{
    [self.folderOperationTwoView.view removeFromSuperview];
    self.folderOperationTwoView = nil;
}
@end
