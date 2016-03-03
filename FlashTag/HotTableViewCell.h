//
//  HotTableViewCell.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/5.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotTagView.h"

@interface HotTableViewCell : UITableViewCell
@property (nonatomic, strong) HotTagView *firstView;
@property (nonatomic, strong) HotTagView *secondView;
@property (nonatomic, strong) HotTagView *thirdView;
@property (nonatomic, strong) HotTagView *fourthView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
