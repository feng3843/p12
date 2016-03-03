//
//  MyAttentionView.h
//  FlashTag
//
//  Created by MyOS on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  我的关注页面

#import <UIKit/UIKit.h>

@interface MyAttentionView : UIView

@property(nonatomic , strong)UIButton *userButton;
@property(nonatomic , strong)UIButton *tagButton;

@property(nonatomic , strong)UITableView *tableView;
@property(nonatomic , strong)UICollectionView *collectionView;

@end
