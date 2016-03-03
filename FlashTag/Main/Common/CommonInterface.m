//
//  CommonInterface.m
//  FlashTag
//
//  Created by py on 15/9/20.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  调用公共接口的方法

#import "CommonInterface.h"
#import "CMDefault.h"
@implementation CommonInterface

/** 调用点赞和取消点赞接口*/
+(void)callingInterfacePraise:(NSDictionary *)param succeed:(void (^)())succeeIsLike
{
    
    if ([[CMData getToken] isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:DEFAULT_NO_LOGIN];
        return;
    }
    [CMAPI postUrl:API_USER_PRAISE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        // PYLog(@"%@",result);
        if(succeed)
        {
            succeeIsLike();
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
        
    }];
}
/** 调用发表评论接口*/
+(void)callingInterfacePostComment:(NSDictionary *)param succeed:(void (^)())succeeComment
{
    if ([[CMData getToken] isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:DEFAULT_NO_LOGIN];
        return;
    }
    [CMAPI postUrl:API_USER_POSTCOMMENT Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        if(succeed)
        {
            succeeComment();
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
        
    }];
}

+(void)callingInterfaceAttention:(NSDictionary *)param succeed:(void (^)())succeeAttention
{
    if ([[CMData getToken] isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:DEFAULT_NO_LOGIN];
        return;
    }
    [CMAPI postUrl:API_USER_ATTENTION Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        if(succeed)
        {
            succeeAttention();
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
        
    }];
}

+(void)callingInterfaceCollectNote:(NSDictionary *)param succeed:(void (^)())succeeCollect
{
    if ([[CMData getToken] isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:DEFAULT_NO_LOGIN];
        return;
    }
    [CMAPI postUrl:API_USER_COLLECTNOTE Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        if(succeed)
        {
            succeeCollect();
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
        
    }];
}


#pragma mark - demo
- (void)callingInterfaceTest
{

    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"noteId":@(6),
                            @"targetId":@(4),
                            @"isLiked":@"no"};
    [CommonInterface callingInterfacePraise:param succeed:^{
        

        [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
    }];
}
- (void)callingInterfaceCommentTest
{
    
  
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"commentContent":@"评论嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻",
                            @"noteOwnerId":@(4),
                            @"noteId":@(6),
                            @"targetUserId":@(4)
                            };
    [CommonInterface callingInterfacePostComment:param succeed:^{
        
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
    }];
}
- (void)callingInterfaceAttentionTest
{

    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"attention":@"yes",
                            @"attentionType":@(2),
                            @"attentionObject":@(4)
                            };
    
    [CommonInterface callingInterfaceAttention:param succeed:^{
        
        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
    }];
}
- (void)callingInterfaceCollectTest
{
   
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"noteId":@(6),
                            @"targetId":@(4),
                            @"type":@"collect"
                            };
    
    [CommonInterface callingInterfaceCollectNote:param succeed:^{
        
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    }];
}
@end
