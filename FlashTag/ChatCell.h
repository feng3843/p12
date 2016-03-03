//
//  ChatCell.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell


@property(nonatomic , strong)UIImageView *userHeardImage;
@property(nonatomic , strong)UILabel *userName;
@property(nonatomic , strong)UILabel *infoLabel;
@property(nonatomic , strong)UILabel *timeLabel;

@end
