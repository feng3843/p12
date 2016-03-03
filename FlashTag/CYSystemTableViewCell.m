//
//  CYSystemTableViewCell.m
//  CYDemo
//
//  Created by 黄黄双全 on 15/9/30.
//  Copyright (c) 2015年 黄黄双全. All rights reserved.
//

#import "CYSystemTableViewCell.h"

@implementation CYSystemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCell];
    }
    return self;
}

- (void)configureCell {
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 30, 30)];
    logoImageView.image = [UIImage imageNamed:@"ic_message_notice"];
    
    UILabel *NotificationLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame)+5, 14, 200, 15)];
    NotificationLable.font = [UIFont systemFontOfSize:15];
    NotificationLable.textColor = PYColor(@"222222");
    NotificationLable.text = @"系统通知";
    
    UIView *verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(29, CGRectGetMaxY(logoImageView.frame), 1, 50)];
    verticalLineView.backgroundColor = PYColor(@"cccccc");
    
    [self addSubview:logoImageView];
    [self addSubview:NotificationLable];
    [self addSubview:verticalLineView];

}

@end
