//
//  CameraViewController.h
//  FlashTag
//
//  Created by py on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  相机胶卷

#import <UIKit/UIKit.h>
#import "MLImageCrop.h"

@protocol CameraDelagate <NSObject>

-(void)afterCut:(UIImage *)image ByViewController:(UIViewController*)viewC;

@end

@interface CameraViewController : UIViewController<MLImageCropDelegate>

@property(nonatomic,assign)BOOL isFrist;
@property(nonatomic,retain)id<CameraDelagate> delagate;

@property(nonatomic,assign) CutType type;
//比率：Default 宽高比；Circle：半径宽比
@property (nonatomic,assign) CGFloat ratio;

@end
