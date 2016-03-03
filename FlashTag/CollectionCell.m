//
//  CollectionViewCell.m
//  collectionView
//
//  Created by shikee_app05 on 14-12-10.
//  Copyright (c) 2014年 shikee_app05. All rights reserved.
// 帖子页面

#import "CollectionCell.h"
#import "CommonInterface.h"
#import "CelllButton.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = PYColor(@"cccccc").CGColor;
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-30)];
        [self addSubview:self.imgView];
        
        
        self.contentView1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.imgView.frame.size.height +1, self.frame.size.width/2-1, self.frame.size.height-self.imgView.frame.size.height-1)];
        [self addSubview:_contentView1];
        
        self.contentView2 = [CelllButton buttonWithType:UIButtonTypeCustom];
        _contentView2.frame = CGRectMake(CGRectGetMaxX(_contentView1.frame)+1, CGRectGetMaxY(self.imgView.frame)+1, self.frame.size.width/2-1, self.frame.size.height-self.imgView.frame.size.height-1);
        [self addSubview:_contentView2];
        
        _contentView1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        _contentView2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        
        
        //左边评论按钮配置
        CGFloat pinlunX = (_contentView1.frame.size.width/2.0)-12;
        CGFloat pinlunY = (_contentView1.frame.size.height/2.0)-6;
        UIImageView *pinlunImage = [[UIImageView alloc] initWithFrame:CGRectMake(pinlunX, pinlunY, 12, 12)];
        pinlunImage.image=[UIImage imageNamed:@"ic_message"];
        [_contentView1 addSubview:pinlunImage];
        
        self.pingLun = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_contentView1.frame)+5, 5, CGRectGetMidX(_contentView1.frame), 20)];
        self.pingLun.textAlignment = NSTextAlignmentLeft;
        self.pingLun.font = [UIFont boldSystemFontOfSize:12];
        self.pingLun.textColor = PYColor(@"#888888");
        [_contentView1 addSubview:self.pingLun];
        //点击评论手势
        self.tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pingLunAction:)];
        [self.contentView1 addGestureRecognizer:_tap1];
        
        
        //右边点赞按钮配置
        CGRect zanImageframe = CGRectMake((_contentView1.frame.size.width)/2.0-12, pinlunY, 12, 12);
        self.dianZanImage = [[UIImageView alloc] initWithFrame:zanImageframe];
        _dianZanImage.image = [UIImage imageNamed:@"ic_like"];
        [_contentView2 addSubview:_dianZanImage];
        
        
        self.dianZan = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dianZanImage.frame)+5, 5, CGRectGetMidX(_contentView1.frame), 20)];
        self.dianZan.textAlignment = NSTextAlignmentLeft;
        self.dianZan.font = [UIFont boldSystemFontOfSize:12];
        self.dianZan.textColor = PYColor(@"#888888");
        [_contentView2 addSubview:self.dianZan];
        
        
    }
    return self;
}

#pragma mark 评论调用的方法

- (void)pingLunAction:(UITapGestureRecognizer *)sender {
    [self.delegate paseUserId:self.noteOwnerId AndNoteId:self.noteId];
}







@end
