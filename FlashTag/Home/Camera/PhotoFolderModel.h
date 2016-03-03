//
//  PhotoFolderModel.h
//  test
//
//  Created by 夏雪 on 15/9/1.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoFolderModel : NSObject
/** 文件夹名称*/
@property(nonatomic,copy)NSString *name;
/** 文件夹名称*/
@property(nonatomic,copy)NSString *count;
/** 图片路径*/
@property(nonatomic,copy)NSString *urlStr;
/** 封面图片图片*/
@property(nonatomic,copy)UIImage *posterImage;
@end
