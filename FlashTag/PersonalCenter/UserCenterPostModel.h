//
//  UserCenterPostModel.h
//  FlashTag
//
//  Created by MyOS on 15/9/15.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterPostModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property(nonatomic , copy)NSString *noteDesc;
@property(nonatomic , copy)NSString *browseNum;
@property(nonatomic , copy)NSString *comments;
@property(nonatomic , copy)NSString *notePicCount;
@property(nonatomic , copy)NSString *fileId;
@property(nonatomic , copy)NSString *likes;
@property(nonatomic , copy)NSString *tags;
@property(nonatomic , copy)NSString *noteId;
@property(nonatomic , copy)NSString *userDisplayName;
@property(nonatomic , copy)NSString *userId;
@property(nonatomic , copy)NSString *noteLocation;
@property(nonatomic , copy)NSString *isForSale;
@property(nonatomic , copy)NSString *isLiked;
@property(nonatomic , copy)NSString *endTime;
@property(nonatomic , copy)NSString *fileType;
@property(nonatomic , copy)NSString *followed;
@property(nonatomic , copy)NSString *postTime;
@property(nonatomic , copy)NSString *dealCount;


@end
