//
//  TradeView.h
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  兑换页面

#import <UIKit/UIKit.h>

@interface TradeView : UIView

@property(nonatomic , strong)UIImageView *imageView;
@property(nonatomic , strong)UILabel *scoreLabel;
@property(nonatomic , strong)UILabel *tradeHistoryLabel;
@property(nonatomic , strong)UIButton *tradeButton;

//显示兑换历史纪录
@property(nonatomic , strong)UITableView *tableView;

@property(nonatomic, strong)NSString *score;

@end
