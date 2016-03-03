//
//  MyAttentionView.m
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  我的关注页面

#import "MyAttentionView.h"

@implementation MyAttentionView

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
    CGFloat buttonWidth = 80;
    CGFloat buttonHeight = kCalculateV(36);
    CGFloat qp = [UIScreen mainScreen].bounds.size.width;
    
    
    self.userButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.userButton.frame = CGRectMake((qp - 2 * buttonWidth)/2, 0, buttonWidth, buttonHeight);
    [self.userButton setTitle:@"用户" forState:UIControlStateNormal];
    [self.userButton setTitleColor:PYColor(@"3385cb") forState:UIControlStateNormal];
    self.userButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    
    self.tagButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.tagButton.frame = CGRectMake(CGRectGetMaxX(self.userButton.frame), 0, buttonWidth, buttonHeight);
    [self.tagButton setTitle:@"标签" forState:UIControlStateNormal];
    [self.tagButton setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    self.tagButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    
    [self addSubview:self.userButton];
    [self addSubview:self.tagButton];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(35.5), fDeviceWidth, kCalculateV(0.5))];
    view1.backgroundColor = PYColor(@"cccccc");
    [self addSubview:view1];
    
    
    [self setTableView];
    [self setCollectionView];
    
}

- (void)setTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userButton.frame), self.bounds.size.width, kQPHeight - kCalculateV(36) - 64)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = PYColor(@"e7e7e7");
    
    [self addSubview:self.tableView];
}

- (void)setCollectionView
{
    //约束
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kCalculateH(65), kCalculateH(65));
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    //设置item之间的最小间距
    layout.minimumInteritemSpacing = 10;
    //设置行与行之间的最小间距
    layout.minimumLineSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userButton.frame), self.bounds.size.width, fDeviceHeight - kCalculateV(36) - 44) collectionViewLayout:layout];
    self.collectionView.backgroundColor = PYColor(@"e7e7e7");
    [self addSubview:self.collectionView];
    self.collectionView.hidden = YES;
}

@end
