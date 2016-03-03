//
//  PhotoFolderTableView.h
//  test
//
//  Created by 夏雪 on 15/8/31.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AssetsLibrary/AssetsLibrary.h>
@class PhotoFolderTableView;
@protocol PhotoFolderTableViewDelegate <NSObject>

@optional
- (void)photoFolderTableView:(PhotoFolderTableView *)photoFolderTableView didSelectRowAtName:(NSString *)name;

@end
@interface PhotoFolderTableView : UITableViewController
@property(nonatomic,weak)id<PhotoFolderTableViewDelegate> delegate;
@end
