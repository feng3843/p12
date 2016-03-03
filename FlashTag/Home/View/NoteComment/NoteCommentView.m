//
//  NoteCommentView.m
//  FlashTag
//
//  Created by py on 15/8/29.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  帖子评论

#import "NoteCommentView.h"
#import "NoteConst.h"
#import "UIView+AutoLayout.h"
#import "NoteCommentModel.h"
@interface NoteCommentView()

@property(nonatomic ,weak)UILabel *allComment;
@property(nonatomic,weak)UIImageView *iconImage;
@property(nonatomic,weak)UILabel *userDisplayName;
@property(nonatomic ,weak)UILabel *reply;
@property(nonatomic ,weak)UILabel *targetUserName;
@property(nonatomic ,weak)UILabel *commentTime;

@property(nonatomic ,weak)UILabel *comment;
@property(nonatomic,weak)UIView *bottomLine;

@end
@implementation NoteCommentView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  
        [self setupTop];
    }
    return self;
    
}

- (void)setIsFirst:(BOOL)isFirst
{
    _isFirst = isFirst;
    CGFloat SpaceY = 0;
 
    CGFloat SpaceX = 10 *rateW;
//    CGFloat commentY = 0;
    if (isFirst) {
        CGFloat allcommentY = 16 *rateH;
        SpaceY = 44 *rateH ;
        [self.allComment autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(allcommentY, SpaceX, 0, 0) excludingEdge:ALEdgeBottom];
        [self.allComment autoSetDimension:ALDimensionHeight toSize:13 *rateH];
//        commentY = 44 *rateH;
        self.allComment.hidden = NO;
    }else
    {
        self.allComment.hidden = YES;
        SpaceY = 16 *rateH;
//        commentY = 16 *rateH;
    }

    self.iconImage.frame = CGRectMake(SpaceX, SpaceY, notePraiseImageWH, notePraiseImageWH);
    self.iconImage.layer.cornerRadius = notePraiseImageWH * 0.5;
    self.iconImage.clipsToBounds = YES;
//    CGFloat CommentToImageSpace = 14 *rateW;
//    /** 约束*/
//    [self.userDisplayName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImage withOffset:CommentToImageSpace];
//    [self.userDisplayName autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:commentY];
//    [self.userDisplayName autoSetDimension:ALDimensionHeight toSize:heigh];
    
 
}

//- (void)setIsLast:(BOOL)isLast
//{
//    _isLast = isLast;
//   
//   
//}
- (void)setupTop
{
    UILabel *allComment = [[UILabel alloc]init];
    [self.contentView addSubview:allComment];
//    if (self.isFirst) {
//        allComment.text = @"";
//    }else
//    {
//        allComment.text = @"所有评论";
//    }
    allComment.text = @"所有评论";
    allComment.textColor = noteAllCommentTextColor;
    allComment.font = noteAllCommentFont;
    self.allComment = allComment;
 
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"img_default_user"];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    
    /** 评论人的用户昵称*/
    UILabel *userDisplayName = [[UILabel alloc]init];
    userDisplayName.text = @"奚淑婉";
    userDisplayName.textColor = noteCommentUserTextColor;
    userDisplayName.font = noteCommentUserFont;
    [self.contentView addSubview:userDisplayName];
    self.userDisplayName = userDisplayName;


    /** 回复*/
    UILabel *reply = [[UILabel alloc]init];
    reply.text = @"回复";
    reply.textColor = PYColor(@"f24949");
    reply.font = noteCommentUserFont;
    [self.contentView addSubview:reply];
    self.reply = reply;
  
    
    UILabel *targetUserName = [[UILabel alloc]init];
    targetUserName.text = @"董董5705";
    targetUserName.textColor = noteCommentUserTextColor;
    targetUserName.font = noteCommentUserFont;
    [self.contentView addSubview:targetUserName];
    self.targetUserName = targetUserName;

    
    UILabel *commentTime = [[UILabel alloc]init];
    commentTime.text = @"2015-08-26 14:55";
    commentTime.textColor = PYColor(@"cccccc");
    commentTime.font = PYSysFont(9 *rateH);
//    commentTime.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:commentTime];
    self.commentTime = commentTime;

    
    UILabel *comment = [[UILabel alloc]init];
    comment.textColor = noteCommentTextColor;
    comment.font = noteCommentFont;
    comment.numberOfLines = 0;
    comment.text = @"嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻想嘻嘻嘻嘻嘻嘻嘻嘻嘻夏雪嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻想嘻嘻嘻嘻嘻嘻嘻嘻嘻";
    self.comment = comment;
    [self.contentView addSubview:comment];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 81.5 *rateH, fDeviceWidth, 0.5 *rateH)];
    bottomLine.backgroundColor = PYColor(@"cccccc");
    self.bottomLine = bottomLine;
    [self.contentView addSubview:bottomLine];
    
}

- (void)setCommentModel:(NoteCommentModel *)commentModel
{
    _commentModel = commentModel;

    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"userIcon/icon%@.jpg",commentModel.userId]]] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg" , [CMData getCommonImagePath] , commentModel.userId]] options:SDWebImageDownloaderProgressiveDownload progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        
//        if (image) {
//            
//        }else{
//            image = [UIImage imageNamed:@"img_default_user"];
//        }
//        
//        self.iconImage.image = image;
//        
//    }];
//    
    CGFloat userDisplayNameX = noteCommentX;
    CGFloat userDisplayNameY = 0;
     CGFloat commentY = 0;
    if (self.isFirst) {
        userDisplayNameY = 44 * rateH;
       
    }else
    {
        userDisplayNameY = 16 * rateH;
        
    }
    NSDictionary *userDisplayNameDic = @{NSFontAttributeName: noteCommentFont};
//    CGSize  userDisplayNameSize = [self.userDisplayName.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:userDisplayNameDic context:nil].size;
    
    
    CGFloat commentReplySpace = 5 *rateW;
    self.userDisplayName.text = commentModel.userName;
     CGFloat heigh = 14 * rateH;
    CGRect rect =  [self.userDisplayName.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:userDisplayNameDic context:nil];
     if ([commentModel.targetUserId isEqualToString:commentModel.noteOwnerId]) {
         
         if(rect.size.width >140 *rateW)
         {
           self.userDisplayName.frame = CGRectMake(userDisplayNameX, userDisplayNameY, 140 *rateH, heigh);
         }else
         {
             self.userDisplayName.frame = CGRectMake(userDisplayNameX, userDisplayNameY, rect.size.width, heigh);
         }
         
           [self.reply autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userDisplayName withOffset:commentReplySpace];
        }else
        {
        if(rect.size.width >60 *rateW)
        {
            self.userDisplayName.frame = CGRectMake(userDisplayNameX, userDisplayNameY, 60*rateW, heigh);
                   [self.reply autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userDisplayName withOffset:0];
        }else
        {
            self.userDisplayName.frame = CGRectMake(userDisplayNameX, userDisplayNameY, rect.size.width, heigh);
            [self.reply autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userDisplayName withOffset:commentReplySpace];
        }
            
            
        }
  
    

   
    
    /** 约束*/
  
   // [self.reply autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:commentY];
    [self.reply autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userDisplayName ];
    [self.reply autoSetDimension:ALDimensionHeight toSize:heigh];
  
    /** 约束*/
    [self.targetUserName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.reply withOffset:commentReplySpace];
    [self.targetUserName autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userDisplayName ];
    [self.targetUserName autoSetDimension:ALDimensionHeight toSize:heigh];
    
    CGRect targetUserNameRect =  [commentModel.targetUserName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:userDisplayNameDic context:nil];
    
        if(targetUserNameRect.size.width >60 *rateW)
        {
            [self.targetUserName autoSetDimension:ALDimensionWidth toSize:60 *rateW];

        }else
        {
        [self.targetUserName autoSetDimension:ALDimensionWidth toSize:targetUserNameRect.size.width];
        }
        
    
    
    
    /** 约束*/
    [self.commentTime autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15*rateW];
   [self.commentTime autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userDisplayName ];
    [self.commentTime autoSetDimension:ALDimensionHeight toSize:heigh];
    if ([commentModel.targetUserId isEqualToString:commentModel.noteOwnerId]) {
        self.reply.hidden = YES;
        self.targetUserName.hidden = YES;
    }else
    {
        self.reply.hidden = NO;
        self.targetUserName.hidden = NO;
        self.targetUserName.text = commentModel.targetUserName;
    
    }
 
    self.commentTime.text = commentModel.commentTime;
  
//   CGFloat commentToUserSpace = 5 *rateH;
//
//    [self.comment autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userDisplayName];
//    [self.comment autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:- PYSpaceX];
//    [self.comment autoSetDimension:ALDimensionWidth toSize:commentW];
//    [self.comment autoSetDimension:ALDimensionHeight toSize:commentSize.height];
//    [self.comment autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userDisplayName withOffset:commentToUserSpace];
    CGFloat commentX = noteCommentX;
 //   CGFloat commentY = 0;
    if (self.isFirst) {
        commentY = noteIsFirstCommentY;
    }else
    {
        commentY = noteNoFirstCommnetY;
    }
    
    
    
    NSDictionary *commentDic = @{NSFontAttributeName: noteCommentFont};
    CGFloat commentW = fDeviceWidth - commentX - PYSpaceX;
    CGSize  commentSize = [commentModel.commentContent boundingRectWithSize:CGSizeMake(commentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:commentDic context:nil].size;
    self.comment.frame = CGRectMake(commentX, commentY, commentSize.width, commentSize.height);
    self.comment.text = commentModel.commentContent;
    
    CGFloat bottomLineY = commentY + commentSize.height + 15.5 *rateH;
    
//    if (self.isLast) {
//        self.bottomLine.frame = CGRectMake(0, bottomLineY, fDeviceWidth , 0.5 *rateH);
//    }else
//    {
     self.bottomLine.frame = CGRectMake(15 * rateW, bottomLineY, fDeviceWidth - 30* rateW, 0.5 *rateH);
//    }
// 
    

}
@end
