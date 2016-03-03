//
//  MarkFilterViewController.h
//  FlashTag
//
//  Created by py on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkModel.h"
@interface MarkFilterViewController : UIViewController
//@property(nonatomic ,copy)NSString *imageStr;
@property(nonatomic ,copy)UIImage *image;
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic ,strong)MarkModel *model;

@end
