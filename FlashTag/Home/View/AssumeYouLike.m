//
//  AssumeYouLike.m
//  FlashTag
//
//  Created by py on 15/8/30.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  猜你喜欢  

#import "AssumeYouLike.h"
#import "PYAllCommon.h"
#import "LibCM.h"
@interface AssumeYouLike()

@property(nonatomic,weak)UILabel *likelabel;
@property(nonatomic,weak)UIView *bgView;

@property(nonatomic ,weak) UIImageView *leftImage;
@property(nonatomic ,weak)UIButton *leftCommentBtn;
@property(nonatomic ,weak)UIButton *leftPraiseBtn;

@property(nonatomic ,weak) UIImageView *rightImage;
@property(nonatomic ,weak) UIButton *rightCommentBtn;
@property(nonatomic ,weak)UIButton *rightPraiseBtn;

@end
@implementation AssumeYouLike


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        
        UILabel *likelabel = [[UILabel alloc]initWithFrame:CGRectMake(16 *rateW, 0, 200, 30 *rateH)];
        likelabel.text = @"猜你喜欢";
        likelabel.font = PYSysFont(13 *rateW);
        likelabel.textColor = PYColor(@"999999");
        [self.contentView addSubview:likelabel];
        self.likelabel = likelabel;
        
        CGFloat bgViewW = fDeviceWidth ;
        CGFloat bgViewH = 210.0f *rateH;
        CGFloat imageW = (fDeviceWidth - 3 *PYSpaceX) * 0.5;
        CGFloat imageH = 179.0f *rateH;
        CGFloat btnW = imageW * 0.5;
        CGFloat btnH = bgViewH - imageH;
        UIColor *btnTextColor = PYColor(@"999999");
        
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bgViewW, bgViewH)];
       // bgView.backgroundColor = PYColor(@"ffffff");
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(10 *rateW, 0, imageW, bgViewH)];
        leftView.layer.cornerRadius = 5 *rateW;
        leftView.layer.borderWidth = 0.5 *rateW;
        leftView.layer.borderColor = PYColor(@"d0d0d0").CGColor;
        leftView.clipsToBounds = YES;
        leftView.backgroundColor = PYColor(@"ffffff");
        [bgView addSubview:leftView];
      
        UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        leftImage.image = [UIImage imageNamed:@"Thome.png"];
        [leftView addSubview:leftImage];
        leftImage.userInteractionEnabled = YES;
        self.leftImage = leftImage;
        UIButton *leftCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftCommentBtn.frame = CGRectMake(0, imageH, btnW, btnH);
        //leftCommentBtn.backgroundColor = [UIColor redColor];
        [leftCommentBtn setImage:[UIImage imageNamed:@"ic_message"] forState:UIControlStateNormal];
        [leftCommentBtn setTitle:@"1" forState:UIControlStateNormal];
        [leftCommentBtn setTitleColor:btnTextColor forState:UIControlStateNormal];
        leftCommentBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13 *rateH];
        leftCommentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9 *rateW);
        [leftCommentBtn addTarget:self action:@selector(leftCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:leftCommentBtn];
        self.leftCommentBtn = leftCommentBtn;
    
        
        UIButton *leftPraiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftPraiseBtn.frame = CGRectMake(btnW , imageH, btnW, btnH);
        //leftPraiseBtn.backgroundColor = [UIColor yellowColor];
        [leftPraiseBtn setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
        
        [leftPraiseBtn setTitle:@"2" forState:UIControlStateNormal];
        [leftPraiseBtn setTitleColor:btnTextColor forState:UIControlStateNormal];
        leftPraiseBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13 *rateH];
        leftPraiseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9 *rateW);
        [leftView addSubview:leftPraiseBtn];
        [leftPraiseBtn addTarget:self action:@selector(leftPraiseBtnClick) forControlEvents:UIControlEventTouchUpInside];

        self.leftPraiseBtn = leftPraiseBtn;
        
        
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(btnW, imageH + 4 *rateH, 0.5 *rateW, 22 *rateW)];
        leftLine.backgroundColor = PYColor(@"f0f0f0");
        [leftView addSubview:leftLine];
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(10 *rateW + (10 *rateW  + imageW), 0, imageW, bgViewH)];
        rightView.layer.cornerRadius = 5 *rateW;
        rightView.layer.borderWidth = 0.5 *rateW;
        rightView.layer.borderColor = PYColor(@"d0d0d0").CGColor;
        rightView.backgroundColor = PYColor(@"ffffff");
        rightView.clipsToBounds = YES;
        [bgView addSubview:rightView];
      
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        rightImage.image = [UIImage imageNamed:@"Thome.png"];
        rightImage.userInteractionEnabled = YES;
        [rightView addSubview:rightImage];
        self.rightImage = rightImage;
        
        UIButton *rightCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightCommentBtn.frame = CGRectMake(0, imageH, btnW, btnH);
     //   rightCommentBtn.backgroundColor = [UIColor redColor];
        [rightCommentBtn setTitle:@"1" forState:UIControlStateNormal];
        [rightCommentBtn setImage:[UIImage imageNamed:@"ic_message"] forState:UIControlStateNormal];
        rightCommentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9 *rateW);
        rightCommentBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13 *rateH];
        [rightCommentBtn setTitleColor:btnTextColor forState:UIControlStateNormal];
        [rightCommentBtn addTarget:self action:@selector(rightCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:rightCommentBtn];
        self.rightCommentBtn  = rightCommentBtn;
        
        UIButton *rightPraiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightPraiseBtn.frame = CGRectMake(btnW , imageH, btnW, btnH);
     //   rightPraiseBtn.backgroundColor = [UIColor yellowColor];
        [rightPraiseBtn setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
        [rightPraiseBtn setTitle:@"2" forState:UIControlStateNormal];
        rightPraiseBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13 *rateH];
        rightPraiseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9 *rateW);
        [rightPraiseBtn setTitleColor:btnTextColor forState:UIControlStateNormal];
        [rightView addSubview:rightPraiseBtn];
        self.rightPraiseBtn = rightPraiseBtn;
        [rightPraiseBtn addTarget:self action:@selector(rightPraiseBtnClick) forControlEvents:UIControlEventTouchUpInside];

        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(btnW, imageH + 4 *rateH, 0.5 *rateW, 22 *rateW)];
        rightLine.backgroundColor = PYColor(@"f0f0f0");
        [rightView addSubview:rightLine];
//        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // leftBtn.backgroundColor = [UIColor redColor];
        leftBtn.frame = CGRectMake(0, 0, imageW, imageH);
        [leftView addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchDown];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      //  rightBtn.backgroundColor = [UIColor redColor];
        rightBtn.frame = CGRectMake(0, 0, imageW, imageH);
        [rightView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (void)setIsFirst:(BOOL)isFirst
{
    _isFirst = isFirst;
    CGFloat likeH = 0.0f;
    CGFloat bgViewH =220.0f *rateH;
    if (isFirst) {
        self.likelabel.hidden = NO;
          likeH = 30 *rateH;
          self.bgView.frame = CGRectMake(0,likeH, fDeviceWidth, bgViewH);
     }else
     {
         self.likelabel.hidden = YES;
         likeH = 10 *rateH;
         self.bgView.frame = CGRectMake(0,likeH, fDeviceWidth, bgViewH);
     }
    
}
#pragma mark - 点击事件
- (void)leftBtnClick
{
   
    if ([self.delegate respondsToSelector:@selector(noteClick:withUserId:)]) {
        [self.delegate noteClick:self.NoteInfoModelFirst.noteId withUserId:self.NoteInfoModelFirst.userId];
    }
    
}

- (void)rightBtnClick
{
    if ([self.delegate respondsToSelector:@selector(noteClick:withUserId:)]) {
        [self.delegate noteClick:self.NoteInfoModelSec.noteId withUserId:self.NoteInfoModelSec.userId];
    }
}

// 左边评论
- (void)leftCommentBtnClick
{
    if ([self.delegate respondsToSelector:@selector(CommentBtnClick:withUserId:)]) {
        [self.delegate CommentBtnClick:self.NoteInfoModelFirst.noteId withUserId:self.NoteInfoModelFirst.userId];
    }
}
// 右边评论
- (void)rightCommentBtnClick
{
    if ([self.delegate respondsToSelector:@selector(CommentBtnClick:withUserId:)]) {
        [self.delegate CommentBtnClick:self.NoteInfoModelSec.noteId withUserId:self.NoteInfoModelSec.userId];
    }
}
// 左边点赞
- (void)leftPraiseBtnClick
{
        NSDictionary *param = @{@"token":[CMData getToken],
                                @"userId":@([CMData getUserIdForInt]),
                                @"noteId":self.NoteInfoModelFirst.noteId,
                                @"targetId":self.NoteInfoModelFirst.userId,
                                @"isLiked":self.leftPraiseBtn.selected?@"no":@"yes"};
    
        //    int likeCount = [self.praiseBtn.currentTitle intValue] ;
        [CommonInterface callingInterfacePraise:param succeed:^{
    
            //   [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
            if (self.leftPraiseBtn.selected) {
              self.NoteInfoModelFirst.likes = @([self.NoteInfoModelFirst.likes  intValue] - 1) ;
                //  [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
                self.leftPraiseBtn.selected = NO;
                self.leftPraiseBtn.alpha = 0.4;
                [self.leftPraiseBtn setTitle:[NSString stringWithFormat:@"点赞%@",self.NoteInfoModelFirst.likes ] forState:UIControlStateNormal];
            }else
            {
    
                [SVProgressHUD showSuccessWithStatus:@"积分+1"];
                self.NoteInfoModelFirst.likes = @([self.NoteInfoModelFirst.likes  intValue] + 1) ;
                self.leftPraiseBtn.selected = YES;
                self.leftPraiseBtn.alpha = 0.8;
                [self.leftPraiseBtn setTitle:[NSString stringWithFormat:@"点赞%@",self.NoteInfoModelFirst.likes ] forState:UIControlStateNormal];
            }
        }];
}
// 右边点赞
- (void)rightPraiseBtnClick
{
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"noteId":self.NoteInfoModelSec.noteId,
                            @"targetId":self.NoteInfoModelSec.userId,
                            @"isLiked":self.rightPraiseBtn.selected?@"no":@"yes"};
    
    //    int likeCount = [self.praiseBtn.currentTitle intValue] ;
    [CommonInterface callingInterfacePraise:param succeed:^{
        
        //   [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
        if (self.rightPraiseBtn.selected) {
            self.NoteInfoModelSec.likes = @([self.NoteInfoModelSec.likes  intValue] - 1) ;
            //  [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
            self.rightPraiseBtn.selected = NO;
           // self.rightPraiseBtn.alpha = 0.4;
            [self.rightPraiseBtn setTitle:[NSString stringWithFormat:@"点赞%@",self.NoteInfoModelSec.likes ] forState:UIControlStateNormal];
        }else
        {
            
            [SVProgressHUD showSuccessWithStatus:@"积分+1"];
            self.NoteInfoModelSec.likes = @([self.NoteInfoModelSec.likes  intValue] + 1) ;
            self.rightPraiseBtn.selected = YES;
          //  self.rightPraiseBtn.alpha = 0.8;
            [self.rightPraiseBtn setTitle:[NSString stringWithFormat:@"点赞%@",self.NoteInfoModelSec.likes ] forState:UIControlStateNormal];
        }
    }];
}


- (void)setNoteInfoModelFirst:(NoteInfoModel *)NoteInfoModelFirst
{
    _NoteInfoModelFirst = NoteInfoModelFirst;
    
    [self.leftImage  sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:NoteInfoModelFirst.userId PostID:NoteInfoModelFirst.noteId]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
    
    [self.leftCommentBtn setTitle:[NSString stringWithFormat:@"%@",NoteInfoModelFirst.comments] forState:UIControlStateNormal];
    [self.leftPraiseBtn setTitle:[NSString stringWithFormat:@"%@",NoteInfoModelFirst.likes] forState:UIControlStateNormal];
    self.leftPraiseBtn.alpha = NoteInfoModelFirst.isLiked == YES?0.4:0.8;
    self.leftPraiseBtn.selected = NoteInfoModelFirst.isLiked;
    
}

- (void)setNoteInfoModelSec:(NoteInfoModel *)NoteInfoModelSec
{
    _NoteInfoModelSec = NoteInfoModelSec;
    [self.rightImage  sd_setImageWithURL:[NSURL URLWithString:[LibCM getPostImgWithUserID:NoteInfoModelSec.userId PostID:NoteInfoModelSec.noteId]] placeholderImage:[UIImage imageNamed:@"img_default_note"]];
    
    [self.rightCommentBtn setTitle:[NSString stringWithFormat:@"%@",NoteInfoModelSec.comments] forState:UIControlStateNormal];
    [self.rightPraiseBtn setTitle:[NSString stringWithFormat:@"%@",NoteInfoModelSec.likes] forState:UIControlStateNormal];
    self.rightPraiseBtn.selected = NoteInfoModelSec.isLiked;
   // self.rightPraiseBtn.alpha = NoteInfoModelSec.isLiked == YES?0.4:0.8;
    self.rightPraiseBtn.selected = NoteInfoModelSec.isLiked;
}


@end
