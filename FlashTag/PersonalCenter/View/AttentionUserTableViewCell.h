//
//  AttentionUserTableViewCell.h
//  11111111111111111111
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 MyOS. All rights reserved.
//  关注和粉丝页面自定义cell

#import <UIKit/UIKit.h>
#import "FollowedUserModel.h"

@interface AttentionUserTableViewCell : UITableViewCell


@property(nonatomic , strong)UIImageView *userHeardImage;
@property(nonatomic , strong)UILabel *userName;
@property(nonatomic , strong)UILabel *infoLabel;
@property(nonatomic , strong)UIButton *attentionButton;

@property(nonatomic, strong)FollowedUserModel *followedsModel;

@end
