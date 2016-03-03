//
//  FolderCustomCollectionViewCell.h
//  FlashTag
//
//  Created by MyOS on 15/9/17.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderCustomCollectionViewCell : UICollectionViewCell


@property(nonatomic , strong)UILabel *topLabel;

@property(nonatomic , strong)UIButton *bottomButton;

@property(nonatomic , strong)UIImageView *midImageView;

//中间三张小图片
@property(nonatomic ,strong)UIImageView *midSmallImageView1;
@property(nonatomic ,strong)UIImageView *midSmallImageView2;
@property(nonatomic ,strong)UIImageView *midSmallImageView3;
@property(nonatomic ,strong)UILabel *midReminderLabel;



@end
