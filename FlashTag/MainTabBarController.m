//
//  MainTabBarController.m
//  FlashTag
//
//  Created by uncommon on 2015/10/09.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import "MainTabBarController.h"
#import "MessageNavViewController.h"
#import "CDCommon.h"
#import "CDSessionManager.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *tabBarMain;


@property(nonatomic , strong)UILabel *label;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize tabBarSize=_tabBarMain.frame.size;
    UIImage *image=[UIImage imageNamed:@"bg_tab"];
    image=[image stretchableImageWithLeftCapWidth:floorf(tabBarSize.width) topCapHeight:floorf(tabBarSize.height)];
    [_tabBarMain setBackgroundImage:image];
    
    
    //////////////////////////////
    self.delegate = self;
    
    [self network];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChatBadge) name:NOTIFICATION_SESSION_UPDATED object:nil];//未读聊天消息条数更新
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = self.selectedIndex;
    
    switch (index) {
        case 0:
            ;
            break;
        case 1:
            ;
            break;
        case 2:
            ;
            break;
        case 3:
            NSLog(@"11111111111111");
            
            [self.label removeFromSuperview];
            //viewController.tabBarItem.badgeValue = nil;
            
            break;
        case 4:
            ;
            break;
        default:
            break;
    }
}



- (void)network
{
    NSDictionary *messageContentDic = @{@"userId":@([CMData getUserIdForInt])};
    [CMAPI postUrl:@"app/newMessage" Param:messageContentDic Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        PYLog(@"*********************************************获取userId的消息个数的result数据是: %@",result);
        if (succeed) {
            //添加新的粉丝个数
            //新的点赞
            //新的评论
            int count = [self changeMessageWithStr:result[@"newFansNum"]] + [self changeMessageWithStr:result[@"newPraiseNum"]] + [self changeMessageWithStr:result[@"newCommentNum"]];
            
            if (count) {
                
                [self addRedReminder];
                
//                NSLog(@"%@" , self.viewControllers);
//                
//                for (UIViewController *temp in self.viewControllers) {
//                    
//                    if ([temp isKindOfClass:[MessageNavViewController class]]) {
//                        
////                        temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d" , count];//🔴
//                        
//                        temp.tabBarItem.badgeValue = @"";
//                    }
//                }

            }else{
                [self.label removeFromSuperview];
            }
            
        } else {
            
        }
    }];

}



- (int)changeMessageWithStr:(NSString *)str
{
    if ([str isEqualToString:@""] || [str isEqualToString:@"null"] || [str isKindOfClass:[NSNull class]]) {
        
        NSLog(@"jjjjjj");
        return 0;
    }else{
        return [str intValue];
    }
}


- (void)addRedReminder
{
    float hhh = [UIScreen mainScreen].bounds.size.width/5*3.5;

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(hhh + kCalculateH(5), 11, 10, 10)];
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = 5;
    self.label.backgroundColor = [UIColor redColor];
    
    [self.tabBar addSubview:self.label];
}

- (int64_t)updateChatBadge
{
    //计算未读消息条数
    int64_t unReadMsgNum = 0;
    NSArray* chatRooms = [[CDSessionManager sharedInstance] chatRooms];
    for (NSDictionary* chatRoom in chatRooms) {
        NSString *otherid = [chatRoom objectForKey:@"otherid"];
        CMContact* contact = [CMData queryContactById:otherid];
        NSString* unreadnum = [[CDSessionManager sharedInstance] getMessageNumForPeerId:contact.strContactID ReadTime:[NSString stringWithFormat:@"%lld",contact.readMsgTimestamp+1]];
        unReadMsgNum += [unreadnum intValue];
    }
    if (unReadMsgNum > 0) {
        [self addRedReminder];
    }
    else
    {
        [self.label removeFromSuperview];
    }
    return unReadMsgNum;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
