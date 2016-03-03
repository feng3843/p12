//
//  CDChatRoomController.h
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/28/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "CDCommon.h"
#import "JSMessagesViewController.h"
#import "CDSessionManager.h"
#import "CMContact.h"
#import "XHEmotionManagerView.h"

@interface CDChatRoomController : JSMessagesViewController

@property (nonatomic, strong) NSString *otherId;
@property (nonatomic) CDChatRoomType type;
@property (nonatomic, strong) AVGroup *group;
@property CMContact* other;
- (IBAction)callTelClick:(id)sender;

@end
