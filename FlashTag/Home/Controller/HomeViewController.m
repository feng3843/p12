//
//  HomeViewController.m
//  FlashTag
//
//  Created by py on 15/9/11.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeFindViewController.h"
#import "UIImage+Extensions.h"
#import "PYAllCommon.h"
#import "CameraViewController.h"
#import "UIView+Extension.h"
#import "MarkFilterViewController.h"
#import "UIView+AutoLayout.h"

@interface HomeViewController ()<CameraDelagate>
@property(nonatomic,weak)UIView *line;
@property(nonatomic,weak)UIButton *selectBtn;
@end

@implementation HomeViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *navBgImage = [UIImage resizedImage:@"bg_home_nav.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:navBgImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    UIButton *findBtn = [[UIButton alloc]initWithFrame:CGRectMake(4 *rateW, 14*rateH, 32*rateW, 16 *rateH)];
    findBtn.titleLabel.font = PYSysFont(16);
    [findBtn setTitleColor:PYColor(@"e3e3e3") forState:UIControlStateNormal];
    [findBtn setTitleColor:PYColor(@"ffffff") forState:UIControlStateSelected];
    [findBtn setTitle:@"发现" forState:UIControlStateNormal];
    findBtn.tag = 1;
    findBtn.selected = YES;
    self.selectBtn = findBtn;
    [findBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    UIButton *attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(52*rateW, 14*rateH, 32*rateW, 16 *rateH)];
    attentionBtn.titleLabel.font = PYSysFont(16);
    attentionBtn.tag = 2;
    [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [attentionBtn setTitleColor:PYColor(@"e3e3e3") forState:UIControlStateNormal];
    [attentionBtn setTitleColor:PYColor(@"ffffff") forState:UIControlStateSelected];
    [attentionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(4 *rateW, 32 *rateH, 32 *rateH, 2 *rateH)];
    line.backgroundColor = PYColor(@"ffffff");
    self.line = line;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0*rateH, 200, 44)];
    [bgView addSubview:findBtn];
    [bgView addSubview:attentionBtn];
    [bgView addSubview:line];
   // bgView.backgroundColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bgView];
    //[self.view addSubview:bgView];
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30*rateW, 30*rateW)];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_camera.png"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *photoBtnItem = [[UIBarButtonItem alloc]initWithCustomView:photoBtn];
    
    self.navigationItem.rightBarButtonItem = photoBtnItem;
    
    
    HomeFindViewController *vc = [[HomeFindViewController alloc]init];
    vc.type = HomeTypeFind;
    [self addChildViewController:vc];
    HomeFindViewController *vc2 = [[HomeFindViewController alloc]init];
    vc2.type = HomeTypeAttention;
    [self addChildViewController:vc2];
    [self.view  addSubview:vc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
/** 发帖子*/
- (void)photo
{
    if ([[CMData getToken] isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:DEFAULT_NO_LOGIN];
        return;
    }
    CameraViewController *vc = [[CameraViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.delagate = self;
    vc.isFrist = YES;
    vc.type = CutTypeDefault;
    vc.ratio = 1.0f;
    [self presentViewController:nav
                       animated:YES completion:nil];
}

-(void)afterCut:(UIImage *)image ByViewController:(UIViewController*)viewC
{
    
}

- (void)btnClick:(UIButton *)btn
{
    self.selectBtn.selected = NO;
    self.selectBtn.userInteractionEnabled = YES;
    self.selectBtn = btn;
    self.selectBtn.userInteractionEnabled = NO;
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *vc = (UIViewController *) self.childViewControllers[btn.tag - 1];
    [UIView animateWithDuration:0.25 animations:^{
        if (btn.tag == 1) {
            self.line.x = 4 *rateW;
        }else
        {
            self.line.x = 52*rateW;
        }
        [self.view addSubview:vc.view];
    }];
    btn.selected = YES;
}
@end
