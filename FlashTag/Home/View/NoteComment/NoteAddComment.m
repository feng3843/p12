//
//  NoteAddComment.m
//  FlashTag
//
//  Created by py on 15/8/30.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NoteAddComment.h"
#import "PYAllCommon.h"
@implementation NoteAddComment

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
        
//        UITextView *commenText2 = [[UITextView alloc]init];
//        UITextField *commentText = [[UITextField alloc]init];
//        commentText.text = @"添加一条评论...";
//        commentText.frame =  CGRectMake(PYSpaceX, 20, fDeviceWidth - 2 * PYSpaceX, 44);
//        commentText.borderStyle = UITextBorderStyleLine;
//        [self.contentView addSubview:commentText];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, 0.5 *rateH)];
        line.backgroundColor = PYColor(@"cccccc");
        [self.contentView addSubview:line];
        
        UIButton *addComment = [[UIButton alloc]initWithFrame:CGRectMake(15 *rateW, 14.5 *rateH, fDeviceWidth - 2 * 15 *rateW, 31 *rateH)];
        [addComment setTitle:@"添加一条评论..." forState:UIControlStateNormal];
        [addComment setTitleColor:PYColor(@"acacac") forState:UIControlStateNormal];
        addComment.titleLabel.font = PYSysFont(12*rateH);
        addComment.layer.cornerRadius = 4*rateH;
        addComment.layer.borderColor = PYColor(@"cccccc").CGColor;
        addComment.backgroundColor = PYColor(@"f5f5f5");
        addComment.layer.borderWidth = 0.5 * rateH;
        [addComment addTarget:self action:@selector(addCommentClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addComment];

        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5*rateH, fDeviceWidth, 0.5 *rateH)];
        line2.backgroundColor = PYColor(@"cccccc");
        [self.contentView addSubview:line2];
        
        
        
    }
    return self;
    
}

- (void)addCommentClick
{
    
  if([self.delegate respondsToSelector:@selector(addComment)])
  {
      [self.delegate addComment];
  }
}


@end
