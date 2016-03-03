//
//  FollowedTagsModel.h
//  FlashTag
//
//  Created by uncommon on 2015/09/26.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/// 我关注的标签
@interface FollowedTagsModel : NSObject

/// 标签名字
@property(nonatomic,copy)NSString *tagName;
/// 最新的帖子id
@property(nonatomic,copy)NSString *noteId;
/// 帖子拥有者的id
@property(nonatomic,copy)NSString *noteOwnerId;

@end
