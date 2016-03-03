//
//  PYBaseViewController.h
//  FlashTag
//
//  Created by MingleFu on 15/10/19.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

static UIView *_loadBgView;

@interface PYBaseViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *arrayMutable;

- (void)loadGif;
- (void)loadEnd;

@end
