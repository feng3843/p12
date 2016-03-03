//
//  NSString+Extensions.h
//  YHT
//
//  Created by puyun on 15/2/12.
//  Copyright (c) 2015年 puyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(NSStringExtensions)

-(NSArray*)Matchs_Left:(NSString*)left Right:(NSString*)right;

-(NSArray*)Match_Left:(NSString*)left Right:(NSString*)right;


-(NSDate*)GetDate_FormatString:(NSString*)formatstring;


//截取左边长度字符
-(NSString*)SubsLeft:(int)ct;

//截取右边长度字符
-(NSString*)SubsRight:(int)ct;

//从哪截取到哪
-(NSString*)Subs_From:(int)left To:(int)right;


-(NSString *)get2Subs;

-(NSDictionary *)GetDictionary;







//-(NSString*)test;

@end
