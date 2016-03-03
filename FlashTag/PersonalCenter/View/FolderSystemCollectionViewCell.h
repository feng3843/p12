//
//  FolderSystemCollectionViewCell.h
//  FlashTag
//
//  Created by MyOS on 15/9/17.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderSystemCollectionViewCell : UICollectionViewCell

@property(nonatomic , strong)UILabel *topLabel;

@property(nonatomic , strong)UIImageView *bottomImageView;


//帖子上三张小图片
@property(nonatomic ,strong)UILabel *reminderLabel;
@property(nonatomic ,strong)UIImageView *bottomSmallImageView1;
@property(nonatomic ,strong)UIImageView *bottomSmallImageView2;
@property(nonatomic ,strong)UIImageView *bottomSmallImageView3;


@end
