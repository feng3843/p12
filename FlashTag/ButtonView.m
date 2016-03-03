//
//  ButtonView.m
//  KVOAndNSNotificationCenter
//
//  Created by 黄黄双全 on 15/9/25.
//  Copyright (c) 2015年 黄黄双全. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame andButtonArr:(NSArray *)array {
    
    
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger count = array.count;
        
        CGFloat phoneWhit = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, phoneWhit, 0.5)];
        lineViewTop.backgroundColor = PYColor(@"bababa");
        [self addSubview:lineViewTop];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5, phoneWhit, 0.5)];
        lineView.backgroundColor = PYColor(@"bababa");
        [self addSubview:lineView];
        
        self.btn1  = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.frame = CGRectMake(0, 0, phoneWhit/count, self.frame.size.height);
        [_btn1 setTitle:array[0] forState:UIControlStateNormal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn1 setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
        [_btn1 setTitleColor:PYColor(@"267cc6") forState:UIControlStateSelected];
        [_btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn1];
        [self btn1Action:_btn1];
        
        self.btn2  = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.frame = CGRectMake(phoneWhit/count, 0, phoneWhit/count, self.frame.size.height);
        [_btn2 setTitle:array[1] forState:UIControlStateNormal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn2 setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
        [_btn2 setTitleColor:PYColor(@"267cc6") forState:UIControlStateSelected];
        [_btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn2];
        
        
        self.btn3  = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn3.frame = CGRectMake(phoneWhit/count*2, 0, phoneWhit/count, self.frame.size.height);
        [_btn3 setTitle:array[2] forState:UIControlStateNormal];
        _btn3.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn3 setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
        [_btn3 setTitleColor:PYColor(@"267cc6") forState:UIControlStateSelected];
        [_btn3 addTarget:self action:@selector(btn3Action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn3];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTwoButtonArr:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger count = array.count;
        
        CGFloat phoneWhit = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, phoneWhit, 0.5)];
        lineViewTop.backgroundColor = PYColor(@"bababa");
        [self addSubview:lineViewTop];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5, phoneWhit, 0.5)];
        lineView.backgroundColor = PYColor(@"bababa");
        [self addSubview:lineView];
        
        self.btn1  = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.frame = CGRectMake(0, 0, phoneWhit/count, self.frame.size.height);
        [_btn1 setTitle:array[0] forState:UIControlStateNormal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn1 setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
        [_btn1 setTitleColor:PYColor(@"267cc6") forState:UIControlStateSelected];
        [_btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn1];
        [self btn1Action:_btn1];
        
        self.btn2  = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.frame = CGRectMake(phoneWhit/count, 0, phoneWhit/count, self.frame.size.height);
        [_btn2 setTitle:array[1] forState:UIControlStateNormal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn2 setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
        [_btn2 setTitleColor:PYColor(@"267cc6") forState:UIControlStateSelected];
        [_btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn2];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andLoginButtonArr:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger count = array.count;
        
        self.wide = frame.size.width;
        self.height = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.btn1  = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.frame = CGRectMake(0, 0, _wide/count, _height);
        self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(6.5), CGRectGetMaxY(_btn1.frame)+kCalculateV(5), kCalculateH(38), 0.5)];
        _bottomLineView.backgroundColor = PYColor(@"267cc6");
        
        _btn1.titleLabel.font = [UIFont systemFontOfSize:17];
        [_btn1 setTitle:array[0] forState:UIControlStateNormal];
        [_btn1 setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
        [_btn1 setTitleColor:PYColor(@"267cc6") forState:UIControlStateSelected];
        [_btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bottomLineView];
        [self addSubview:_btn1];
        [self btn1Action:_btn1];
        
        self.btn2  = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.frame = CGRectMake(_wide/count, 0, _wide/count, _height);
        _btn2.titleLabel.font = [UIFont systemFontOfSize:17];
        [_btn2 setTitle:array[1] forState:UIControlStateNormal];
        [_btn2 setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
        [_btn2 setTitleColor:PYColor(@"267cc6") forState:UIControlStateSelected];
        [_btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn2];
        
    }
    return self;
}

- (void)btn1Action:(UIButton *)sender {
    sender.selected = YES;
    _btn2.selected = NO;
    _btn3.selected = NO;
    self.index = 0;
    
    if (_bottomLineView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomLineView.frame = CGRectMake(6.5, CGRectGetMaxY(sender.frame)+5, kCalculateH(38), 2);
        }];
    }
}

- (void)btn2Action:(UIButton *)sender {
    sender.selected = YES;
    _btn1.selected = NO;
    _btn3.selected = NO;
    self.index = 1;
    
    if (_bottomLineView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomLineView.frame = CGRectMake(_wide/2+6.5, CGRectGetMaxY(sender.frame)+5, kCalculateH(38), 2);
        }];
    }
}
- (void)btn3Action:(UIButton *)sender {
    sender.selected = YES;
    _btn1.selected = NO;
    _btn2.selected = NO;
    self.index = 2;
}




@end
