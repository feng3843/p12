//
//  HomeImageCell.m
//  FlashTag
//
//  Created by 夏雪 on 15/8/27.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "HomeImageCell.h"
#import "NSString+Extensions.h"
#import "CMData.h"
#import "SDImageView+SDWebCache.h"
@interface HomeImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation HomeImageCell

- (void)awakeFromNib {
//    self.imageView.layer.borderWidth = 3;
//    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
}

-(void)setTagModel:(TagModel *)tagModel
{
    _tagModel = tagModel;
    
    self.titleLabel.text = tagModel.tagName;

    NSString *userId = [tagModel.userId get2Subs];
    NSString *url = [[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_1.jpg",userId,tagModel.noteId]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
    
}
@end
