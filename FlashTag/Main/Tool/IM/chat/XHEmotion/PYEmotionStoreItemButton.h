//
//  PYEmotionStoreButton.h
//  CM
//
//  Created by 付晨鸣 on 15/3/30.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PYEmotionStoreItemButtonStyleDefault,
    PYEmotionStoreItemButtonStyleSingle,
    PYEmotionStoreItemButtonStyleAdd,
    PYEmotionStoreItemButtonStyleSend,
    PYEmotionStoreItemButtonStyleSetting,
    PYEmotionStoreItemButtonStyleLove
} PYEmotionStoreItemButtonStyle;

@interface PYEmotionStoreItemButton : UIButton

@property PYEmotionStoreItemButtonStyle emotionStoreItemButtonStyle;

@end
