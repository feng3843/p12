//
//  HandyWay.h
//  FlashTag
//
//  Created by MyOS on 15/8/31.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  单例

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <BaiduMapAPI/BMapKit.h>

@interface HandyWay : NSObject<BMKLocationServiceDelegate , BMKGeoCodeSearchDelegate>

@property(nonatomic , assign)NSInteger mayChangeHead;
@property(nonatomic , copy)NSString *headUrl;

/** 定位*/
@property(nonatomic,strong) BMKLocationService* locService;
@property(nonatomic ,strong) CLLocation* location;


+ (HandyWay *)shareHandyWay;


//提取invitationCode
- (NSString *)getInvitationCode;


//时间戳
//过期
- (BOOL)judgeDueWithTime:(NSString *)str;

//剩余时间
- (NSString *)judgeResidueWith:(NSString *)str;

//时间戳转字符串
- (NSString *)getTimeWithStr:(NSString *)str;
//时间戳转字符串
- (NSString *)getTimeWithStr2:(NSString *)str;
//时间戳转字符串
- (NSString *)getTimeWithStrForSecond:(NSString *)str;

//处理用户id为两位数
- (NSString *)changeUserId:(NSString *)str;

//点赞
- (void)postLikesWithButton:(PostLikesButton *)button Array:(NSMutableArray *)array tag:(NSInteger)tag;

//设置游客身份
- (void)setUserInfoWithNotLogin;

//验证号码规范
- (BOOL)isValidateEmail:(NSString *)email;
- (BOOL)isValidatePhoneNumber:(NSString *)mobileNum;

- (BOOL)isValidateID:(NSString *)str;

//设置用户信息
- (void)setUserInfoWithDic:(NSDictionary *)dic;

//上传位置
- (void)postSite;

//帖子详情
- (void)pushToNoteDetailWithController:(UIViewController *)vc NoteId:(NSString *)noteId UserId:(NSString *)userId;

//每日地理信息
- (void)postSiteEveryday;

@end
