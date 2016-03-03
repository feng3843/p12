//
//  UserModel.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];
    if (self) {
        self.popularity = dictionary[@"popularity"];
        self.followed = dictionary[@"followings"];
        self.userId = dictionary[@"userId"];
        self.userDisPlayName = dictionary[@"userDisplayName"];
        NSString *disStr = dictionary[@"distance"];
        self.distance = [self figureTheDistanceWithString:disStr];
        self.role = dictionary[@"role"];
        self.levle = dictionary[@"level"];
    }
    return self;
}

- (NSString *)figureTheDistanceWithString:(NSString *)distance {
    float distanceForFloat = [distance floatValue];
    if (distanceForFloat>1) {
        return [NSString stringWithFormat:@"%.0f公里以内", [distance floatValue]+1];
    } else {
        distanceForFloat = distanceForFloat*1000;
        distanceForFloat = distanceForFloat/100;
        NSString *tempStr = [NSString stringWithFormat:@"%.0f00米以内", distanceForFloat+1];
        return [NSString stringWithFormat:@"%@", tempStr];
    }
    
    return distance;
}

@end
