//
//  HotTagView.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/5.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "HotTagView.h"

@implementation HotTagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.backImage = [[UIImageView alloc] initWithFrame:self.bounds];
    self.tagLabel = [[UILabel alloc] initWithFrame:_backImage.bounds];
    _tagLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    _tagLabel.textColor = PYColor(@"ffffff");
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_tagLabel.text.length<5) {
        _tagLabel.numberOfLines = 1;
    } else {
        _tagLabel.numberOfLines = 2;
    }
    
    UIView *mengCeng = [[UIView alloc] initWithFrame:self.bounds];
    mengCeng.backgroundColor = PYColor(@"#000000");
    mengCeng.alpha = 0.4;
    
    [self.layer setCornerRadius:3];
    [self.layer setMasksToBounds:YES];
    
    [self addSubview:_backImage];
    [_backImage addSubview:_tagLabel];
    [_tagLabel addSubview:mengCeng];
}


@end
