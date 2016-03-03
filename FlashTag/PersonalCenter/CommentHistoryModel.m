//
//  CommentHistoryModel.m
//  FlashTag
//
//  Created by MyOS on 15/9/15.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "CommentHistoryModel.h"

@implementation CommentHistoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setAttributeWithDic:dic];
    }
    return self;
}

- (void)setAttributeWithDic:(NSDictionary *)dic
{
    NSArray *keyArray = [dic allKeys];
    for (NSString *key in keyArray) {
        if ([dic[key] isKindOfClass:[NSNull class]]) {
            [self setValue:@"null" forKey:key];
        }else{
            [self setValue:dic[key] forKey:key];
        }
    }
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未找到key值%@" , key);
}


@end
