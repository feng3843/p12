//
//  NoteMoreComment.m
//  FlashTag
//
//  Created by py on 15/8/30.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NoteMoreComment.h"
#import "PYAllCommon.h"
@implementation NoteMoreComment

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
        
        
        moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setTitle:@"加载更多评论" forState:UIControlStateNormal];
        [self.contentView addSubview:moreBtn];
//        moreBtn.backgroundColor = [UIColor redColor];
        moreBtn.frame = self.contentView.frame;
        [moreBtn setTitleColor:PYColor(@"acacac") forState:UIControlStateNormal];
        moreBtn.titleLabel.font = PYSysFont(10 *rateH);
        [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
    
}

- (void)moreBtnClick
{
    if ([self.delegate respondsToSelector:@selector(LoadMoreComment)]) {
        [self.delegate LoadMoreComment];
    }
}

-(void)setHidden4MoreBtn:(BOOL)hidden{
    moreBtn.hidden=hidden;
}
@end
