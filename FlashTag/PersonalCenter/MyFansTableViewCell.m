//
//  MyFansTableViewCell.m
//  FlashTag
//
//  Created by MyOS on 15/9/22.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "MyFansTableViewCell.h"

#import "LibCM.h"
#import "CommonInterface.h"

@implementation MyFansTableViewCell

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
    self.userHeardImage = [[UIImageView alloc] initWithFrame:CGRectMake(kCalculateH(15), kCalculateV(10), imageSize, imageSize)];
    self.userHeardImage.layer.masksToBounds = YES;
    self.userHeardImage.layer.cornerRadius = imageSize/2;
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHeardImage.frame) + kCalculateH(15), CGRectGetMinY(self.userHeardImage.frame) + kCalculateV(5), 150, kCalculateV(15))];
    self.userName.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.userName.textColor = PYColor(@"222222");
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userName.frame), CGRectGetMaxY(self.userName.frame), CGRectGetWidth(self.userName.frame), kCalculateV(16))];
    self.infoLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.infoLabel.textColor = PYColor(@"999999");
    
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.attentionButton.frame = CGRectMake(with - kCalculateH(84), kCalculateV(16), kCalculateH(69), kCalculateV(27));
    self.attentionButton.layer.masksToBounds = YES;
    self.attentionButton.layer.cornerRadius = kCalculateH(4);
    
    [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionButton setTitle:@"已关注" forState:UIControlStateSelected];
    self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    self.attentionButton.titleLabel.textColor = PYColor(@"ffffff");
//    self.attentionButton.backgroundColor = PYColor(@"cccccc");
    
    
    [self addSubview:self.userHeardImage];
    [self addSubview:self.userName];
    [self addSubview:self.infoLabel];
    [self addSubview:self.attentionButton];
}

#pragma mark-

-(void)setMyFansModel:(FollowedUserModel *)myFansModel{
    _myFansModel=myFansModel;
    
    NSString *imagePath=[LibCM getUserAvatarByUserID:_myFansModel.userId];
    [self.userHeardImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
    self.userName.text=_myFansModel.userDisplayName;
    self.infoLabel.text=[NSString stringWithFormat:@"帖子%@个，粉丝%@个",_myFansModel.noteCount,_myFansModel.followeds];
    
    if ([_myFansModel.isAttention isEqualToString:@"yes"]) {
        self.attentionButton.selected = YES;//cccccc  ee5748
        self.attentionButton.backgroundColor = PYColor(@"cccccc");
    }else{
        self.attentionButton.selected = NO;
        self.attentionButton.backgroundColor = PYColor(@"ee5748");
    }
    
    
    [self.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)setJingXuanUserModel:(JingXuanUserModel *)jingXuanUserModel{
    _jingXuanUserModel=jingXuanUserModel;
    
    NSString *imagePath=[LibCM getUserAvatarByUserID:_jingXuanUserModel.userId];
    [self.userHeardImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
    self.userName.text=_jingXuanUserModel.userDisplayName;
    self.infoLabel.text=[NSString stringWithFormat:@"帖子%@个，粉丝%@个",_jingXuanUserModel.noteCount,_jingXuanUserModel.followeds];
    
    if ([_jingXuanUserModel.isAttention isEqualToString:@"yes"]) {
        self.attentionButton.selected = YES;
        self.attentionButton.backgroundColor = PYColor(@"cccccc");
    }else{
        self.attentionButton.selected = NO;
        self.attentionButton.backgroundColor = PYColor(@"ee5748");
    }
    
    [self.attentionButton addTarget:self action:@selector(attentionButton222Action:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)attentionButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    if (sender.selected) {
        sender.backgroundColor = PYColor(@"cccccc");
    }else{
        sender.backgroundColor = PYColor(@"ee5748");
    }
    
    [self callingInterfaceAttention:sender.selected];
}

- (void)callingInterfaceAttention:(BOOL)pIsAttention
{
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"attention":(pIsAttention? @"yes":@"no"),
                            @"attentionType":@(2),
                            @"attentionObject":_myFansModel.userId
                            };
    
    [CommonInterface callingInterfaceAttention:param succeed:^{}];
}

#pragma mark-  精选?


- (void)attentionButton222Action:(UIButton *)sender
{
    
    if ([[CMData getUserId] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"登录之后才能操作!"];
    }else{

    sender.selected = !sender.selected;
    
    if ([_jingXuanUserModel.isAttention isEqualToString:@"yes"]) {
        
        _jingXuanUserModel.isAttention = @"no";
    }else{
        _jingXuanUserModel.isAttention = @"yes";
    }

    
    if (sender.selected) {
        sender.backgroundColor = PYColor(@"cccccc");
    }else{
        sender.backgroundColor = PYColor(@"ee5748");
    }
    
    [self callingInterfaceAttention222:sender.selected];
        
        
    }
}

- (void)callingInterfaceAttention222:(BOOL)pIsAttention
{
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"attention":(pIsAttention? @"yes":@"no"),
                            @"attentionType":@(2),
                            @"attentionObject":_jingXuanUserModel.userId
                            };
    
    [CommonInterface callingInterfaceAttention:param succeed:^{
    
//        if (pIsAttention) {
//            _jingXuanUserModel.isAttention
//        }
    
    }];
}

@end
