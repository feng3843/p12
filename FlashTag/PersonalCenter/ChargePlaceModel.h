//
//  ChargePlaceModel.h
//  FlashTag
//
//  Created by MyOS on 15/9/25.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargePlaceModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property(nonatomic , copy)NSString *fileId;
@property(nonatomic , copy)NSString *fileName;
@property(nonatomic , copy)NSString *expireTime;
@property(nonatomic , copy)NSString *buyTime;
@property(nonatomic , copy)NSString *noteId;
@property(nonatomic , copy)NSString *noteCont;
@property(nonatomic , copy)NSString *groupId;
@property(nonatomic,copy)NSString *leftDays;

@end
