//
//  HomeLineLayout.m
//  FlashTag
//
//  Created by 夏雪 on 15/8/27.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "HomeLineLayout.h"


@implementation HomeLineLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

/**
 *  只要显示的边界发生改变就重新布局:
 内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 *  用来设置collectionView停止滚动那一刻的位置
 *
 *  @param proposedContentOffset 原本collectionView停止滚动那一刻的位置
 *  @param velocity              滚动速度
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 1.计算出scrollView最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
 
    // 计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    //    // 判断是否为第一个
    //    if (proposedContentOffset.x<centerX) {
    //        return CGPointZero;
    //    }
    //    // 判断是否为最后一个
    //    if (proposedContentOffset.x>self.collectionViewContentSize.width-self.collectionView.frame.size.width*1.5+self.sectionInset.right) {
    //        return CGPointMake(self.collectionViewContentSize.width-self.collectionView.frame.size.width, 0);
    //    }
    // 2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    // 3.遍历所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
//            if (attrs.center.x == centerX) {
//                if([self.delegate respondsToSelector:@selector(homeLineLayout:didCenterCellItem:)
//                    ])
//                {
//                    [self.delegate homeLineLayout:self didCenterCellItem:attrs.indexPath.row];
//                }
//            }
//            if (attrs.indexPath.row==6)
//            {
//               // [self.collectionView scrollRectToVisible:CGRectMake(320 * 6,0,320,100) animated:NO]; // 序号0 最后1页
//                 [self.collectionView setContentOffset:CGPointMake(0, 0)];
//            }
//            else if (attrs.indexPath.row==6)
//            {
//                [self.collectionView scrollRectToVisible:CGRectMake(320,0,320,100) animated:NO]; // 最后+1,循环第1页
//            }   

            
            
        // NSLog(@"%ld",attrs.indexPath.row);
        }
    }
 
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGFloat pagewidth = scrollView.frame.size.width;
//    int currentPage = floor((scrollView.contentOffset.x - pagewidth/ (6+2)) / pagewidth) + 1;
//    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
//    //    NSLog(@"currentPage_==%d",currentPage_);
//    if (currentPage==0)
//    {
//        [scrollView scrollRectToVisible:CGRectMake(420,0,320,100) animated:NO]; // 序号0 最后1页
//    }
//    else if (currentPage==6)
//    {
//        [scrollView scrollRectToVisible:CGRectMake(0,0,320,100) animated:NO]; // 最后+1,循环第1页
//    }
//}

/**
 *  一些初始化工作最好在这里实现
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 每个cell的尺寸
  self.itemSize = CGSizeMake(HMItemWH, HMItemWH);
   CGFloat inset = 0;
//    CGFloat inset = 11;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    // 设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = HMItemWH * 0.4;
    
    // 每一个cell(item)都有自己的UICollectionViewLayoutAttributes
    // 每一个indexPath都有自己的UICollectionViewLayoutAttributes
}
#define HMActiveDistance 150*rateW
/** 有效距离:当item的中间x距离屏幕的中间x在HMActiveDistance以内,才会开始放大, 其它情况都是缩小 */
#define HMScaleFactor 0.3 *rateW
/** 缩放因素: 值越大, item就会越大 */


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 0.计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    // 1.取得默认的cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    

    // 2.遍历所有的布局属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        // 如果不在屏幕上,直接跳过
       if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
      //  PYLog(@"%@xxxx-",attrs);
        // 每一个item的中点x
        
       
        CGFloat itemCenterX = attrs.center.x;
      
        // 差距越小, 缩放比例越大
        // 根据跟屏幕最中间的距离计算缩放比例
        CGFloat scale = 1 + HMScaleFactor * (1 - (ABS(itemCenterX - centerX) / HMActiveDistance));
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
        if (ABS(itemCenterX - centerX) <0.5) {
                            if([self.delegate respondsToSelector:@selector(homeLineLayout:didCenterCellItem:)
                                ])
                            {
                                [self.delegate homeLineLayout:self didCenterCellItem:attrs.indexPath.row];
                            }
        }
    }
    
    return array;
}

@end
