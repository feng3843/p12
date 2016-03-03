//
//  UITableViewCell_Puyun.m
//  FlashTag
//
//  Created by MingleFu on 15/11/20.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import "UILabel+Puyun.h"

@implementation UILabel(Puyun)

- (CGFloat)heightForCellWithContent {
    NSString* strContent = self.text;
    UIFont* font =self.font;
    UIColor* color=self.textColor;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strContent];
    NSRange allRange = [strContent rangeOfString:strContent];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:allRange];
    CGFloat height;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    
    height = ceilf(rect.size.height)+2;
    return height;
}

@end
