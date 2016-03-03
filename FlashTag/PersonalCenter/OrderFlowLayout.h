//
//  OrderFlowLayout.h
//  FlashTag
//
//  Created by MingleFu on 15/10/23.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OrderFlowLayoutTypeTopZero,
    OrderFlowLayoutTypeTopOneRed,
    OrderFlowLayoutTypeTopOne
}OrderFlowLayoutTopType;
typedef enum {
    OrderFlowLayoutTypeMiddleZero,
    OrderFlowLayoutTypeMiddleOneRed,
    OrderFlowLayoutTypeMiddleOne,
    OrderFlowLayoutTypeMiddleTwo
}OrderFlowLayoutMiddleType;
typedef enum {
    OrderFlowLayoutTypeBottomZero,
    OrderFlowLayoutTypeBottomOneRed,
    OrderFlowLayoutTypeBottomTwoRedRed,
    OrderFlowLayoutTypeBottomTwoRedGray,
    OrderFlowLayoutTypeBottomOneGray,
    OrderFlowLayoutTypeBottomTwoGrayGray,
    OrderFlowLayoutTypeBottomTwoGrayRed
}OrderFlowLayoutBottomType;

//先用table 之后 再改成 UICollectionView
@interface OrderFlowLayout : NSObject

@property (nonatomic)OrderFlowLayoutTopType topType;
@property (nonatomic)OrderFlowLayoutMiddleType middleType;
@property (nonatomic)OrderFlowLayoutBottomType bottomType;

@end
