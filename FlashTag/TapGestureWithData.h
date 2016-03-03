//
//  TapGestureWithData.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/19.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFansModel.h"

@interface TapGestureWithData : UITapGestureRecognizer

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *noteId;
@property (nonatomic, copy) NSString *isFriend;

@property (nonatomic, weak) NewFansModel *model;


@end
