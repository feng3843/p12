//
//  DingWeiTableViewCell.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/3.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DingWeiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picView;//图片
@property (weak, nonatomic) IBOutlet UILabel *maiJiaLabel;//普通卖家
@property (weak, nonatomic) IBOutlet UILabel *reDuLabel;//热度
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;//距离

@end
