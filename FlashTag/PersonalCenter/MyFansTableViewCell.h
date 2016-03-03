//
//  MyFansTableViewCell.h
//  FlashTag
//
//  Created by MyOS on 15/9/22.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowedUserModel.h"
#import "JingXuanUserModel.h"

@interface MyFansTableViewCell : UITableViewCell

@property(nonatomic , strong)UIImageView *userHeardImage;
@property(nonatomic , strong)UILabel *userName;
@property(nonatomic , strong)UILabel *infoLabel;
@property(nonatomic , strong)UIButton *attentionButton;

@property(nonatomic, strong)FollowedUserModel *myFansModel;

@property(nonatomic , strong)JingXuanUserModel *jingXuanUserModel;

@end
