//
//  TableViewCell.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/1.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
//用户图像
@property(nonatomic ,strong)UIImageView *imgView;
//用户名
@property(nonatomic ,strong)UILabel *userName;
//热卖度
@property (nonatomic, strong)UILabel *sales;
//粉丝数
@property (nonatomic, strong)UILabel *fans;
//等级图片
@property (nonatomic, strong) UIImageView *lvImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
