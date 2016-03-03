//
//  HotTagView.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/5.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTagView : UIView

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *tagLabel;

- (instancetype)initWithFrame:(CGRect)frame;
@end
