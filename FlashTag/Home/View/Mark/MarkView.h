//
//  MarkView.h
//  MarkDemo
//
//  Created by py on 15/9/3.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkView : UIView
@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic ,copy)NSString *title;
@property(nonatomic,weak)UIButton *currentBtn;
@end
