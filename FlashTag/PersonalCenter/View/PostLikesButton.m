//
//  PostLikesButton.m
//  FlashTag
//
//  Created by MyOS on 15/10/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "PostLikesButton.h"

@implementation PostLikesButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.tagImage = [[UIImageView alloc] init];
    self.tagImage.frame = CGRectMake(kCalculateH(19), kCalculateV(7), kCalculateH(15), kCalculateV(15));
    
    [self addSubview:self.tagImage];
    
    
    self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(38), 0, kCalculateH(34), kCalculateV(30))];
    self.likesLabel.textColor = PYColor(@"999999");
    self.likesLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.likesLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.likesLabel];
}



@end
