//
//  NotePraiseView.m
//  FlashTag
//
//  Created by py on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NotePraiseView.h"
#import "NoteConst.h"
#import "UIView+AutoLayout.h"
#import "LibCM.h"
@interface NotePraiseView()
@property(nonatomic,weak)UILabel *likeCount;
@property(nonatomic,weak)UILabel *commentsCount;
@end
@implementation NotePraiseView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableArray *)notePraisedUser
{
    if (_notePraisedUser == nil) {
        _notePraisedUser = [NSMutableArray array];
    }
    return _notePraisedUser;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, 0.5 *rateH)];
        line.backgroundColor = PYColor(@"cccccc");
        [self.contentView addSubview:line];
        [self setupTop];
       // [self setupImage];
        UIView *bottomBtn = [[UIView alloc]initWithFrame:CGRectMake(0, 81.5 *rateH, fDeviceWidth, 0.5 *rateH)];
        bottomBtn.backgroundColor = PYColor(@"cccccc");
        [self.contentView addSubview:bottomBtn];
    }
    return self;
    
}

- (void)setupTop
{
    CGFloat SpaceY = 16 *rateH;
    CGFloat heigh = 12 * rateH;
    UILabel *totallable = [[UILabel alloc]init];
    totallable.text = @"总共有";
    totallable.font = notePraiseFont;
    totallable.textColor = notePraiseTextColor;
    [self.contentView addSubview:totallable];
    /** 约束*/
    [totallable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:PYSpaceX];
    [totallable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:SpaceY];
    [totallable autoSetDimension:ALDimensionHeight toSize:heigh];
    
    
    UILabel *likeCount = [[UILabel alloc]init];
    likeCount.font = PYBoldSysFont(12 *rateH);
    likeCount.textColor = PYColor(@"f24949");
    likeCount.text = @"153";
    [self.contentView addSubview:likeCount];
    self.likeCount = likeCount;
    /** 约束*/
    [likeCount autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:totallable];
    [likeCount autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:SpaceY];
    [likeCount autoSetDimension:ALDimensionHeight toSize:heigh];
    
    UILabel *zan = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 30, heigh)];
    zan.text = @"个赞, ";
    zan.font = notePraiseFont;
    zan.textColor = notePraiseTextColor;
    [self.contentView addSubview:zan];
    /** 约束*/
    [zan autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:likeCount];
    [zan autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:SpaceY];
    [zan autoSetDimension:ALDimensionHeight toSize:heigh];
    UILabel *commentsCount = [[UILabel alloc]init];
    commentsCount.font = PYBoldSysFont(12 *rateH);
    commentsCount.textColor = PYColor(@"f24949");
    commentsCount.text = @"5";
    [self.contentView addSubview:commentsCount];
    self.commentsCount = commentsCount;
    /** 约束*/
    [commentsCount autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:zan];
    [commentsCount autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:SpaceY];
    [commentsCount autoSetDimension:ALDimensionHeight toSize:heigh];
    
    UILabel *commentLable = [[UILabel alloc]init];
    commentLable.text = @"条评论";
    commentLable.font = notePraiseFont;
    commentLable.textColor = notePraiseTextColor;
    [self.contentView addSubview:commentLable];
    
    /** 约束*/
    [commentLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:commentsCount];
    [commentLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:SpaceY];
    [commentLable autoSetDimension:ALDimensionHeight toSize:heigh];
}

- (void)setupImage
{
   // PYLog(@"%@",self.notePraisedUser[0]);
    NSInteger count = self.notePraisedUser.count;
    if (count > 0) {
        NSMutableArray *item = [NSMutableArray array];
//        if ([self.notePraisedUser[0] isEqualToString: @""]) {
//            return;
//        }
        [item addObjectsFromArray:self.notePraisedUser];
        CGFloat imageY = 40 * rateH;
        for (int i = 0; i < item.count ; i++) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(noteDetailSpace + (notePraiseImageWH + notePraiseImageSpace) * i, imageY, notePraiseImageWH, notePraiseImageWH)];
            [image sd_setImageWithURL:[NSURL URLWithString:[LibCM getUserAvatarByUserID:item[i]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
         //   image.image = [UIImage imageNamed:@"img_default_user"];
            image.layer.cornerRadius = notePraiseImageWH * 0.5;
            image.clipsToBounds = YES;
            [self.contentView addSubview:image];
        }
    }

}

- (void)setLikes:(NSNumber *)likes
{
    _likes = likes;
    self.likeCount.text = [NSString stringWithFormat:@"%@",likes];
}

- (void)setComments:(NSNumber *)comments
{
    _comments = comments;
    self.commentsCount.text = [NSString stringWithFormat:@"%@",comments];
    [self setupImage];
}


@end
