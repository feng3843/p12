//
//  ContactCell.m
//  CM
//
//  Created by andy on 14/10/28.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import "ContactCell.h"
#import "CMContact.h"
#import "CMData.h"
#import "CMAPI.h"
#import "CMTool.h"
#import "CDCommon.h"
#import "CDSessionManager.h"
#import "NSDate+TimeAgo.h"
#import "UIView+AutoLayout.h"

@implementation ContactCell
{
    UITabBar *tabBar;
    UITabBarItem *item;
}

- (void)awakeFromNib {
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserUnreadmsgnum:) name:NOTIFICATION_SESSION_UPDATED object:nil];
    
    self.avatarImage.layer.cornerRadius = CGRectGetHeight(self.avatarImage.frame)/2;
    self.avatarImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGroup:(NSDictionary *)group{
    _group = group;
    self.titleLabel.text = [_group valueForKey:@"name"];
    self.avatarImage.image = [UIImage imageNamed:@"group"];
}

- (void)setContact:(CMContact *)contact{
    _contact = contact;
    
    self.titleLabel.text = _contact.strName;
    self.detailTitleLabel.text = _contact.strCorpName;

    //加载联系人头像
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg",[CMData getCommonImagePath],_contact.strContactID]] placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
}
- (void)setMsgContact:(CMContact *)contact
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMsgContact:) name:@"CHATLISTUPDATE_BADGE" object:nil];//更新消息条数
    _msgContact = contact;

    if (!tabBar) {
        tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(45, 1, 0, 0)];
        item = [[UITabBarItem alloc] initWithTitle:@"" image:nil tag:0];
        NSArray *array = [[NSArray alloc] initWithObjects:item, nil];
        tabBar.items = array;
        [self.contentView addSubview:tabBar];
        
        [tabBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:35.0];
        [tabBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:(-17.0)];
    }

    self.titleLabel.text = _msgContact.strName;
    self.detailTitleLabel.text = _msgContact.strCorpName;

    self.readTimeLbl.text = [[HandyWay shareHandyWay] getTimeWithStrForSecond:[NSString stringWithFormat:@"%lld",_msgContact.maxMsgTimestamp]];

    //加载联系人头像
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/userIcon/icon%@.jpg",[CMData getCommonImagePath],_msgContact.strContactID]] placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];

    _unReadMsgNum = [[CDSessionManager sharedInstance] getMessageNumForPeerId:_msgContact.strContactID ReadTime:[NSString stringWithFormat:@"%lld",_msgContact.readMsgTimestamp+1]];

    if (!_unReadMsgNum||[@"0" isEqualToString:_unReadMsgNum]||[@"" isEqualToString:_unReadMsgNum]) {
        [tabBar removeFromSuperview];
        tabBar = nil;
        item = nil;
    }
    else
    {
        item.badgeValue = _unReadMsgNum;
    }
}

-(void)updateUserUnreadmsgnum:(NSNotification*)notification
{
    NSDictionary* userinfo = notification.userInfo;
    if ([_msgContact.strContactID isEqualToString:[userinfo objectForKey:@"fromid"]]) {
        NSString* unreadnum = [[CDSessionManager sharedInstance] getMessageNumForPeerId:_msgContact.strContactID ReadTime:[NSString stringWithFormat:@"%lld",_msgContact.readMsgTimestamp]];
        if (![@"" isEqualToString:unreadnum]) {
            item.badgeValue = unreadnum;
            self.detailTitleLabel.text = [userinfo objectForKey:@"message"];
        }
    }
}

@end
