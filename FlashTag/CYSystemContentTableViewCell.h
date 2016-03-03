//
//  CYSystemContentTableViewCell.h
//  CYDemo
//
//  Created by 黄黄双全 on 15/9/30.
//  Copyright (c) 2015年 黄黄双全. All rights reserved.
//  系统通知详情

#import <UIKit/UIKit.h>

@interface CYSystemContentTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UILabel *timelLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end
