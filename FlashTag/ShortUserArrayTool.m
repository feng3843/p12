//
//  ShortUserArrayTool.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/10/22.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "ShortUserArrayTool.h"
#import "UserModel.h"

@implementation ShortUserArrayTool

+ (NSMutableArray *)shortSearchUserArray:(NSMutableArray *)array {
    NSMutableArray *returnArr = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < array.count; i++) {
        for (int j = 0; j < array.count - 1 - i; j++) {
            UserModel *model1 = returnArr[j];
            UserModel *model2 = returnArr[j+1];
            if (model1.levle==model2.levle) {
                if ([model1.followed intValue]<[model2.followed intValue]) {
                    UserModel *tempModel;
                    tempModel = returnArr[j+1];
                    returnArr[j+1] = returnArr[j];
                    returnArr[j] = tempModel;
                }
            }
        }
    }
    return returnArr;
}

+ (NSMutableArray *)shortCountryUserArray:(NSMutableArray *)array {
    NSMutableArray *returnArr = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < array.count; i++) {
        for (int j = 0; j < array.count - 1 - i; j++) {
            UserModel *model1 = returnArr[j];
            UserModel *model2 = returnArr[j+1];
            if (model1.levle==model2.levle) {
                if ([model1.distance floatValue]>[model2.distance floatValue]) {
                    UserModel *tempModel;
                    tempModel = returnArr[j+1];
                    returnArr[j+1] = returnArr[j];
                    returnArr[j] = tempModel;
                }
            }
        }
    }
    return returnArr;
}




@end
