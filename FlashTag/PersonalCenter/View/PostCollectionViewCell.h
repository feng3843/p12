//
//  PostCollectionViewCell.h
//  FlashTag
//
//  Created by MyOS on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  展示货位cell

#import <UIKit/UIKit.h>
#import "PostLikesButton.h"

@interface PostCollectionViewCell : UICollectionViewCell

@property(nonatomic , strong)UIImageView *postImageView;
@property(nonatomic , strong)PostLikesButton *commentButton;
@property(nonatomic , strong)PostLikesButton *collectButton;


@end
