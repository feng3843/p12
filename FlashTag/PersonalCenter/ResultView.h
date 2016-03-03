//
//  ResultView.h
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  成果页面

#import <UIKit/UIKit.h>
#import "MyResultModel.h"
#import "ScoreRuleModel.h"

@interface ResultView : UIView

@property(nonatomic , strong)UIScrollView *rootScrollView;

@property(nonatomic , strong)UIImageView *userHradImageView;
@property(nonatomic , strong)UILabel *tagLabel;
@property(nonatomic , strong)UILabel *hotLabel;
@property(nonatomic , strong)UILabel *remindLabel;
@property(nonatomic , strong)UILabel *nowScoreLabel;
@property(nonatomic , strong)UILabel *historyScoreLabel;
@property(nonatomic , strong)UIButton *tradeButton;
@property(nonatomic , strong)UILabel *scoreRuleLabel;
@property(nonatomic , strong)UILabel *scoreUserLabel;
@property(nonatomic , strong)UILabel *scoreCalculateLabel;
@property(nonatomic, strong)UILabel *scoreAddLabel;

@property(nonatomic, strong)MyResultModel *myResultModel;
@property(nonatomic, strong)NSArray *scoreRuleModelArr;

@end
