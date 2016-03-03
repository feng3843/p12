//
//  TableViewCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/1.
//  Copyright (c) 2015年 Puyun. All rights reserved.
// 用户页面

#import "TableViewCell.h"

@implementation TableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor grayColor];
        CGFloat wide = kCalculateH(45);
        CGFloat phoneWide = [UIScreen mainScreen].bounds.size.width;
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(8), wide, wide)];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.imgView.layer setCornerRadius:wide/2];
        [self.imgView.layer setMasksToBounds:YES];
        [self addSubview:self.imgView];
        
        self.userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+kCalculateH(10), kCalculateV(22), kCalculateH(94), kCalculateV(16))];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.font = [UIFont systemFontOfSize:15];
        self.userName.textColor = PYColor(@"#222222");
        [self addSubview:self.userName];
        
        self.lvImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userName.frame)+kCalculateH(5), kCalculateV(19.5), kCalculateH(21), kCalculateV(21))];
        [self addSubview:_lvImage];
        
        self.fans = [[UILabel alloc] initWithFrame:CGRectMake(phoneWide-15-kCalculateH(100), kCalculateV(22), kCalculateH(100), kCalculateV(15))];
        self.fans.textAlignment = NSTextAlignmentRight;
        self.fans.font = [UIFont systemFontOfSize:14];
        self.fans.textColor = PYColor(@"#999999");
        [self addSubview:self.fans];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(59), phoneWide, 0.5)];
        bottomLineView.backgroundColor = PYColor(@"cccccc");
        [self addSubview:bottomLineView];
        
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
