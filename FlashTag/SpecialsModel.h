//
//  SpecialsModel.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/26.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialsModel : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *itemDesc;
@property (nonatomic, strong) NSString *itemTitle;

@end
