//
//  FirstViewController.m
//  FlashTag
//
//  Created by MyOS on 15/10/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginViewController.h"

@interface FirstViewController ()<UIScrollViewDelegate>

@property (nonatomic , retain) UIScrollView *myScrollView;
@property (nonatomic , retain) UIPageControl *myPageControl;

@property(nonatomic , assign) int count;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.myScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSArray *imageNames = @[@"img_lead_1" , @"img_lead_2" ,@"img_lead_3"];
    
    self.count = imageNames.count;
    
    for (int i = 0 ; i < imageNames.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.image = [UIImage imageNamed:[imageNames objectAtIndex:i]] ;
        imageView.userInteractionEnabled = YES;
        
        
        if (i == self.count - 1) {
//            UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//            [nextBtn setFrame:CGRectMake(self.view.frame.size.width - self.view.frame.size.width * 80 / 375, self.view.frame.size.height - self.view.frame.size.height * 100 / 667, self.view.frame.size.width * 70 / 375, self.view.frame.size.height * 50 / 667)];
//            [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
//            nextBtn.backgroundColor = [UIColor redColor];
//            [nextBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
//            [imageView addSubview:nextBtn];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [imageView addGestureRecognizer:tap];
            
        }
        [self.myScrollView addSubview:imageView];
    }
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.count, self.view.frame.size.height);
    self.myScrollView.delegate = self;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.bounces = NO;
    [self.view addSubview:self.myScrollView];
    
    self.myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - self.view.frame.size.height *60 / 667.0 , self.view.frame.size.width, self.view.frame.size.height * 50 / 667.0)];
    
    self.myPageControl.numberOfPages = self.count;
    self.myPageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.myPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:self.myPageControl];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.myPageControl.currentPage = self.myScrollView.contentOffset.x / self.view.frame.size.width;
}


- (void)tapAction{
    
    LoginViewController *lockVC = [[LoginViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lockVC];
    
    [self presentViewController:nav animated:NO completion:nil];
}


- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
