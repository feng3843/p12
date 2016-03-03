//
//  CollectionViewCell.h
//  collectionView
//
//  Created by shikee_app05 on 14-12-10.
//  Copyright (c) 2014年 shikee_app05. All rights reserved.
//帖子页面

#import <UIKit/UIKit.h>

@protocol noteCollectionViewDelegate <NSObject>


- (void)paseUserId:(NSString *)userId AndNoteId:(NSString *)noteIdbyFans;

@end

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) id<noteCollectionViewDelegate>delegate;
@property (nonatomic, copy) NSString *noteId;
@property (nonatomic, copy) NSString *noteOwnerId;

@property (nonatomic, assign) int likes;
@property (nonatomic, copy) NSString *isLike;



@property (nonatomic, strong) UIGestureRecognizer *tap1;
//商品图片
@property(nonatomic ,strong)UIImageView *imgView;
//商品描述
@property(nonatomic ,strong)UILabel *text;
/**评论背景页*/
@property (nonatomic, strong) UIView *contentView1;
//评论数
@property (nonatomic, strong) UILabel *pingLun;
/**点赞背景页*/
@property (nonatomic, strong) UIButton *contentView2;
/**点赞数*/
@property (nonatomic, strong) UILabel *dianZan;
/**点赞爱心图片*/
@property (nonatomic, strong) UIImageView *dianZanImage;

@property (nonatomic, strong) UIButton *btn;




@end




