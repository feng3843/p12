//
//  ZhuTiVC.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialsModel.h"

@interface ZhuTiVC : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SpecialsModel *specialModel;

@property BOOL isAd;

@end
