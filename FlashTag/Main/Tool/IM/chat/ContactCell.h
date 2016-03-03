//
//  ContactCell.h
//  CM
//
//  Created by andy on 14/10/28.
//  Copyright (c) 2014年 AventLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "CMContact.h"

@interface ContactCell : SWTableViewCell

@property (strong,nonatomic) CMContact* contact;
@property (strong,nonatomic) CMContact* msgContact;
@property (strong,nonatomic) NSDictionary* group;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readTimeLbl;

@property NSString* unReadMsgNum;//未读消息条数
@end
