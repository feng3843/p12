//
//  MyAttentionCollectionViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  我的关注标签页面自定义cell

#import "MyAttentionCollectionViewCell.h"

#import "LibCM.h"

@implementation MyAttentionCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        self.backgroundColor = PYColor(@"ffffff");
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = kCalculateH(4);
    }
    return self;
}


- (void)addSubviews
{
    
    CGRect rect=self.contentView.frame;
    backGroundImageView=[[UIImageView alloc] initWithFrame:rect];
    [self.contentView addSubview:backGroundImageView];
    
    

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCalculateH(65), kCalculateH(65))];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.contentView addSubview:view];
    
    
    self.taglabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(8), kCalculateV(15), self.bounds.size.width - kCalculateH(16), self.bounds.size.height - kCalculateV(30))];
    _taglabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    _taglabel.textColor = PYColor(@"ffffff");
    _taglabel.textAlignment = NSTextAlignmentCenter;
    _taglabel.numberOfLines = 2;
    
    [self.contentView addSubview:_taglabel];
}

#pragma mark-

-(void)setFollowedTagsModel:(FollowedTagsModel *)followedTagsModel{
    _followedTagsModel=followedTagsModel;
    
    NSString *imagePath=[LibCM getPostImgWithUserID:_followedTagsModel.noteOwnerId PostID:_followedTagsModel.noteId];
    [backGroundImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"headImage.jpeg"]];
    
    self.taglabel.text=_followedTagsModel.tagName;
    
}
//
//- (void)attentionButtonAction:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        sender.backgroundColor = PYColor(@"ee5748");
//    }else{
//        sender.backgroundColor = PYColor(@"cccccc");
//    }
//    
//    [self callingInterfaceAttention:sender.selected];
//}
//
//- (void)callingInterfaceAttention:(BOOL)pIsAttention
//{
//    NSDictionary *param = @{@"token":[CMData getToken],
//                            @"userId":@([CMData getUserIdForInt]),
//                            @"attention":(pIsAttention? @"yes":@"no"),
//                            @"attentionType":@(2),
//                            @"attentionObject":_followedsModel.userId
//                            };
//    
//    [CommonInterface callingInterfaceAttention:param succeed:^{}];
//}

#pragma mark-

@end
