//
//  ConfigurHotCell.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HotCell.h"

@protocol pushDelegate <NSObject>

- (void)pushViewControllerWithName:(NSString *)str;

@end

@interface ConfigurHotCell : NSObject

{
    NSMutableArray *_hotArr;
}

@property (nonatomic, retain) id<pushDelegate>delegate;


- (void)configureHotCellWithCell:(HotCell *)cell andArr:(NSMutableArray *)hotArr;

@end
