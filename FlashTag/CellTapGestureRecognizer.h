//
//  CellTapGestureRecognizer.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/24.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCell.h"

@interface CellTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) CollectionViewCell *collectionCell;

@end
