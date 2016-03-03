//
//  CDSessionManager.h
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/29/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDCommon.h"

typedef enum : NSUInteger {
    CDChatRoomTypeSingle = 1,
    CDChatRoomTypeGroup,
} CDChatRoomType;

@interface CDSessionManager : NSObject <AVSessionDelegate, AVSignatureDelegate, AVGroupDelegate>
+ (instancetype)sharedInstance;
//- (void)startSession;
//- (void)addSession:(AVSession *)session;
//- (NSArray *)sessions;
- (NSArray *)chatRooms;
- (void)addChatWithPeerId:(NSString *)peerId;
- (void)deleteChatByPeerId:(NSString *)peerId;
- (AVGroup *)joinGroup:(NSString *)groupId;
- (void)startNewGroup:(AVGroupResultBlock)callback;
- (void)sendMessage:(NSString *)message toPeerId:(NSString *)peerId;
- (void)sendMessage:(NSString *)message toGroup:(NSString *)groupId;
- (void)sendAttachment:(AVFile *)object toPeerId:(NSString *)peerId;
- (void)sendAttachment:(AVFile *)object toGroup:(NSString *)groupId;
- (NSArray *)getMessagesForPeerId:(NSString *)peerId;
- (NSString*)getMessageNumForPeerId:(NSString *)peerId ReadTime:(NSString*)readTime;
- (NSDictionary*)getMaxMessageForPeerId:(NSString *)peerId;
- (NSArray *)getMessagesForGroup:(NSString *)groupId;
- (void)getHistoryMessagesForPeerId:(NSString *)peerId callback:(AVArrayResultBlock)callback;
- (void)getHistoryMessagesForGroup:(NSString *)groupId callback:(AVArrayResultBlock)callback;
- (void)clearData;
- (void)clearSession;
+ (void)clearSession;
@end
