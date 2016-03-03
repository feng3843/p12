//
//  UsuallyLivePlace.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsuallyLivePlace : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

/**国家*/
@property (nonatomic, copy) NSString *country;
/**常居住地的经纬度*/
@property (nonatomic, copy) NSString *locateAddress;
/**省份或州*/
@property (nonatomic, copy) NSString *province;
/**城市*/
@property (nonatomic, copy) NSString *city;


@end
