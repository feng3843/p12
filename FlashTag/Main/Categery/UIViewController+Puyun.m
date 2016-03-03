//
//  UIViewController+Puyun.m
//  StartPage
//
//  Created by andy on 14/10/26.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import "UIViewController+Puyun.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extensions.h"
#import "CMData.h"
#import "CMAPI.h"
//#import "LKBadgeView.h"
#import "AppDelegate.h"
#import "CMTool.h"
#import <ShareSDK/ShareSDK.h>
//#import "LoginRegisterTabBarViewController.h"

@implementation UIViewController (Puyun)
- (void)initialNavigationContorllor
{
    NSArray* array = self.navigationController.childViewControllers;
    if (array.count > 1) {
        [self createBackButtonWithTitle:self.title];
    }
    else
    {
        self.navigationItem.title = self.title;
    }
}
- (void)setCustomTitle:(NSString *)title
{
    [self setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width*2/5, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:19];
        // titleView.textColor = [UIColor colorWithHexString:@"898e91"];
        titleView.textAlignment = NSTextAlignmentCenter;
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}
- (void)createCloseButton
{
    //创建关闭按钮，替代默认返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0.0, 0.0, 23.0, 23.0);
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)createBackButton{
    //创建返回按钮，替代默认返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:IMG_BTN_BACK_NORMAIL] forState:UIControlStateNormal];
    button.frame=CGRectMake(0.0, 0.0, 11.5, 20.0);
    [button addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationBar.backgroundColor=[UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)createBackButtonWithBarItem:(NSString*)title
{
    if (!title)
    {
        title = @"返回";
    }
    //创建返回按钮，替代默认返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:IMG_BTN_BACK_NORMAIL] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn-return"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"btn-return"] forState:UIControlStateSelected];
    button.frame=CGRectMake(0.0, 0.0, 87.0, 27.0);
    [button addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)createBackButtonWithTitle:(NSString*)title
{
    if (!title)
    {
        title = @"返回";
    }
    //创建返回按钮，替代默认返回按钮
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"ic_chevron_left_white_48dp"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ic_chevron_left_white_48dp"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"ic_chevron_left_white_48dp"] forState:UIControlStateSelected];
    button.frame=CGRectMake(0.0, -10.0, 44.0, 44.0);
    [button addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backView addSubview:button];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"line-2"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"line-2"] forState:UIControlStateHighlighted];
    [button2 setImage:[UIImage imageNamed:@"line-2"] forState:UIControlStateSelected];
    button2.frame=CGRectMake(24.0, 0.0, 200.0, 24.0);
    [button2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backView addSubview:button2];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.title = @"";
}

- (void)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)goback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) createOrgListButton:(BOOL)isShowRedPoint
{
    //创建组织列表按钮
    UIView* view = [[UIView alloc] init];
    UIView* inview = [[UIView alloc] init];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView* image = [[UIImageView alloc] init];
    UIImageView* imageRedPoint = [[UIImageView alloc] init];
//    NSString* logo = nil;//[CMData getOrglogo];
    
    //[CMTool setImage:image FileName:logo ImageCate:@"orgjoined" ImageUrl:CMRES_ORG_LOGO_PATH];

    image.frame=CGRectMake(0.0, 0.0, 30.0, 30.0);
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame=CGRectMake(0.0, 0.0, 30.0, 30.0);
    button.layer.cornerRadius = 15.0;
    [button addTarget:self action:@selector(listOrg:) forControlEvents:UIControlEventTouchUpInside];
    view.frame=CGRectMake(0.0, 0.0, 30.0, 30.0);
    inview.frame=CGRectMake(0.0, 0.0, 30.0, 30.0);
    if (isShowRedPoint) {
        [imageRedPoint setImage:[UIImage imageNamed:@"redpoint"]];
        imageRedPoint.frame = CGRectMake(22.0, -2, 8, 8);
    }
    [inview addSubview:image];
    [inview addSubview:button];

    inview.layer.cornerRadius = 15;
    inview.clipsToBounds = YES;

    [view addSubview:inview];
    [view addSubview:imageRedPoint];

    [view bringSubviewToFront:imageRedPoint];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)listOrg:(id)sender{
//    DDLogVerbose(@"listOrg");
}

- (void)gotoRoot{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)shareImage:(id)sender Model:(NoteInfoModel*)model InController:(id<UIAlertViewDelegate>)delagate
{
    
    UIImageView* imageV = [UIImageView new];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_1.jpg",[model.userId get2Subs],model.noteId]]] placeholderImage:[UIImage imageNamed:@"Thome.png"] completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //1、构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:model.noteDesc
                                           defaultContent:@""
                                                    image:[ShareSDK imageWithData:UIImageJPEGRepresentation(img, 1) fileName:@"" mimeType:@"png"]
                                                    title:model.noteDesc
                                                      url:model.noteId
                                              description:@""
                                                mediaType:SSPublishContentMediaTypeNews];
        //1+创建弹出菜单容器（iPad必要）
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo,
                                                                          //ShareTypeQQ,
                                                                          nil]];
        
        if(![[CMData getUserId] isEqualToString:model.userId])
        {
            id<ISSShareActionSheetItem> item = [ShareSDK shareActionSheetItemWithTitle:@"举报" icon:[UIImage imageNamed:@"ic_home_share_reportnote"] clickHandler:^{
                
                //自定义item被点击的处理逻辑
            //    NSLog(@"=== 自定义item被点击 ===");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你确定要举报该帖子吗？"
                                                                    message:nil
                                                                   delegate:delagate
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"是的",nil];
                [alertView show];
            }];
            [activePlatforms insertObject:item atIndex:0];
        }

        //2、弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:activePlatforms
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    //可以根据回调提示用户。
                                    if (state == SSResponseStateSuccess)
                                    {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                        message:nil
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil, nil];
                                        [alert show];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                        message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil, nil];
                                        [alert show];
                                    }
                                }];
    }];
}
//判断是否登录
- (void)noLogin
{
//    LoginRegisterTabBarViewController *loginVc  = [[LoginRegisterTabBarViewController alloc]init];
//    [self.navigationController pushViewController:loginVc animated:YES];
}

@end

@implementation UIScrollView (Puyun)

@end

@implementation UITableViewController (Puyun)

- (void)setCustomTitle:(NSString *)title
{
    [self setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width*2/5, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:19];
        // titleView.textColor = [UIColor colorWithHexString:@"898e91"];
        titleView.textAlignment = NSTextAlignmentCenter;
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)createBackButton{
    //创建返回按钮，替代默认返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"btn-return"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0.0, 0.0, 23.0, 23.0);
    [button addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)goback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoRoot
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
