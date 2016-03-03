//
//  EditFolderView.m
//  FlashTag
//
//  Created by MyOS on 15/9/8.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  编辑文件夹

#import "EditFolderView.h"

@implementation EditFolderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PYColor(@"e7e7e7");
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(10), fDeviceWidth, kCalculateV(44))];
    view1.backgroundColor = PYColor(@"ffffff");
    view1.layer.masksToBounds = YES;
    view1.layer.borderWidth = kCalculateH(0.5);
    view1.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self addSubview:view1];
    

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(kBJ), 0, kCalculateH(30), kCalculateV(44))];
    label.text = @"标题";
    label.textColor = PYColor(@"222222");
    label.font = [UIFont systemFontOfSize:kCalculateH(14)];
    [view1 addSubview:label];

    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + kCalculateH(20), 1, fDeviceWidth - (CGRectGetMaxX(label.frame) + kCalculateH(20)), kCalculateV(44))];
    self.textField.placeholder = @"有意义的名称";
    [self.textField setValue:[UIFont systemFontOfSize:kCalculateH(14)] forKeyPath:@"_placeholderLabel.font"];
    [self.textField setValue:PYColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [view1 addSubview:self.textField];
    
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame) + kCalculateV(20), fDeviceWidth, kCalculateV(45))];
    view2.backgroundColor = PYColor(@"ffffff");
    view2.layer.masksToBounds = YES;
    view2.layer.borderWidth = kCalculateH(0.5);
    view2.layer.borderColor = PYColor(@"cccccc").CGColor;
    [self addSubview:view2];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.deleteButton.frame = CGRectMake(0, 0, fDeviceWidth, kCalculateV(45));
    [self.deleteButton setTitle:@"删除文件夹" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    [self.deleteButton setTitleColor:PYColor(@"ff3b30") forState:UIControlStateNormal];
    [view2 addSubview:self.deleteButton];

}

@end
