//
//  AdvertistingColumn.m
//  NewCut
//
//  Created by py on 15-7-16.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import "AdvertistingColumn.h"
#import "PYAllCommon.h"
#import "AdsModel.h"
#import "SDImageView+SDWebCache.h"

@implementation AdvertistingColumn

-(id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.frame), 219 * rateH)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;//设置代理UIscrollViewDelegate
        _scrollView.showsVerticalScrollIndicator = NO;//是否显示竖向滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;//是否显示横向滚动条
        _scrollView.contentSize = CGSizeMake(219 *rateH * 3, 0);
        _scrollView.pagingEnabled = YES;//是否设置分页
        
        [self addSubview:_scrollView];
        
        /*
         ***容器，装载
         */
//        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, CGRectGetWidth(self.frame), 20)];
//        containerView.backgroundColor = [UIColor clearColor];
//        [self addSubview:containerView];
//        UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame))];
//        alphaView.backgroundColor = [UIColor clearColor];
//        alphaView.alpha = 0.7;
//        [containerView addSubview:alphaView];
        
        //分页控制
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 196 *rateH, fDeviceWidth, 10  *rateH)];
        _pageControl.numberOfPages = 3;
        _pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//貌似不起作用呢
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _pageControl.currentPage = 0; //初始页码为0
        //_pageControl.backgroundColor  = [UIColor blackColor];
  
        [self addSubview:_pageControl];
        //图片张数
//        _imageNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(containerView.frame)-20, 20)];
//        _imageNum.font = [UIFont boldSystemFontOfSize:15];
//        _imageNum.backgroundColor = [UIColor clearColor];
//        _imageNum.textColor = [UIColor whiteColor];
//        _imageNum.textAlignment = NSTextAlignmentRight;
        //[containerView addSubview:_imageNum];
        /*
         ***配置定时器，自动滚动广告栏
         */
        timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer setFireDate:[NSDate distantFuture]];//关闭定时器
    }
    return self;

}

-(void)timerAction:(NSTimer *)tr{
    if (_totalNum>1) {
        CGPoint newOffset = _scrollView.contentOffset;
        newOffset.x = newOffset.x + CGRectGetWidth(_scrollView.frame);
        //    NSLog(@"newOffset.x = %f",newOffset.x);
        if (newOffset.x > (CGRectGetWidth(_scrollView.frame) * (_totalNum-1))) {
            newOffset.x = 0 ;
        }
        int index = newOffset.x / CGRectGetWidth(_scrollView.frame);   //当前是第几个视图
        newOffset.x = index * CGRectGetWidth(_scrollView.frame);
        _imageNum.text = [NSString stringWithFormat:@"%d / %ld",index+1,(long)_totalNum];
        [_scrollView setContentOffset:newOffset animated:YES];
    }else{
        [tr setFireDate:[NSDate distantFuture]];//关闭定时器
    }
}


#pragma mark- PageControl绑定ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//滚动就执行（会很多次）
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        
    }else {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;   //当前是第几个视图
        _pageControl.currentPage = index;
        for (UIView *view in scrollView.subviews) {
            if(view.tag == index){
                
            }else{
                
            }
        }
    }
    //    NSLog(@"string%f",scrollView.contentOffset.x);
}

- (void)setImgArray:(NSMutableArray *)imgArray
{
    if (_imgArray == nil) {
        _imgArray = imgArray;
        _totalNum = [imgArray count];
        if (_totalNum>0) {
            for (int i = 0; i<_totalNum; i++) {
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame),0, CGRectGetWidth(_scrollView.frame), 219 *rateH)];
                //img.contentMode = UIViewContentModeScaleAspectFill;
                AdsModel *model = imgArray[i];
                NSString *str = [[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"ads/ads%@.jpg",model.itemId]];
                
                [img showImage:str DefaultImage:IMG_DEFAULT_HOME_AD_NOIMAGE];
                //            img.backgroundColor = imgArray[i];
                img.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adsClick:)];
                [img addGestureRecognizer:tap];
                [img setTag:i];
                [_scrollView addSubview:img];
                //            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), 219 *rateH)];
                
                //
                //            UIImage *image = [UIImage imageWithContentsOfFile:str];
                //            [btn setBackgroundImage:image forState:UIControlStateNormal];
                //            btn.tag = i;
                //              [_scrollView addSubview:btn];
            }
            //        _imageNum.text = [NSString stringWithFormat:@"%ld / %ld",_pageControl.currentPage+1,(long)_totalNum];
            _pageControl.numberOfPages = _totalNum; //设置页数 //滚动范围 600=300*2，分2页
            CGRect frame;
            frame = _pageControl.frame;
            frame.size.width = 15*_totalNum;
            // _pageControl.frame = frame;
        }else{
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
            [img setImage:[UIImage imageNamed:@"comment_gray"]];
            img.userInteractionEnabled = YES;
            [_scrollView addSubview:img];
            _imageNum.text = @"提示：滚动栏无数据。";
        }
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*_totalNum,0);//滚动范围 600=300*2，分2页
        
    }
 
}


- (void)openTimer{
    //开启定时器
    [timer performSelector:@selector(setFireDate:) withObject:[NSDate distantPast] afterDelay:3.0];
}

- (void)closeTimer{
    [timer setFireDate:[NSDate distantFuture]];//关闭定时器
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)adsClick:(UITapGestureRecognizer *)gestureRecognizer
{
    
    if ([self.delegate respondsToSelector:@selector(ClickImage:)]) {
        [self.delegate ClickImage:gestureRecognizer.view.tag];
    }
    
   
   
    
    
}
@end
