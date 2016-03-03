//
//  MyAttentionCollectionViewCell.h
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  我的关注标签页面自定义cell

#import <UIKit/UIKit.h>
#import "FollowedTagsModel.h"

@interface MyAttentionCollectionViewCell : UICollectionViewCell{
    UIImageView *backGroundImageView;
}


@property(nonatomic , strong)UILabel *taglabel;

@property(nonatomic, strong)FollowedTagsModel *followedTagsModel;

@end
