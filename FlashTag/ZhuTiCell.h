//
//  ZhuTiCell.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuTiCell : UICollectionViewCell


@property (nonatomic, strong) UIImageView *pic;//图片
@property (nonatomic, strong) UILabel *nameLa;//主题名
@property (nonatomic, strong) UILabel *deta;//描述


@property(nonatomic , assign)float height;
@property(nonatomic , strong)UIView *userView;


@end
