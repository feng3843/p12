//
//  MessageDetailVC.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PYHttpTool.h"
#import "CMData.h"
#import "UIImageView+WebCache.h"

#import "NewFansModel.h"
#import "NewZanModel.h"
#import "NewCommentModel.h"

@interface MessageDetailVC : UIViewController

@property (nonatomic, assign) NSInteger myName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;

@end
