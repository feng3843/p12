//
//  PhotoCollectionViewCell.h
//  test
//
//  Created by 夏雪 on 15/8/31.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic,copy)NSString *imagePath;
@property(nonatomic,assign)BOOL isFirst;

@end
