//
//  NoteVIewController.h
//  FlashTag
//
//  Created by MingleFu on 15/10/12.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FolderOperationViewController.h"
#import "PYBaseViewController.h"

@interface NoteVIewController : PYBaseViewController<UIActionSheetDelegate,UIAlertViewDelegate,FolderOperationViewControllerDelegate>

@property(nonatomic,strong) NoteInfoModel* model;

@property(nonatomic,copy)NSString *noteId;
@property(nonatomic,copy)NSString *noteUserId;

@property(nonatomic,strong)FolderOperationViewController *folderOperationView;

-(void)moreClick;

@end
