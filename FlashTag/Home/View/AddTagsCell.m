//
//  AddTagsCell.m
//  FlashTag
//
//  Created by py on 15/9/8.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "AddTagsCell.h"
#import "PYAllCommon.h"

#define btnMargin 16 * rateH
#define btnH 40 *rateH
#define btnColor PYColor(@"666666")

@interface AddTagsCell()
@property(nonatomic,weak)UIButton *oneBtn;
@property(nonatomic,weak)UIButton *twoBtn;
@property(nonatomic,weak)UIButton *threeBtn;
@property(nonatomic,weak)UIButton *fourBtn;
@end
@implementation AddTagsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddTag:(NSString *)addTag
{
    _addTag = addTag;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *oneBtn = [[UIButton alloc]initWithFrame:CGRectMake(PYSpaceX, btnMargin, 100, btnH)];
        oneBtn.layer.borderWidth = 1;
        oneBtn.layer.cornerRadius = 8;
        oneBtn.layer.borderColor = btnColor.CGColor;
        [oneBtn setTitle:@"心情很美丽" forState:UIControlStateNormal];
        [oneBtn setTitleColor:btnColor forState:UIControlStateNormal];
        [self addSubview:oneBtn];
        self.oneBtn = oneBtn;
        
        UIButton *twoBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, btnMargin, 100, btnH)];
        twoBtn.layer.borderWidth = 1;
        twoBtn.layer.cornerRadius = 8;
        twoBtn.layer.borderColor = btnColor.CGColor;
        [twoBtn setTitle:@"心情很美丽" forState:UIControlStateNormal];
        [twoBtn setTitleColor:btnColor forState:UIControlStateNormal];
        [self addSubview:twoBtn];
        self.twoBtn = twoBtn;
        
        UIButton *threeBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, btnMargin, 100, btnH)];
        threeBtn.layer.borderWidth = 1;
        threeBtn.layer.cornerRadius = 8;
        threeBtn.layer.borderColor = btnColor.CGColor;
        [threeBtn setTitle:@"心情很美丽" forState:UIControlStateNormal];
        [threeBtn setTitleColor:btnColor forState:UIControlStateNormal];
        [self addSubview:threeBtn];
        self.threeBtn = threeBtn;
        
        UIButton *fourBtn = [[UIButton alloc]initWithFrame:CGRectMake(PYSpaceX,2 * btnMargin +btnH  , 100, btnH)];
        fourBtn.layer.borderWidth = 1;
        fourBtn.layer.cornerRadius = 8;
        fourBtn.layer.borderColor = btnColor.CGColor;
        [fourBtn setTitle:@"心情很美丽" forState:UIControlStateNormal];
        [fourBtn setTitleColor:btnColor forState:UIControlStateNormal];
        [self addSubview:fourBtn];
        self.fourBtn = fourBtn;
    }
    return self;
}
@end
