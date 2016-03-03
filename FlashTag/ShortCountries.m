//
//  ShortCountries.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/22.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "ShortCountries.h"
#import "CountrysName.h"
#import "ChineseToPinyin.h"


@implementation ShortCountries




+ (NSArray *)shortCountriesByCountryArr:(NSMutableArray *)arr {

    
    NSMutableArray *arrA = [NSMutableArray array];
    NSMutableArray *arrB = [NSMutableArray array];
    NSMutableArray *arrC = [NSMutableArray array];
    NSMutableArray *arrD = [NSMutableArray array];
    NSMutableArray *arrE = [NSMutableArray array];
    NSMutableArray *arrF = [NSMutableArray array];
    NSMutableArray *arrG = [NSMutableArray array];
    NSMutableArray *arrH = [NSMutableArray array];
    NSMutableArray *arrI = [NSMutableArray array];
    NSMutableArray *arrJ = [NSMutableArray array];
    NSMutableArray *arrK = [NSMutableArray array];
    NSMutableArray *arrL = [NSMutableArray array];
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *arrN = [NSMutableArray array];
    NSMutableArray *arrO = [NSMutableArray array];
    NSMutableArray *arrP = [NSMutableArray array];
    NSMutableArray *arrQ = [NSMutableArray array];
    NSMutableArray *arrR = [NSMutableArray array];
    NSMutableArray *arrS = [NSMutableArray array];
    NSMutableArray *arrT = [NSMutableArray array];
    NSMutableArray *arrU = [NSMutableArray array];
    NSMutableArray *arrV = [NSMutableArray array];
    NSMutableArray *arrW = [NSMutableArray array];
    NSMutableArray *arrX = [NSMutableArray array];
    NSMutableArray *arrY = [NSMutableArray array];
    NSMutableArray *arrZ = [NSMutableArray array];
    
    for (CountrysName *countryName in arr) {
        
        NSString *zimuName = [ChineseToPinyin pinyinFromChiniseString:countryName.chineseName];
        
        if ([zimuName hasPrefix:@"A"]) {
            [arrA addObject:countryName.chineseName];
        } else if ([zimuName hasPrefix:@"B"]) {
            [arrB addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"C"]) {
            [arrC addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"D"]) {
            [arrD addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"E"]) {
            [arrE addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"F"]) {
            [arrF addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"G"]) {
            [arrG addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"H"]) {
            [arrH addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"I"]) {
            [arrI addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"J"]) {
            [arrJ addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"K"]) {
            [arrK addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"L"]) {
            [arrL addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"M"]) {
            [arrM addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"N"]) {
            [arrN addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"O"]) {
            [arrO addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"P"]) {
            [arrP addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"Q"]) {
            [arrQ addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"R"]) {
            [arrR addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"S"]) {
            [arrS addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"T"]) {
            [arrT addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"U"]) {
            [arrU addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"V"]) {
            [arrV addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"W"]) {
            [arrW addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"X"]) {
            [arrX addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"Y"]) {
            [arrY addObject:countryName.chineseName];
        }else if ([zimuName hasPrefix:@"Z"]) {
            [arrZ addObject:countryName.chineseName];
        }
    }
    NSMutableArray *bigArr = [NSMutableArray array];
    
    if (arrA.count) {
        [bigArr addObject:@{@"zimu":@"A", @"list":arrA}];
    }
    if (arrB.count) {
        [bigArr addObject:@{@"zimu":@"B", @"list":arrB}];
    }
    if (arrC.count) {
        [bigArr addObject:@{@"zimu":@"C", @"list":arrC}];
    }
    if (arrD.count) {
        [bigArr addObject:@{@"zimu":@"D", @"list":arrD}];
    }
    if (arrE.count) {
        [bigArr addObject:@{@"zimu":@"E", @"list":arrE}];
    }
    if (arrF.count) {
        [bigArr addObject:@{@"zimu":@"F", @"list":arrF}];
    }
    if (arrG.count) {
        [bigArr addObject:@{@"zimu":@"G", @"list":arrG}];
    }
    if (arrH.count) {
        [bigArr addObject:@{@"zimu":@"H", @"list":arrH}];
    }
    if (arrI.count) {
        [bigArr addObject:@{@"zimu":@"I", @"list":arrI}];
    }
    if (arrJ.count) {
        [bigArr addObject:@{@"zimu":@"J", @"list":arrJ}];
    }
    if (arrK.count) {
        [bigArr addObject:@{@"zimu":@"K", @"list":arrK}];
    }
    if (arrL.count) {
        [bigArr addObject:@{@"zimu":@"L", @"list":arrL}];
    }
    if (arrM.count) {
        [bigArr addObject:@{@"zimu":@"M", @"list":arrM}];
    }
    if (arrN.count) {
        [bigArr addObject:@{@"zimu":@"N", @"list":arrN}];
    }
    if (arrO.count) {
        [bigArr addObject:@{@"zimu":@"O", @"list":arrO}];
    }
    if (arrP.count) {
        [bigArr addObject:@{@"zimu":@"P", @"list":arrP}];
    }
    if (arrQ.count) {
        [bigArr addObject:@{@"zimu":@"Q", @"list":arrQ}];
    }
    if (arrR.count) {
        [bigArr addObject:@{@"zimu":@"R", @"list":arrR}];
    }
    if (arrS.count) {
        [bigArr addObject:@{@"zimu":@"S", @"list":arrS}];
    }
    if (arrT.count) {
        [bigArr addObject:@{@"zimu":@"T", @"list":arrT}];
    }
    if (arrU.count) {
        [bigArr addObject:@{@"zimu":@"U", @"list":arrU}];
    }
    if (arrV.count) {
        [bigArr addObject:@{@"zimu":@"V", @"list":arrV}];
    }
    if (arrW.count) {
        [bigArr addObject:@{@"zimu":@"W", @"list":arrW}];
    }
    if (arrX.count) {
        [bigArr addObject:@{@"zimu":@"X", @"list":arrX}];
    }
    if (arrY.count) {
        [bigArr addObject:@{@"zimu":@"Y", @"list":arrY}];
    }
    if (arrZ.count) {
        [bigArr addObject:@{@"zimu":@"Z", @"list":arrZ}];
    }

    
    return bigArr;
}

@end
