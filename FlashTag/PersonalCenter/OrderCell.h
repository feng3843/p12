//
//  OrderCell.h
//  FlashTag
//
//  Created by MingleFu on 15/10/23.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderFlowLayout.h"

@interface OrderCell : UITableViewCell

//Top
//LA  增加
@property(nonatomic)UIButton *btnGotoUserCenter;
@property(nonatomic , strong)UIImageView *userHeadImageView;//用户头像
@property(nonatomic , strong)UILabel *userName;//用户名称
@property(nonatomic , strong)UIImageView *arrowImageView;//静态图片
@property(nonatomic , strong)UILabel *stateLabel;//订单状态

@property(nonatomic , strong)UIView *divideUpView;//分割线
//Middle
@property(nonatomic)UITapGestureRecognizer *grGotoNoteDetail;//跳转帖子详情
@property(nonatomic , strong)UIImageView *postImageView;//帖子封面
@property(nonatomic , strong)UILabel *detailLabel;//帖子详情
@property(nonatomic , strong)UILabel *timeLabel;//时间
@property(nonatomic , strong)UILabel *pLabel;//静态文本
@property(nonatomic , strong)UILabel *priceLabel;//代购价格
@property(nonatomic , strong)UILabel *rLabel;//静态文本:
@property(nonatomic , strong)UILabel *refundLabel;//退款价格

@property(nonatomic , strong)UIView *divideDownView;//分割线

//Bottom
//需要懒加载的控件
@property(nonatomic , strong)UIButton *leftButton;//左按钮
@property(nonatomic , strong)UIButton *rightButton;//右按钮

@property(nonatomic) OrderFlowLayout* flowLayout;

@end
