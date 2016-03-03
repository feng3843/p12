//
//  ConfigurHotCell.m
//  FlashTag
//
//  Created by 黄黄双全 on 15/9/10.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigurHotCell.h"
#import "BiaoQianVC.h"
@implementation ConfigurHotCell

- (void)setArray:(NSMutableArray *)arr {
    _hotArr = [NSMutableArray arrayWithArray:arr];
}
- (NSMutableArray *)getArr {
    return _hotArr;
}



- (void)configureHotCellWithCell:(HotCell *)cell andArr:(NSMutableArray *)hotArr{
    if (hotArr.count == 4) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:hotArr];
        [arr setArray:arr];
        UIGestureRecognizer *firstGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstImageAction:)];
        UIGestureRecognizer *secondGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondImageAction:)];
        UIGestureRecognizer *thirdGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdImageAction:)];
        UIGestureRecognizer *fourthGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fourthImageAction:)];
        NSString *path = [CMData getCommonImagePath];
        
        cell.firstImage.userInteractionEnabled = YES;
        [cell.firstImage addGestureRecognizer:firstGesture];
        
        cell.firstLabel.text = (hotArr[0])[@"tagName"];
        NSString *firstNoteId = (hotArr[0])[@"noteId"];
        NSString *firstUserId = [NSString stringWithFormat:@"%02d", [(hotArr[0])[@"userId"] intValue]];
        NSString *noteImageUrl = [NSString stringWithFormat:@"%@/%@/note%@_1.jpg", path, firstUserId, firstNoteId]; //标签图片地址拼接
        [cell.firstImage sd_setImageWithURL:[NSURL URLWithString:noteImageUrl] placeholderImage:[UIImage imageNamed:@"test1.jpg"]];
        
        
        cell.secondImage.userInteractionEnabled = YES;
        [cell.secondImage addGestureRecognizer:secondGesture];
        cell.secondLabel.text = (hotArr[1])[@"tagName"];
        NSString *secondNoteId = (hotArr[1])[@"noteId"];
        NSString *secondUserId = [NSString stringWithFormat:@"%02d", [(hotArr[1])[@"userId"] intValue]];
        NSString *secondNoteImageUrl = [NSString stringWithFormat:@"%@/%@/note%@_1.jpg", path, secondNoteId, secondUserId]; //标签图片地址拼接
        [cell.secondImage sd_setImageWithURL:[NSURL URLWithString:secondNoteImageUrl] placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        
        cell.thirdImage.userInteractionEnabled = YES;
        [cell.thirdImage addGestureRecognizer:thirdGesture];
        cell.thirdLabel.text = (hotArr[2])[@"tagName"];
        NSString *thirdNoteId = (hotArr[2])[@"noteId"];
        NSString *thirdUserId = [NSString stringWithFormat:@"%02d", [(hotArr[2])[@"userId"] intValue]];
        NSString *thirdNoteImageUrl = [NSString stringWithFormat:@"%@/%@/note%@_2.jpg", path, thirdNoteId, thirdUserId]; //标签图片地址拼接
        [cell.thirdImage sd_setImageWithURL:[NSURL URLWithString:thirdNoteImageUrl] placeholderImage:[UIImage imageNamed:@"test3.jpg"]];
        
        cell.fourthImage.userInteractionEnabled = YES;
        [cell.fourthImage addGestureRecognizer:fourthGesture];
        cell.fourthLabel.text = (hotArr[3])[@"tagName"];
        NSString *fourthNoteId = (hotArr[3])[@"noteId"];
        NSString *fourthUserId = [NSString stringWithFormat:@"%02d", [(hotArr[3])[@"userId"] intValue]];
        NSString *fourthNoteImageUrl = [NSString stringWithFormat:@"%@/%@/note%@_2.jpg", path, fourthNoteId, fourthUserId]; //标签图片地址拼接
        [cell.fourthImage sd_setImageWithURL:[NSURL URLWithString:fourthNoteImageUrl] placeholderImage:[UIImage imageNamed:@"test1.jpg"]];
    }

}
//
//热门标签的第一张图片点击方法
- (void)firstImageAction:(UITapGestureRecognizer *)sender {
    NSString *str = (_hotArr[0])[@"tagName"];
    [self presentViewByName:str];
}
- (void)secondImageAction:(UITapGestureRecognizer *)sender {
    NSString *str = (_hotArr[1])[@"tagName"];
    [self presentViewByName:str];
}
- (void)thirdImageAction:(UITapGestureRecognizer *)sender {
    NSString *str = (_hotArr[2])[@"tagName"];
    [self presentViewByName:str];
}
- (void)fourthImageAction:(UITapGestureRecognizer *)sender {
    NSString *str = (_hotArr[3])[@"tagName"];
    [self presentViewByName:str];
}

//代理跳转
- (void)presentViewByName:(NSString *)sender {
    [self.delegate pushViewControllerWithName:sender];
}


@end
