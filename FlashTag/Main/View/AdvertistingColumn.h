//
//  AdvertistingColumn.h
//  NewCut
//
//  Created by py on 15-7-16.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AdvertistingColumnDelegate <NSObject>

@optional
- (void)ClickImage:(NSInteger)imageTag;

@end
@interface AdvertistingColumn : UIView<UIScrollViewDelegate>
{

    NSTimer *timer;
}

//广告栏
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UILabel *imageNum;
@property (nonatomic) NSInteger totalNum;
@property(nonatomic ,strong)NSMutableArray *imgArray;
@property(nonatomic,weak)id<AdvertistingColumnDelegate> delegate;
- (void)openTimer;
- (void)closeTimer;

@end
