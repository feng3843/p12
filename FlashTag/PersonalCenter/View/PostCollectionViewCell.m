//
//  PostCollectionViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  展示货位cell

#import "PostCollectionViewCell.h"

@implementation PostCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PYColor(@"ffffff");
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = kCalculateH(10);
        self.layer.borderWidth = kCalculateH(0.5);
        self.layer.borderColor = PYColor(@"d0d0d0").CGColor;
    }
    return self;
}

//帖子和收藏页面图片
- (UIImageView *)postImageView
{
    if (!_postImageView) {
        self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kCalculateV(179))];
        _postImageView.clipsToBounds  = YES;
        _postImageView.contentMode =  UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_postImageView];
    }
    return _postImageView;
}

//评论按钮
- (UIButton *)commentButton
{
    if (!_commentButton) {
        self.commentButton = [PostLikesButton buttonWithType:UIButtonTypeSystem];
        _commentButton.frame = CGRectMake(0, self.bounds.size.height - kCalculateV(30), self.bounds.size.width / 2, kCalculateV(30));
        
        _commentButton.tagImage.image = [UIImage imageNamed:@"ic_message"];
        [self.contentView addSubview:_commentButton];
        

        //竖线
        UIView *vDivide = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(71.5), self.bounds.size.height - kCalculateV(26), kCalculateH(1), kCalculateV(22))];
        vDivide.backgroundColor = PYColor(@"f0f0f0");
        [self.contentView addSubview:vDivide];
    }
    return _commentButton;
}

//收藏按钮
- (UIButton *)collectButton
{
    if (!_collectButton) {
        self.collectButton = [PostLikesButton buttonWithType:UIButtonTypeSystem];
        _collectButton.frame = CGRectMake(self.bounds.size.width / 2, self.bounds.size.height - kCalculateV(30), self.bounds.size.width / 2, kCalculateV(30));
    
        _collectButton.tagImage.image = [UIImage imageNamed:@"ic_like"];
        
        [self.contentView addSubview:_collectButton];
        
    }
    return _collectButton;
    
}



@end
