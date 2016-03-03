//
//  TradeView.m
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  兑换页面

#import "TradeView.h"

@implementation TradeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(110), kCalculateV(20), fDeviceWidth - kCalculateH(220), fDeviceWidth - kCalculateH(220))];
    self.imageView.image = [UIImage imageNamed:@"ic_free"];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = kCalculateH(10);
    [self addSubview:self.imageView];
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.imageView.frame), CGRectGetMaxY(self.imageView.frame) + kCalculateV(16), CGRectGetWidth(self.imageView.frame), kCalculateV(16))];
//    self.scoreLabel.text = @"4500积分";
    self.scoreLabel.font = [UIFont systemFontOfSize:kCalculateH(15)];
    self.scoreLabel.textColor = PYColor(@"222222");
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.scoreLabel];
    
    UIView *divideLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(169), fDeviceWidth, kCalculateV(0.5))];
    divideLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:divideLine];
    
    self.tradeHistoryLabel = [[UILabel alloc] initWithFrame:CGRectMake((fDeviceWidth - 200)/2, CGRectGetMaxY(divideLine.frame) + kCalculateV(20), 200, kCalculateV(16))];
    self.tradeHistoryLabel.text = @"兑换历史纪录";
    self.tradeHistoryLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(15)];
    self.tradeHistoryLabel.textColor = PYColor(@"222222");
    self.tradeHistoryLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tradeHistoryLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(divideLine.frame) + kCalculateV(50.5), fDeviceWidth, kQPHeight - 64 - kCalculateV(50) - CGRectGetMaxY(divideLine.frame) - kCalculateV(50.5))];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tableView];
    
    self.tradeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.tradeButton.frame = CGRectMake(0, kQPHeight - kCalculateV(50) - 64, fDeviceWidth, kCalculateV(50));
    [self.tradeButton setTitle:@"兑换" forState:UIControlStateNormal];
    [self.tradeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.tradeButton setBackgroundColor:[UIColor lightGrayColor]];
    self.tradeButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(18)];
    [self addSubview:self.tradeButton];
    
}

#pragma mark-

-(void)setScore:(NSString *)score{
    self.scoreLabel.text = [NSString stringWithFormat:@"%@积分", score];
}

#pragma mark-


@end
