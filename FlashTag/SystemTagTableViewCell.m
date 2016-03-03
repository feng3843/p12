//
//  SystemTagTableViewCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/22.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "SystemTagTableViewCell.h"

@implementation SystemTagTableViewCell
//UIImageView *sysMarkImageView;
//UILabel *markLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sysMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(7.5), kCalculateH(40), kCalculateV(40))];
        [_sysMarkImageView.layer setCornerRadius:3];
        [_sysMarkImageView.layer setMasksToBounds:YES];
        [self addSubview:_sysMarkImageView];
        
        self.markLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sysMarkImageView.frame)+kCalculateH(15), kCalculateV(20), kCalculateH(100), kCalculateV(15))];
        _markLabel.font = [UIFont systemFontOfSize:kCalculateV(15)];
        _markLabel.textColor = PYColor(@"222222");
        [self addSubview:_markLabel];
        
    }
    return self;
}


@end
