//
//  CYMessageTableViewCell.h
//  CYDemo
//
//  Created by 黄黄双全 on 15/9/30.
//  Copyright (c) 2015年 黄黄双全. All rights reserved.
//  消息页面

#import <UIKit/UIKit.h>

@interface CYMessageTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UIImageView *leftLogoImageView;
@property (nonatomic, strong) UILabel *leftContentLabel;
@property (nonatomic, strong) UIView *rightRedBackView;
@property (nonatomic, strong) UILabel *rightCountLabel;

@end
