//
//  CollectionTwoCell.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/2.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTwoCell : UICollectionViewCell

//商品图片
@property(nonatomic ,strong)UIImageView *imgView;
//商品描述
@property(nonatomic ,strong)UILabel *text;
//销量
@property (nonatomic, strong) UILabel *countOfSale;


@end
