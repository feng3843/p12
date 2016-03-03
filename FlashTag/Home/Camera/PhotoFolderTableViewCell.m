//
//  PhotoFolderTableViewCell.m
//  test
//
//  Created by py on 15/8/31.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import "PhotoFolderTableViewCell.h"
#import "UIView+AutoLayout.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "PYAllCommon.h"
@interface PhotoFolderTableViewCell()
@property(nonatomic,weak)UIImageView *image;
@property(nonatomic,weak)UILabel *folderName;

@property(nonatomic ,weak)UILabel *imageCount;

@end
@implementation PhotoFolderTableViewCell

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
        
        
        CGFloat imageX = 10 *rateW;
        CGFloat imageY = 5 *rateH;
        CGFloat imageWH = 50 *rateW;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageWH, imageWH)];
        image.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:image];
        self.image = image;
        
        CGFloat folderNameX = 82 *rateH;
        CGFloat folderNameY = 0;
        UILabel *folderName = [[UILabel alloc]init];
        folderName.font = PYSysFont(15 *rateH);
        folderName.textColor = PYColor(@"222222");
        self.folderName = folderName;
        folderName.text = @"相机胶卷";
        [self.contentView addSubview:folderName];
        [folderName autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:folderNameX];
        [folderName autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:folderNameY];
        [folderName autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0];
        UILabel *imageCount = [[UILabel alloc]init];
        imageCount.text = @"(981)";
        imageCount.font = PYSysFont(15 *rateH);
        imageCount.textColor = PYColor(@"222222");
        self.imageCount = imageCount;
        [self.contentView addSubview:imageCount];
        
        [imageCount autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:folderName];
        [imageCount autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:folderNameY];
        [imageCount autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0];
        
        
        
    }
    return self;
}
- (void)setPhotoFolderModel:(PhotoFolderModel *)photoFolderModel
{
    _photoFolderModel = photoFolderModel;
    self.image.image = photoFolderModel.posterImage;
    self.folderName.text =  photoFolderModel.name;
    self.imageCount.text = [NSString stringWithFormat:@"(%@)",photoFolderModel.count];
}
@end
