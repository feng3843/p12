//
//  CelllButton.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/24.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCell.h"

@interface CelllButton : UIButton

@property (nonatomic, strong) CollectionViewCell *buttonCell;

@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString *noteId;
@end
