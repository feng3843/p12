//
//  FolderOperationViewController.h
//  FlashTag
//
//  Created by py on 15/9/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  文件夹操作

#import <UIKit/UIKit.h>
#import "FolderOperateModel.h"

typedef enum
{
    FolderOperationTypeDefault,//默认：空
    FolderOperationTypeAll,//货位和文件夹
    FolderOperationTypeForSale,//货位
    FolderOperationTypeNormal//文件夹
}FolderOperationType;

@protocol FolderOperationViewControllerDelegate <NSObject>

@required
-(void)selectFolder:(FolderOperateModel*)model;
- (void)bgBtnClick;

@end
@interface FolderOperationViewController : UIViewController

@property(nonatomic,weak)id <FolderOperationViewControllerDelegate>delegate;
@property(nonatomic,copy)NSString *headtitle;
@property(nonatomic,copy)NSString *freeRemain;
@property(nonatomic)FolderOperationType foType;

@end
