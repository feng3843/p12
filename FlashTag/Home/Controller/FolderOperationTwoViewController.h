//
//  FolderOperationTwoViewController.h
//  FlashTag
//
//  Created by 夏雪 on 15/10/1.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//   文件夹操作2级界面

#import <UIKit/UIKit.h>
@protocol FolderOperationTwoViewControllerDelegate <NSObject>

@optional
- (void)FolderOperationTwoBgBtnClick;

@end
@interface FolderOperationTwoViewController : UIViewController

@property(nonatomic ,weak)id<FolderOperationTwoViewControllerDelegate> delegate;
@property(nonatomic ,strong)NSMutableArray *resultList;
@property(nonatomic,copy)NSString *headtitle;
@property(nonatomic,copy)NSString *endtitle;
@end
