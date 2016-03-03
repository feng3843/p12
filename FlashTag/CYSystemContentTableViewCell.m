//
//  CYSystemContentTableViewCell.m
//  CYDemo
//
//  Created by 黄黄双全 on 15/9/30.
//  Copyright (c) 2015年 黄黄双全. All rights reserved.
//

#import "CYSystemContentTableViewCell.h"

@implementation CYSystemContentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCell];
    }
    return self;
}

- (void)configureCell {
    UIView *verticalView = [[UIView alloc] initWithFrame:CGRectMake(29, 0, 0.5, 54)];
    verticalView.backgroundColor = PYColor(@"cccccc");
    
    UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectMake(29, 6, 16, 0.5)];
    horizontalView.backgroundColor = PYColor(@"cccccc");
    
    self.timelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(horizontalView.frame), 0.5, 150, 11)];
    _timelLabel.font = [UIFont systemFontOfSize:11];
    _timelLabel.textColor = PYColor(@"999999");
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_timelLabel.frame), CGRectGetMaxY(_timelLabel.frame), [UIScreen mainScreen].bounds.size.width - 80, 40)];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = PYColor(@"222222");
    _contentLabel.numberOfLines = 0;
    
    [self addSubview:verticalView];
    [self addSubview:horizontalView];
    [self addSubview:_timelLabel];
    [self addSubview:_contentLabel];
    
}
@end
