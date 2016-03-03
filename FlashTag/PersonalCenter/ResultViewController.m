//
//  ResultViewController.m
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  成果页面

#import "ResultViewController.h"
#import "ResultView.h"
#import "MyResultModel.h"
#import "ScoreRuleModel.h"

#import "TradeViewController.h"
#import "LibCM.h"

@interface ResultViewController ()

@property(nonatomic , strong)ResultView *resultView;

@property(nonatomic , strong)NSMutableArray *array;

@end

@implementation ResultViewController

- (void)loadView
{
    [super loadView];
    self.resultView = [[ResultView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.resultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"成果";
    
    self.array = [[NSMutableArray alloc] init];

    
    /* 
     label高度是定死的，需要根据内容自适应高度，再调底部scrollView高度
     */
    
    [self.resultView.tradeButton addTarget:self action:@selector(tradeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self networkingRequest];
    [self loadScoreRule];
    
    //设置nav左侧按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
//    [self.resultView.userHradImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon/%@.jpg" , [CMData getCommonImagePath] , @"4"]] placeholderImage:[UIImage imageNamed:@"ic_head"]];
    NSString *imagePath=[LibCM getUserAvatarByUserID:[NSString stringWithFormat:@"%d",[CMData getUserIdForInt]]];
    [self.resultView.userHradImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"ic_head"]];
}


- (void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)tradeButtonAction:(UIButton *)sender
{
    //    [self.navigationController pushViewController:[TradeViewController new] animated:YES];
    
//    if (self.resultView.myResultModel.score==nil) {
    if(self.resultView.nowScoreLabel.text==nil||[self.resultView.nowScoreLabel.text isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"还未获取到您的积分，请稍后再试"];
        return;
    }
    
    TradeViewController *tradeViewController=[TradeViewController new];
//    tradeViewController.score=self.resultView.myResultModel.score;
    tradeViewController.score=self.resultView.nowScoreLabel.text;
    
    [self.navigationController pushViewController:tradeViewController animated:YES];
}

//自适应方法
- (void)adjustLabel:(UILabel *)label WithString:(NSString *)str dic:(NSDictionary *)dic
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, rect.size.height + 10);
    
//    NSString *str = [self.data valueForKey:@"content"];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, nil];
//    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.typeView.frame) + 5, self.view.frame.size.width - 20, 50)];
//    self.contentLabel.text = str;
//    self.contentLabel.numberOfLines = 0;
//    [self adjustLabel:self.contentLabel WithString:str dic:dic];
//    [self.scrollView addSubview:self.contentLabel];
}


- (void)networkingRequest
{
    //@([CMData getUserIdForInt])
    NSDictionary *param = @{@"token":[CMData getToken],@"userId":@([CMData getUserIdForInt])};
    NSLog(@"%@" , param);
    
    //
    [CMAPI postUrl:API_USER_RESULT Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            [self setUserInfoWithDctionary:detailDict[@"result"]];
//            self.resultView.myResultModel=[[MyResultModel alloc] initWithDictionary:detailDict[@"result"]];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];

}

/// 加载积分规则
-(void) loadScoreRule{
    NSDictionary *param = @{@"type":@"score"};
    
    [CMAPI postUrl:API_GET_PROTOCOL Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        if (succeed) {
            
            NSLog(@"%@" , detailDict);
            for (NSDictionary *dicItem in detailDict[@"result"][@"result"]) {
                [self.array addObject:[[ScoreRuleModel alloc] initWithDictionary:dicItem]];
            }
            
//            self.resultView.scoreRuleModelArr=scoreRuleModelArr;
            
            [self setScoreRule];
        }else{
            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}


- (void)setScoreRule
{
    NSMutableString *str = [NSMutableString string];
    NSMutableString *addStr = [NSMutableString string];
    
    for (ScoreRuleModel *model in self.array) {
        [str appendFormat:@"%@\r" , model.scoreRuleName];
        
        [addStr appendFormat:@"%@%@分\r" , [self judgeWithState:model.state] , model.score];
    }
    
    self.resultView.scoreCalculateLabel.text = str;
    CGRect sRect = self.resultView.scoreCalculateLabel.frame;
    sRect.size.height = kCalculateV(16) * (self.array.count + 1);
    self.resultView.scoreCalculateLabel.frame = sRect;
    
    self.resultView.scoreAddLabel.text = addStr;
    CGRect aRect = self.resultView.scoreAddLabel.frame;
    aRect.size.height = kCalculateV(16) * (self.array.count + 1);
    self.resultView.scoreAddLabel.frame = aRect;
    
    self.resultView.rootScrollView.contentSize = CGSizeMake(fDeviceWidth, sRect.origin.y + sRect.size.height);
}

- (NSString *)judgeWithState:(NSString *)str
{
    if ([str isEqualToString:@"-1"]) {
        return @"";
    }else{
        return @"+";
    }
}


- (void)setUserInfoWithDctionary:(NSDictionary *)dic
{
    self.resultView.tagLabel.text = [NSString stringWithFormat:@"V%@" , dic[@"level"]];;
    self.resultView.remindLabel.text = [NSString stringWithFormat:@"(您还差%@点热度就升级啦)" , dic[@"count"]];
    self.resultView.nowScoreLabel.text = [NSString stringWithFormat:@"%@" , dic[@"score"]];
    self.resultView.historyScoreLabel.text = [NSString stringWithFormat:@"%@" , dic[@"scoreTotal"]];
}


@end
