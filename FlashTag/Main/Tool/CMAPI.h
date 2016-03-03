//
//  CMAPI.h
//  NewCut
//
//  Created by py on 15-7-18.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CODE @"code"
#define RESULT @"result"
#define LIST @"list"
#define REASON @"reason"

extern NSString *const CMAPIBaseURL;

extern NSString *const CM_AlipayURL;//支付宝相关路径
extern NSString *const CMRES_ImageURL;//图片地址 多张
extern NSString *const CMRES_BaseURL;//图片地址 单张
extern NSString *const CMRES_AVATAR_URL;//图片地址 头像

// 用户获取照片的共有路径部分
#define API_GET_COMMONPATH @"app/getCommonPath"
/** 用户第三方登录或注册*/
#define API_USER_LOGORREG @"app/thirdparty"
// 用户获取验证码
#define API_USER_VERIFICATIONCODE     @"app/verificationCode"
// 用户注册
#define API_USER_REGISTER   @"app/register"
// 用户查询注册协议或积分规则或app介绍
#define API_GET_PROTOCOL    @"app/getProtocol"
// 退出
#define API_USER_LOGOUT @"app/logout"
// 用户的常居住地
#define API_GET_LOCALADDRESS     @"app/getLocalAddress"
// 用户登录
#define API_USER_LOGIN   @"app/login"
// 重置密码
#define API_USER_RESETPWD @"app/resetPW"
// 用户主页
#define API_USER_PRPFILE  @"app/userProfile"
// 精选或广告
#define API_GET_SPECIALSORADS  @"app/specialsOrAds"
// 手机用户首页标签
#define API_GET_HOMETAGS  @"app/homeTags"
// 用户获取帖子列表（增加使用场景）
#define API_GET_NOTELIST  @"app/noteList"
// 用户获取该用户关注的人、关注的标签、关注该用户的人。
#define API_GET_ATTENTIONS @"app/getAttentions"
// 用户发帖
#define API_POST_NOTE @"app/postNote"
// 用户获取系统标签和最热标签
#define API_GET_SYSANDHOTTAGS  @"app/getSysAndHotTags"
// 用户身份变更
#define API_USER_TURNTOSELLER @"app/turnToSeller"

// 用户查询货位的价格
#define API_USER_SHELFPRICE  @"app/shelfPrice"
// 普通卖家兑换货位
#define API_GET_SHELVESBYSCODE @"app/getshelvesByScore"
// 普通卖家购买或续费货位
#define API_GET_SHELVESBYMONEY @"app/getshelvesByMoney"
// 用户新增自定义文件夹
#define API_USER_CUSTROMFOLDER @"app/customFolder"
// 用户修改自定义文件夹名称
#define API_USER_MODIFYCUSTOMFOLDER @"app/modifyCustomFolder"
// 用户删除自定义文件夹
#define API_USER_DELCUSTOMFOLDERS @"app/delCustomFolders"
// 用户删除自己的帖子
#define API_USER_DELNOTES @"app/delNotes"
// 用户转移自己的帖子
#define API_USER_TRANSFERNOTES @"app/transferNotes"
// 用户查看帖子详情
#define API_USER_NOTEDETAIL @"app/noteDetail"
// 用户关注或取消关注
#define API_USER_ATTENTION @"app/attention"
// 用户点赞或取消点赞
#define API_USER_PRAISE @"app/praise"
// 用户帖子的浏览
#define API_USER_ADDREADCOUNT @"app/addReadCount"
// 手机用户查询评论记录
#define API_USER_GETCOMMENTLIST @"app/getCommentList"
// 用户发表评论
#define API_USER_POSTCOMMENT @"app/postComment"
// 用户收藏与取消收藏帖子
#define API_USER_COLLECTNOTE @"app/collectNote"
// 用户查询文件夹或货位
#define API_GET_FOLODERSORSHELVES @"app/getFoldersOrshelves"
// 用户同城定位
#define API_GET_ONECITY  @"app/oneCity"
// 用户查询系统所列的几个受欢迎国家
#define API_GET_POPULARCOUNTRIES @"app/getCountries"
// 用户根据国家名搜索普通卖家
#define API_GET_SELLERSBYCOUNTRY @"app/findSellersByCountry"
// 修改个人资料
#define API_USER_MODIFYInfo @"app/modifyInfo"
// 用户成果页面
#define API_USER_RESULT @"app/myResult"
// 用户代购
#define API_USER_TRADE @"app/scoreToMoney"
// 用户提交代购
#define API_USER_CONFIRM_TRADE @"app/noteApply"
// 用户全部交易记录
#define API_USER_TRADERECORDS @"app/tradeRecords"
// 用户对交易记录的相关操作
#define API_USER_ACTIONABOUNTTRADE @"app/actionAboutTrade"
// 用户反馈
#define API_USER_ADVICE @"app/advice"
// 用户查询app相关信息
#define API_GET_APPINFO @"app/appInfo"
// 用户搜索平台用户
#define API_SEARCH_USERS @"app/searchUsers"
// 获取积分兑换虚拟币的规则
#define API_GET_VIRTUALMONEY @"app/virtualMoney"
// 两个手机用户是否是好友
#define API_IS_FRIEND @"app/isFriend"
// 用户兑换历史
#define API_EXCNAGE_HISTORY @"app/exchangeHistory"
// 举报帖子
#define API_REPORT_NOTE @"app/reportNote"
// 新的粉丝
#define API_CHECK_NEWFOLLOWEDS @"app/checkNewFolloweds"
// 新的赞
#define API_CHECK_NEWLIKE @"app/checkNewLike"
// 新的评论
#define API_CHECK_NEWCOMMENT @"app/checkNewComment"
// 系统通知
#define API_CHECK_SYSINFO @"app/checkSysInfo"
// 下载最新app
#define API_DOWNLOADAPP @"app/downloadApp"
// 普通卖家购买货位前的验证
#define API_ISHAVE_SHELVES @"app/isHaveShelves"//作废接口
// 每天自动上传地理位置接口
#define API_UPLOAD_ADDRESS @"app/uploadAddress"
// 收费货位详细页面
#define API_GETPAYSHELFINFO @"app/getPayShelfInfo"
//购买收费货位第一次向服务器提交参数
#define API_BUYSHELFAPPLY @"app/buyShelfApply"
//续费收费货位第一次向服务器提交参数
#define API_continueShelfApply @"app/continueShelfApply"
// 发帖时获取用户所有可用的文件夹和货位ID
#define API_GET_ALLFILELIST   @"app/getAllFileList"
//普通卖家查询购买收费货位记录
#define API_PAYSHELFRECORD @"app/payShelfRecord"
//支付成功提交参数
#define API_PAYSUCCED @"app/mobileSuccess"
//支付失败提交参数
#define API_PAYFAIL @"app/mobileFailed"

typedef enum {
    PYResultTypeDictionary,
    PYResultTypeArray
}PYResultType;

@interface PYResult : NSObject
@property BOOL succeed;
@property NSString* code;
@property NSMutableDictionary* result;
@end

@interface PYResultSET : NSObject
@property NSString* key;//自定义的key
@property PYResultType type;//PYResultTypeDictionary:Dictionary PYResultTypeArray:Array//

- (instancetype)initWithKey:(NSString*)key Type:(PYResultType) type;
@end

@interface PyResetValueKey : NSObject

@property NSString *mynewKey;
@property NSString *oldKey;

-(instancetype)initNewkey:(NSString*)newkey OldKey:(NSString*)oldkey;

@end

#import "NoteDetailModel.h"

@interface CMAPI : NSObject

+(void)checkWeb:(void (^)())end;
+(BOOL)checkWeb;

+ (void)getUrl:(NSString*) url Param:(NSDictionary*) param Settings:settings completion:(void (^)(BOOL succeed,NSDictionary* detailDict,NSError *error))completion;
+ (void)postUrl:(NSString*) url Param:(NSDictionary*) param Settings:settings completion:(void (^)(BOOL succeed,NSDictionary* detailDict,NSError *error))completion;

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray Settings:settings completion:(void (^)(BOOL succeed,NSDictionary* detailDict,NSError *error))completion;
/** 不需要判断是否有网*/
+ (void)postWithURLWithNotWEB:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray Settings:settings completion:(void (^)(BOOL succeed,NSDictionary* detailDict,NSError *error))completion;

@end
