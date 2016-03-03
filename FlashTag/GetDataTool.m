//
//  GetDataTool.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/9.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "GetDataTool.h"
#import "PYHttpTool.h"
#import "CMData.h"
#import "SpecialsModel.h"
#import "NoteModel.h"

@implementation GetDataTool

//获取精选页面首页数据
- (void)getDataOfSearchViewWithPath:(NSString *)path andParam:(NSDictionary *)param withViewTitle:(NSString *)title {
    [CMAPI postUrl:path Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        NSString *path = [CMData getCommonImagePath];
        if(succeed)
        {
            if ([title isEqualToString:@"jingxuan"]) {
                PYLog(@"*********************************************精选的数据是: %@",result);
                NSArray *dataArr = result[@"list"];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dic in dataArr) {
                    SpecialsModel *tempModel = [[SpecialsModel alloc] initWithDictionary:dic];
                    [tempArr addObject:tempModel];
                }
                if(!!self.delegate&&[self.delegate respondsToSelector:@selector(getedDataWithArr:andPath:andTitle:)])
                {
                    [self.delegate getedDataWithArr:tempArr andPath:path andTitle:title];
                }
            } else if ([title isEqualToString:@"shops"]) {
                NSLog(@"=======================专业卖家展示的数据是: %@", result);
                NSArray *dataArr = result[@"list"];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dic in dataArr) {
                    SpecialsModel *tempModel = [[SpecialsModel alloc] initWithDictionary:dic];
                    [tempArr addObject:tempModel];
                }
                if(!!self.delegate&&[self.delegate respondsToSelector:@selector(getedDataWithArr:andPath:andTitle:)])
                {
                    [self.delegate getedDataWithArr:tempArr andPath:path andTitle:title];
                }
            }
        }else
        {
//            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}


- (void)getZhuTiDataWithItemId:(NSString *)itemId withOrderRanking:(int)orderRanking{
    self.dataArr = [NSMutableArray array];
    NSDictionary *tempParam = @{@"order":@(0), @"orderRule":@"adsOrSpecials", @"itemIds":itemId, @"count":@(50), @"orderRanking":@(orderRanking), @"userId":[CMData getUserId], @"tagNames":@"NULL"};//用户获取帖子列表
    [CMAPI postUrl:API_GET_NOTELIST Param:tempParam Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        if (succeed) {
            PYLog(@"%@", result);
            NSArray *tempArr = result[@"noteList"];
            for (NSDictionary *dic in tempArr) {
                NoteModel *tempModel = [[NoteModel alloc] initWithDictionary:dic];
                [_dataArr addObject:tempModel];
            }
            
            //////////////////////////////////
            NSArray *userArray = [NSArray arrayWithArray:result[@"userList"]];
            NSMutableArray *allArray = [NSMutableArray arrayWithObjects:_dataArr, userArray, nil];

            if(!!self.delegate&&[self.delegate respondsToSelector:@selector(getDataArr:)])
            {
                [self.delegate getDataArr:allArray];
            }
        } else {
            //            [SVProgressHUD showErrorWithStatus:[[detailDict objectForKey:@"result"] objectForKey:@"reason"]];
        }
    }];
}

-(void)dealloc
{
    self.delegate = nil;
    self.dataArr = nil;
}

@end
