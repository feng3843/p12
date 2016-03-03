//
//  GetDataTool.h
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GetDataDelegate <NSObject>

@optional
- (void)getedDataWithArr:(NSMutableArray *)dataArr andPath:(NSString *)pathStr andTitle:(NSString *)title;
- (void)getDataArr:(NSMutableArray *)dataArr;
@end

@interface GetDataTool : NSObject

@property (nonatomic, retain) id<GetDataDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *dataArr;

/**获取精选首页数据*/
- (void)getDataOfSearchViewWithPath:(NSString *)path andParam:(NSDictionary *)param withViewTitle:(NSString *)title;

/**获取主题数据*/
- (void)getZhuTiDataWithItemId:(NSString *)itemId withOrderRanking:(int)orderRanking;


@end
