//
//  PYBaseViewController.m
//  FlashTag
//
//  Created by MingleFu on 15/10/19.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import "PYBaseViewController.h"
#import "UIView+AutoLayout.h"

@implementation PYBaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadGif];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(loadEnd) withObject:self afterDelay:0.7];
}

- (UIView *)loadBgView
{
    if (_loadBgView == nil) {
        
        UIView *loadBgView = [[UIView alloc]initWithFrame:self.view.frame];
        loadBgView.backgroundColor= [UIColor clearColor];
        _loadBgView.userInteractionEnabled = NO;
        _loadBgView = loadBgView;
        
        CGFloat showTime = 0.4;
        CGFloat moveTime = 0.4;
        UIView* loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        
        [CMTool moveAnimationInSuperView:loadingView ShowTime:showTime MoveTime:moveTime];
        loadingView.userInteractionEnabled = NO;
        [loadBgView addSubview:loadingView];
        
        [loadingView autoCenterInSuperview];
        [loadingView autoSetDimensionsToSize:CGSizeMake(80, 80)];
        
        loadingView.clipsToBounds = YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:loadBgView];
        //放到最顶层;
        [window bringSubviewToFront:loadBgView];
    }
    return _loadBgView;
}

#pragma mark - 加载动画
- (void)loadGif
{
    self.loadBgView.hidden = NO;
}

- (void)loadEnd
{
    self.loadBgView.hidden = YES;
}

@end
