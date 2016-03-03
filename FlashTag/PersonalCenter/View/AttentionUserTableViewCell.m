//
//  AttentionUserTableViewCell.m
//  11111111111111111111
//
//  Created by MyOS on 15/9/3.
//  Copyright (c) 2015年 MyOS. All rights reserved.
//  关注和粉丝页面自定义cell

#import "AttentionUserTableViewCell.h"

#import "LibCM.h"
#import "CommonInterface.h"

@implementation AttentionUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addSubviews
{
    CGFloat with = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imageSize = kCalculateV(40);
    self.userHeardImage = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(12), imageSize, imageSize)];
    self.userHeardImage.layer.masksToBounds = YES;
    self.userHeardImage.layer.cornerRadius = imageSize/2;
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHeardImage.frame) + kCalculateH(15), CGRectGetMinY(self.userHeardImage.frame) + kCalculateV(5), 150, kCalculateV(15))];
    self.userName.font = [UIFont systemFontOfSize:kCalculateH(14)];
    self.userName.textColor = PYColor(@"222222");
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userName.frame), CGRectGetMaxY(self.userName.frame), CGRectGetWidth(self.userName.frame), kCalculateV(16))];
    self.infoLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.infoLabel.textColor = PYColor(@"999999");
    
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.attentionButton.frame = CGRectMake(with - kCalculateH(84), kCalculateV(18), kCalculateH(69), kCalculateV(27));
    self.attentionButton.layer.masksToBounds = YES;
    self.attentionButton.layer.cornerRadius = kCalculateH(4);
    
    [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionButton setTitle:@"已关注" forState:UIControlStateSelected];
    self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.attentionButton.titleLabel.textColor = PYColor(@"ffffff");
    self.attentionButton.backgroundColor = PYColor(@"cccccc");
    self.attentionButton.selected = YES;
    
    [self.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.userHeardImage];
    [self addSubview:self.userName];
    [self addSubview:self.infoLabel];
    [self addSubview:self.attentionButton];
}

#pragma mark-

-(void)setFollowedsModel:(FollowedUserModel *)followedsModel{
    _followedsModel=followedsModel;
    
    NSString *imagePath=[LibCM getUserAvatarByUserID:_followedsModel.userId];
    [self.userHeardImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
    self.userName.text=_followedsModel.userDisplayName;
    self.infoLabel.text=[NSString stringWithFormat:@"帖子%@个，粉丝%@个",_followedsModel.noteCount,_followedsModel.followeds];
}

- (void)attentionButtonAction:(UIButton *)sender
{
    if ([[CMData getUserId] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"登录之后才能操作!"];
    }else{

    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = PYColor(@"cccccc");
    }else{
        sender.backgroundColor = PYColor(@"ee5748");
    }
    
    [self callingInterfaceAttention:sender.selected];
    }
}

- (void)callingInterfaceAttention:(BOOL)pIsAttention
{
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"attention":(pIsAttention? @"yes":@"no"),
                            @"attentionType":@(2),
                            @"attentionObject":_followedsModel.userId
                            };
    
    [CommonInterface callingInterfaceAttention:param succeed:^{}];
}

#pragma mark-

@end
