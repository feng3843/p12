//
//  UITableView.h
//  FlashTag
//
//  Created by MingleFu on 15/9/29.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>
//图片－按钮－后退
#define IMG_BTN_BACK_NORMAIL @"btn_back"//后退按钮图标
#define IMG_BTN_BACK_PRESS @"btn_back"
#define IMG_BTN_EMOJI_NORMAIL @"btn_back"//聊天表情按钮图标
#define IMG_BTN_EMOJI_PRESS @"btn_back"
#define IMG_BTN_CHAT_SEND_NORMAIL @"btn_back"//聊天发送按钮图标
#define IMG_BTN_CHAT_SEND_PRESS @"btn_back"

//首页
#define IMG_DEFAULT_HOME_AD_NOIMAGE @"img_default_advertisement"//首页－发现－广告（AD）
#define IMG_DEFAULT_HOME_USER_AVATAR_NOIMAGE @"img_default_user"//首页－发现－用户头像（USER_AVATRAR）
#define IMG_DEFAULT_HOME_NOTE_NOIMAGE @"img_default_note"//首页－发现－帖子（NOTE）默认图
#define IMG_DEFAULT_HOME_NOTE_SMALL_NOIMAGE @"img_default_notelist"//首页－发现－帖子缩略图－默认图
#define IMG_DEFAULT_HOME_ATTENTION_NODATA @"img_default_home_attention"//首页－关注（ATTENTION）-无数据
//首页－发帖子
#define IMG_DEFAULT_NOTE_ADD_PHOTOLIST_NOIMAGE @"ic_default_photopic"//发帖子－手机照片（列表本地加载中默认图）
//文件夹
#define IMG_DEFAULT_FOLDER_DEFAULT @"img_default_folder"//文件夹（FOLDER）-默认文件夹/自定义文件夹
#define IMG_DEFAULT_FOLDER_NEW @"ic_add folder"//新建文件夹
#define IMG_DEFAULT_FOLDER_PLACE_FREE_UNLOCK @"img_default_free"//文件夹－免费货位
#define IMG_DEFAULT_FOLDER_PLACE_CHARGE_UNLOCK @"img_default_buy"//文件夹－收费货位
//货位（PLACE）
#define IMG_DEFAULT_PLACE_FREE_LOCK @"ic_lock2"//货位－免费货位－锁
#define IMG_DEFAULT_PLACE_FREE_UNUSE @"ic_xianzhi"//货位－免费货位－闲置
#define IMG_DEFAULT_PLACE_FREE_DEADLINE @"ic_lock"//货位－免费货位－到期
#define IMG_DEFAULT_PLACE_CHARGE_LOCK @"ic_lock2"//货位－收费货位－锁
#define IMG_DEFAULT_PLACE_CHARGE_UNUSE @"ic_xianzhi"//货位－收费货位－闲置
#define IMG_DEFAULT_PLACE_CHARGE_DEADLINE @"ic_lock"//货位－收费货位－到期
//搜索
#define IMG_DEFAULT_SEARCH_NOTE_NODATA @"img_default_me_newnote"//搜索－帖子－无数据
#define IMG_DEFAULT_SEARCH_BUY_NODATA @"img_default_me_newnote"//搜索－代购（BUY）－无数据
#define IMG_DEFAULT_SEARCH_USER_NODATA @"img_default_me_atuser"//搜索－用户－无数据

//个人中心（PERSONALCENTER）
//左上角按钮订单
#define IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_ALL_NODATA @"img_default_me_list"//个人中心－订单－卖－全部－无数据
#define IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_REFUND_NODATA @"img_default_me_list"//个人中心－订单－卖－退款－无数据
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_ALL_NODATA @"img_default_me_list"//个人中心－订单－买－全部－无数据
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_REFUND_NODATA @"img_default_me_list"//个人中心－订单－买－退款－无数据
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_PLACE_NODATA @"img_default_me_list"//个人中心－订单－买－货位－无数据

#define IMG_DEFAULT_PERSONALCENTER_USERAVATAR_NOIMAGE @"img_default_me_user"//个人中心－用户头像

#define IMG_DEFAULT_PERSONALCENTER_EXCHANGE_USERAVATAR_NOIMAGE @"img_default_me_user"//个人中心－兑换－用户头像
#define IMG_DEFAULT_PERSONALCENTER_EXCHANGE_PLACE_FREE @"img_default_change"//个人中心－兑换－免费货位

#define IMG_DEFAULT_PERSONALCENTER_ATTENTION_USER_NODATA @"img_default_me_atuser"//个人中心－关注－用户-无数据
#define IMG_DEFAULT_PERSONALCENTER_ATTENTION_TAG_NODATA @"img_default_me_tag"//个人中心－关注－标签-无数据
#define IMG_DEFAULT_PERSONALCENTER_FANS_NODATA @"img_default_me_follow"//个人中心－粉丝（FANS）－无数据

#define IMG_DEFAULT_PERSONALCENTER_NOTE_NODATA @"img_default_me_newnote"//个人中心－帖子－无数据
//#define IMG_DEFAULT_PERSONALCENTER_FOLDER_NODATA @"img_default_me_newnote"//个人中心－文件夹－无数据
#define IMG_DEFAULT_PERSONALCENTER_COLLECTION_NODATA @"img_default_me_collectnote"//个人中心－收藏（COLLECTION）－无数据

#define IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_NODATA @"img_default_me_comment"//个人中心－设置－我的评论－无数据

//首页
#define IMG_DEFAULT_HOME_FIND_LISTEND @"img_home_no_moredata1"//首页－发现（FIND）-无新数据提示
#define IMG_DEFAULT_HOME_ATTENTION_LISTEND @"img_home_no_moredata1"//首页－关注（ATTENTION）-无新数据提示
//搜索
#define IMG_DEFAULT_SEARCH_NOTE_LISTEND @"img_home_no_moredata1"//搜索－帖子－无新数据提示
#define IMG_DEFAULT_SEARCH_BUY_LISTEND @"img_home_no_moredata1"//搜索－代购（BUY）－无新数据提示
#define IMG_DEFAULT_SEARCH_USER_LISTEND @"img_home_no_moredata1"//搜索－用户－无新数据提示

//个人中心（PERSONALCENTER）
//左上角按钮订单
#define IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_ALL_LISTEND @"img_home_no_moredata1"//个人中心－订单－卖－全部－无新数据提示
#define IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_REFUND_LISTEND @"img_home_no_moredata1"//个人中心－订单－卖－退款－无新数据提示
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_ALL_LISTEND @"img_home_no_moredata1"//个人中心－订单－买－全部－无新数据提示
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_REFUND_LISTEND @"img_home_no_moredata1"//个人中心－订单－买－退款－无新数据提示
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_PLACE_LISTEND @"img_home_no_moredata1"//个人中心－订单－买－货位－无新数据提示

#define IMG_DEFAULT_PERSONALCENTER_ATTENTION_USER_LISTEND @"img_home_no_moredata1"//个人中心－关注－用户－无新数据提示
#define IMG_DEFAULT_PERSONALCENTER_ATTENTION_TAG_LISTEND @"img_home_no_moredata1"//个人中心－关注－标签－无新数据提示
#define IMG_DEFAULT_PERSONALCENTER_FANS_LISTEND @"img_home_no_moredata1"//个人中心－粉丝（FANS）－无新数据提示

#define IMG_DEFAULT_PERSONALCENTER_NOTE_LISTEND @"img_home_no_moredata1"//个人中心－帖子－无新数据提示
//#define IMG_DEFAULT_PERSONALCENTER_FOLDER_LISTEND @"img_home_no_moredata1"//个人中心－文件夹－无新数据提示
#define IMG_DEFAULT_PERSONALCENTER_COLLECTION_LISTEND @"img_home_no_moredata1"//个人中心－收藏（COLLECTION）－无新数据提示

#define IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_LISTEND @"img_home_no_moredata1"//个人中心－设置－我的评论－无新数据提示

//首页
#define IMG_DEFAULT_HOME_ATTENTION_NODATASTRING @"您还没有任何关注哦"//首页－关注（ATTENTION）-无数据提示
//搜索
#define IMG_DEFAULT_SEARCH_NOTE_NODATASTRING @"暂无帖子数据"//搜索－帖子－无数据提示
#define IMG_DEFAULT_SEARCH_BUY_NODATASTRING @"暂无代购数据"//搜索－代购（BUY）－无数据提示
#define IMG_DEFAULT_SEARCH_USER_NODATASTRING @"暂无用户数据"//搜索－用户－无数据提示

//个人中心（PERSONALCENTER）
//左上角按钮订单
#define IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_ALL_NODATASTRING @"您还没有任何订单哦"//个人中心－订单－卖－全部－无数据提示
#define IMG_DEFAULT_PERSONALCENTER_ORDER_SELL_REFUND_NODATASTRING @"您还没有任何退款哦"//个人中心－订单－卖－退款－无数据提示
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_ALL_NODATASTRING @"您还没有任何订单哦"//个人中心－订单－买－全部－无数据提示
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_REFUND_NODATASTRING @"您还没有任何退款哦"//个人中心－订单－买－退款－无数据提示
#define IMG_DEFAULT_PERSONALCENTER_ORDER_BUY_PLACE_NODATASTRING @"您还没有任何货位哦"//个人中心－订单－买－货位－无数据提示

#define IMG_DEFAULT_PERSONALCENTER_ATTENTION_USER_NODATASTRING @"您还没有任何用户哦"//个人中心－关注－用户－无数据提示
#define IMG_DEFAULT_PERSONALCENTER_ATTENTION_TAG_NODATASTRING @"您还没有任何标签哦"//个人中心－关注－标签－无数据提示
#define IMG_DEFAULT_PERSONALCENTER_FANS_NODATASTRING @"您还没有任何粉丝哦"//个人中心－粉丝（FANS）－无数据提示

#define IMG_DEFAULT_PERSONALCENTER_NOTE_NODATASTRING @"您还没有任何帖子哦"//个人中心－帖子－无数据提示
//#define IMG_DEFAULT_PERSONALCENTER_FOLDER_NODATASTRING @"你还没有任何文件夹哦"//个人中心－文件夹－无数据提示
#define IMG_DEFAULT_PERSONALCENTER_COLLECTION_NODATASTRING @"您还没有任何收藏哦"//个人中心－收藏（COLLECTION）－无数据提示

#define IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_NODATASTRING @"您还没有任何评论哦"//个人中心－设置－我的评论－无数据提示

typedef enum {
    NoDataCSSTop,
    NoDataCSSMiddle
}NoDataCSS;

@interface UIImageView (Puyun)

-(void)showDefaultImage:(NSString*)imageName;

-(void)showImage:(NSString*)imagePath DefaultImage:(NSString*)defaultImage;

@end

@interface UIScrollView (Puyun)
//flag数据是否存在
-(void)showEmptyListHaveData:(BOOL)flag Image:(NSString*)imageName Desc:(NSString*)desc ByCSS:(NoDataCSS)css;
-(void)showEmptyList:(NSArray*)array Image:(NSString*)imageName Desc:(NSString*)desc ByCSS:(NoDataCSS)css;

@end
