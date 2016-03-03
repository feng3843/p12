//
//  CYMessageTableViewCell.m
//  CYDemo
//
//  Created by 黄黄双全 on 15/9/30.
//  Copyright (c) 2015年 黄黄双全. All rights reserved.
//

#import "CYMessageTableViewCell.h"

@implementation CYMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCell];
    }
    return self;
}

- (void)configureCell {
    CGFloat cellHeight = self.frame.size.height;
    CGFloat cellWide = [UIScreen mainScreen].bounds.size.width;
    self.leftLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(21), (cellHeight-20)/2.0, 20, 20)];
    _leftLogoImageView.image = [UIImage imageNamed:@"ic_message_comment"];
    
    self.leftContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftLogoImageView.frame)+9, 0, 200, cellHeight)];
    _leftContentLabel.font = [UIFont systemFontOfSize:15];
    self.leftContentLabel.textColor = PYColor(@"222222");
    
    
    self.rightRedBackView = [[UIView alloc] initWithFrame:CGRectMake(cellWide-15-20, (cellHeight-20)/2.0, 20, 20)];
    _rightRedBackView.backgroundColor = [UIColor redColor];
    _rightRedBackView.layer.masksToBounds = YES;
    _rightRedBackView.layer.cornerRadius = 10;
    _rightRedBackView.backgroundColor = PYColor(@"ff3300");
    _rightRedBackView.hidden = YES;
    
    self.rightCountLabel = [[UILabel alloc] initWithFrame:_rightRedBackView.bounds];
    _rightCountLabel.font = [UIFont systemFontOfSize:kCalculateV(13)];
    _rightCountLabel.textColor = PYColor(@"ffffff");
    _rightCountLabel.textAlignment = NSTextAlignmentCenter;
    [_rightRedBackView addSubview:_rightCountLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, cellWide, 0.5)];
    lineView.backgroundColor = PYColor(@"cccccc");
    
    
    [self addSubview:_leftLogoImageView];
    [self addSubview:_leftContentLabel];
    [self addSubview:_rightRedBackView];
    [self addSubview:lineView];
}

@end
