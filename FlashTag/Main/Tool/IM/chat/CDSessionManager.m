//
//  CDSessionManager.m
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/29/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "CDSessionManager.h"
#import "FMDB.h"
#import "CDCommon.h"
#import "CMData.h"
#import "CDUtils.h"
#import "CDEmotionUtils.h"

@interface CDSessionManager () {
    FMDatabase *_database;
    AVSession *_session;
    NSMutableArray *_chatRooms;
    NSString* selfId;
    NSMutableArray* peerIds;
}

@end

static id instance = nil;
static BOOL initialized = NO;

@implementation CDSessionManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    if (!initialized) {
        [instance commonInit];
    }
    return instance;
}

- (NSString *)databasePath {
    static NSString *databasePath = nil;
    if (!databasePath) {
        NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        databasePath = [cacheDirectory stringByAppendingPathComponent:@"chat.db"];
    }
    return databasePath;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)init {
    if ((self = [super init])) {
        _chatRooms = [[NSMutableArray alloc] init];
        peerIds = [[NSMutableArray alloc] init];
        AVSession *session = [[AVSession alloc] init];
        session.sessionDelegate = self;
        session.signatureDelegate = self;
        _session = session;

        NSLog(@"database path:%@", [self databasePath]);
        _database = [FMDatabase databaseWithPath:[self databasePath]];
        [_database open];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    if (![_database tableExists:@"messages"]) {
        [_database executeUpdate:@"create table \"messages\" (\"fromid\" text, \"toid\" text, \"type\" text, \"message\" text, \"object\" text, \"time\" integer)"];
    }
    if (![_database tableExists:@"sessions"]) {
        [_database executeUpdate:@"create table \"sessions\" (\"type\" integer, \"otherid\" text)"];
    }
    [AVGroup setDefaultDelegate:self];

    if (!selfId) {
        selfId = [CMData getMemId];
    }
    [_session openWithPeerId:selfId];

    FMResultSet *rs = [_database executeQuery:@"select distinct \"fromid\" from \"messages\" where \"toid\" = ?" withArgumentsInArray:@[selfId]];
    NSString *otherid = nil;
    while ([rs next]) {
        otherid = [rs stringForColumn:@"fromid"];
        if (![peerIds containsObject:otherid]) {
            [peerIds addObject:otherid];
        }
    }
    rs = [_database executeQuery:@"select \"toid\" from \"messages\" where \"fromid\" = ?" withArgumentsInArray:@[selfId]];
    while ([rs next]) {
        otherid = [rs stringForColumn:@"toid"];
        if (![peerIds containsObject:otherid]) {
            [peerIds addObject:otherid];
        }
    }
    for (NSString* peerId in peerIds) {
        NSDictionary *maxmsg = [self getMaxMessageForPeerId:peerId];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

        [dict setObject:@(CDChatRoomTypeSingle) forKey:@"type"];
        [dict setObject:peerId forKey:@"otherid"];
        [dict setObject:maxmsg forKey:@"maxmsg"];
        [_chatRooms addObject:dict];
    }

    [_session watchPeerIds:peerIds callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"watch success");
        } else {
            NSLog(@"%@", error);
        }
    }];
    initialized = YES;
}

- (void)clearData {
    [_database executeUpdate:@"DROP TABLE IF EXISTS messages"];
    [_database executeUpdate:@"DROP TABLE IF EXISTS sessions"];
    [_chatRooms removeAllObjects];
    [_session close];
    initialized = NO;
    selfId = nil;
    [peerIds removeAllObjects];
}

- (void)clearSession {
    [_database executeUpdate:@"DROP TABLE IF EXISTS sessions"];
    [_chatRooms removeAllObjects];
    if(!!_session)
    {
        [_session close];
    }
    initialized = NO;
    selfId = nil;
    [peerIds removeAllObjects];
}

+ (void)clearSession {
    if (instance) {
        [instance clearSession];
    }
}

- (NSArray *)chatRooms {

    return [_chatRooms sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        id obj_1 = [obj1 objectForKey:@"maxmsg"];
        id obj_2 = [obj2 objectForKey:@"maxmsg"];
        if ([[obj_1 objectForKey:@"time"] doubleValue]>[[obj_2 objectForKey:@"time"] doubleValue]) {
            return NSOrderedAscending;
        }
        else if ([[obj_1 objectForKey:@"time"] doubleValue]<[[obj_2 objectForKey:@"time"] doubleValue]) {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
}
- (void)addChatWithPeerId:(NSString *)peerId {
    if (![peerIds containsObject:peerId]) {
        [peerIds addObject:peerId];
        [_session watchPeerIds:@[peerId] callback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"watch success");
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                NSDictionary *maxmsg = [self getMaxMessageForPeerId:peerId];
                [dict setObject:[NSNumber numberWithInteger:CDChatRoomTypeSingle] forKey:@"type"];
                [dict setObject:peerId forKey:@"otherid"];
                if (maxmsg) {
                    if (![@"" isEqualToString:[maxmsg objectForKey:@"time"]]) {
                        [dict setObject:maxmsg forKey:@"maxmsg"];
                        [_chatRooms addObject:dict];
                        [_database executeUpdate:@"insert into \"sessions\" (\"type\", \"otherid\") values (?, ?)" withArgumentsInArray:@[[NSNumber numberWithInteger:CDChatRoomTypeSingle], peerId]];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SESSION_UPDATED object:_session userInfo:nil];
                }
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

//删除与某个联系人的聊天记录
- (void)deleteChatByPeerId:(NSString *)peerId{
    if ([peerIds containsObject:peerId]) {
        [peerIds removeObject:peerId];
        
        [_chatRooms enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj valueForKey:@"otherid"] isEqualToString:peerId]) {
                [_chatRooms removeObject:obj];
                *stop = TRUE;
            }
        }];
        
        [_database executeUpdate:@"delete from \"sessions\" where otherid = ?" withArgumentsInArray:@[peerId]];
        [_database executeUpdate:@"delete from \"messages\" where fromid = ? or toid = ?" withArgumentsInArray:@[peerId,peerId]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SESSION_UPDATED object:_session userInfo:nil];
    }
}

- (void)unwatchPeerId:(NSString *)peerId {
    if (peerId) {
        [_session unwatchPeerIds:@[peerId] callback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"%@ unwatched!", peerId);
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (AVGroup *)joinGroup:(NSString *)groupId {
    BOOL exist = NO;
    for (NSDictionary *dict in _chatRooms) {
        CDChatRoomType type = [[dict objectForKey:@"type"] integerValue];
        NSString *otherid = [dict objectForKey:@"otherid"];
        if (type == CDChatRoomTypeGroup && [groupId isEqualToString:otherid]) {
            exist = YES;
            break;
        }
    }
    if (!exist) {
        AVGroup *group = [AVGroup getGroupWithGroupId:groupId session:_session];
        group.delegate = self;
        [group join];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInteger:CDChatRoomTypeGroup] forKey:@"type"];
        [dict setObject:groupId forKey:@"otherid"];
        [_chatRooms addObject:dict];
        [_database executeUpdate:@"insert into \"sessions\" (\"type\", \"otherid\") values (?, ?)" withArgumentsInArray:@[[NSNumber numberWithInteger:CDChatRoomTypeGroup], groupId]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SESSION_UPDATED object:group.session userInfo:nil];
    }
    return [AVGroup getGroupWithGroupId:groupId session:_session];;
}
- (void)startNewGroup:(AVGroupResultBlock)callback {
    [AVGroup createGroupWithSession:_session groupDelegate:self callback:^(AVGroup *group, NSError *error) {
        if (!error) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSNumber numberWithInteger:CDChatRoomTypeGroup] forKey:@"type"];
            [dict setObject:group.groupId forKey:@"otherid"];
            [_chatRooms addObject:dict];
            [_database executeUpdate:@"insert into \"sessions\" (\"type\", \"otherid\") values (?, ?)" withArgumentsInArray:@[[NSNumber numberWithInteger:CDChatRoomTypeGroup], group.groupId]];
            if (callback) {
                callback(group, error);
            }
        } else {
            NSLog(@"error:%@", error);
        }
    }];
}

- (void)sendMessage:(NSString *)message toPeerId:(NSString *)peerId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString* uuid = [CDUtils uuid];
    [dict setObject:@(0) forKey:@"type"];
    [dict setObject:[CDEmotionUtils convertWithText:message toEmoji:NO] forKey:@"content"];
    [dict setObject:uuid forKey:@"objectId"];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    AVMessage *messageObject = [AVMessage messageForPeerWithSession:_session toPeerId:peerId payload:payload];
    if (![_session.peerId isEqualToString:peerId])
    {
        [_session sendMessage:messageObject requestReceipt:YES];
    }
    
    dict = [NSMutableDictionary dictionary];
    [dict setObject:_session.peerId forKey:@"fromid"];
    [dict setObject:peerId forKey:@"toid"];
    [dict setObject:@"text" forKey:@"type"];
    [dict setObject:message forKey:@"message"];
    [dict setObject:uuid forKey:@"object"];
    [dict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"time"];
    [_database executeUpdate:@"insert into \"messages\" (\"fromid\", \"toid\", \"type\", \"message\", \"object\", \"time\") values (:fromid, :toid, :type, :message, :object, :time)" withParameterDictionary:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:nil userInfo:dict];
    [self addChatWithPeerId:peerId];
    [self sortChatList:peerId];
}

-(void)sortChatList:(NSString*)peerId
{
    NSDictionary* dict = nil;
    for (NSDictionary* _dict in _chatRooms) {
        if ([peerId isEqualToString:[_dict objectForKey:@"otherid"]]) {
            dict = _dict;
            break;
        }
    }
    if (dict)
    {
        [_chatRooms removeObject:dict];
        NSMutableDictionary* dictMuable = [dict mutableCopy];
        [dictMuable setObject:[self getMaxMessageForPeerId:peerId] forKey:@"maxmsg"];
        [_chatRooms insertObject:dictMuable atIndex:0];
    }
}


- (void)sendAttachment:(id)image toPeerId:(NSString *)peerId {
    NSString *type = @"image";
    
    NSString* objectId = [[NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]] MD5EncodedString];
    AVFile * file = [AVFile fileWithData:UIImageJPEGRepresentation(image,1.0)];
    file.objectId = objectId;
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSString* fileName = [self saveFileToLocal:[file getData] ObjectID:file.objectId Type:@"image"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_session.peerId forKey:@"dn"];
            [dict setObject:@(1) forKey:@"type"];
            [dict setObject:file.objectId forKey:@"objectId"];
            [dict setObject:file.url forKey:@"content"];
            
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            AVMessage *messageObject = [AVMessage messageForPeerWithSession:_session toPeerId:peerId payload:payload];
            //    [_session sendMessage:messageObject requestReceipt:YES];
            [_session sendMessage:messageObject transient:NO];
            //    [_session sendMessage:payload isTransient:NO toPeerIds:@[peerId]];
            
            dict = [NSMutableDictionary dictionary];
            [dict setObject:_session.peerId forKey:@"fromid"];
            [dict setObject:peerId forKey:@"toid"];
            [dict setObject:type forKey:@"type"];
            [dict setObject:fileName forKey:@"object"];
            [dict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"time"];
            [_database executeUpdate:@"insert into \"messages\" (\"fromid\", \"toid\", \"type\", \"object\", \"time\") values (:fromid, :toid, :type, :object, :time)" withParameterDictionary:dict];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:nil userInfo:dict];
            
            [self addChatWithPeerId:peerId];
            [self sortChatList:peerId];
            
            [SVProgressHUD showInfoWithStatus:@"发送成功！"];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"发送失败！"];
        }
    }];
}

-(NSString*)saveFileToLocal:(NSData*)data ObjectID:(NSString*)objectId Type:(NSString*)type
{
    //将图片保存到本地
    NSString* strUser = [CMData getMemId];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *dbFilePath = [NSString stringWithFormat:@"Documents/%@chat%@",strUser,type];
    NSString *dirName = [NSHomeDirectory() stringByAppendingPathComponent:dbFilePath];
    BOOL isDir = NO;
    if (![filemanager fileExistsAtPath:dirName isDirectory:&isDir])
    {
        // 创建数据文件所在目录
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:dbFilePath] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    else if (!isDir)
    {
        //                DDLogVerbose(@"创建目录失败:%@",filename);
        // Throw exception
    }
    NSString* str = @"";
    if ([@"image" isEqualToString:type]) {
        str = @".jpg";
    }

    NSString *dbPath = [NSString stringWithFormat:@"%@/%@%@",dbFilePath,objectId,str];
    NSString *fileName  = [NSHomeDirectory() stringByAppendingPathComponent:dbPath];
    if(![filemanager fileExistsAtPath:fileName])
    {
        [filemanager createFileAtPath:fileName contents:data attributes:nil];
    }
    return fileName;
}

- (void)sendMessage:(NSString *)message toGroup:(NSString *)groupId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_session.peerId forKey:@"dn"];
    [dict setObject:@(0) forKey:@"type"];
    [dict setObject:message forKey:@"msg"];


    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    AVGroup *group = [AVGroup getGroupWithGroupId:groupId session:_session];
    AVMessage *messageObject = [AVMessage messageForGroup:group payload:payload];
    [group sendMessage:messageObject];
    
    dict = [NSMutableDictionary dictionary];
    [dict setObject:_session.peerId forKey:@"fromid"];
    [dict setObject:groupId forKey:@"toid"];
    [dict setObject:@"text" forKey:@"type"];
    [dict setObject:message forKey:@"message"];
    [dict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"time"];
    [_database executeUpdate:@"insert into \"messages\" (\"fromid\", \"toid\", \"type\", \"message\", \"time\") values (:fromid, :toid, :type, :message, :time)" withParameterDictionary:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:nil userInfo:dict];
}

- (void)sendAttachment:(id)image toGroup:(NSString *)groupId {
    NSString *type = @"image";
    NSString* objectId = [[NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]] MD5EncodedString];
    AVFile * file = [AVFile fileWithData:UIImageJPEGRepresentation(image,1.0)];
    file.objectId = objectId;
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            
            NSString* fileName = [self saveFileToLocal:[file getData] ObjectID:file.objectId Type:@"image"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_session.peerId forKey:@"dn"];
            [dict setObject:@(1) forKey:@"type"];
            [dict setObject:file.objectId forKey:@"objectId"];
            [dict setObject:file.url forKey:@"content"];
            
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            AVGroup *group = [AVGroup getGroupWithGroupId:groupId session:_session];
            AVMessage *messageObject = [AVMessage messageForGroup:group payload:payload];
            [group sendMessage:messageObject];
            
            dict = [NSMutableDictionary dictionary];
            [dict setObject:_session.peerId forKey:@"fromid"];
            [dict setObject:groupId forKey:@"toid"];
            [dict setObject:type forKey:@"type"];
            [dict setObject:fileName forKey:@"object"];
            [dict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"time"];
            [_database executeUpdate:@"insert into \"messages\" (\"fromid\", \"toid\", \"type\", \"object\", \"time\") values (:fromid, :toid, :type, :object, :time)" withParameterDictionary:dict];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:nil userInfo:dict];
            
            [SVProgressHUD showInfoWithStatus:@"发送成功！"];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"发送失败！"];
        }
    }];
}

- (NSArray *)getMessagesForPeerId:(NSString *)peerId {
    FMResultSet *rs = [_database executeQuery:@"select \"fromid\", \"toid\", \"type\", \"message\", \"object\", \"time\" from \"messages\" where (\"fromid\"=? and \"toid\"=?) or (\"fromid\"=? and \"toid\"=?) order by \"time\"" withArgumentsInArray:@[selfId, peerId, peerId, selfId]];
    NSMutableArray *result = [NSMutableArray array];
    while ([rs next]) {
        NSString *fromid = [rs stringForColumn:@"fromid"];
        NSString *toid = [rs stringForColumn:@"toid"];
        double time = [rs doubleForColumn:@"time"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *type = [rs stringForColumn:@"type"];
        if ([type isEqualToString:@"text"]) {
            NSString *message = [rs stringForColumn:@"message"];
            NSDictionary *dict = @{@"fromid":fromid, @"toid":toid, @"type":type, @"message":message, @"time":date};
            [result addObject:dict];
        } else {
            NSString *object = [rs stringForColumn:@"object"];
            NSDictionary *dict = @{@"fromid":fromid, @"toid":toid, @"type":type, @"object":object, @"time":date};
            [result addObject:dict];
        }
    }
    return result;
}

- (NSString*)getMessageNumForPeerId:(NSString *)peerId ReadTime:(NSString*)readTime
{
    if(!peerId||[selfId isEqualToString:peerId])
    {
        return @"";
    }
    else
    {
        FMResultSet *rs = [_database executeQuery:@"select count(*) from \"messages\" where ((\"fromid\"=? and \"toid\"=?) or (\"fromid\"=? and \"toid\"=?)) and \"time\" > ?" withArgumentsInArray:@[selfId, peerId, peerId, selfId,readTime]];
        NSString* resultNum = nil;
        while ([rs next]) {
            resultNum = [rs stringForColumnIndex:0];
        }
        return [resultNum intValue]==0?@"":resultNum;
    }
}


- (NSDictionary*)getMaxMessageForPeerId:(NSString *)peerId
{
    FMResultSet *rs = [_database executeQuery:@"select \"fromid\", \"toid\", \"type\", \"message\", \"object\", max(\"time\") as time from \"messages\" where (\"fromid\"=? and \"toid\"=?) or (\"fromid\"=? and \"toid\"=?)" withArgumentsInArray:@[selfId, peerId, peerId, selfId]];
    NSDictionary *dict = nil;
    while ([rs next]) {
        NSString *fromid = [rs stringForColumn:@"fromid"];
        NSString *toid = [rs stringForColumn:@"toid"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *type = [rs stringForColumn:@"type"];
        if (!toid) {
            break;
        }
        if (!time) {
            time = @"";
        }
        if(!type||[type isEqualToString:@"text"]) {
            NSString *message = [rs stringForColumn:@"message"];
            dict = @{@"fromid":fromid, @"toid":toid, @"type":@"text", @"message":[CDEmotionUtils convertWithText:message toEmoji:YES], @"time":time};
        } else {
            NSString *object = [rs stringForColumn:@"object"];
            dict = @{@"fromid":fromid, @"toid":toid, @"type":type, @"object":object, @"time":time};
        }
        break;
    }
    return dict;
}

- (NSArray *)getMessagesForGroup:(NSString *)groupId {
    FMResultSet *rs = [_database executeQuery:@"select \"fromid\", \"toid\", \"type\", \"message\", \"object\", \"time\" from \"messages\" where \"toid\"=?" withArgumentsInArray:@[groupId]];
    NSMutableArray *result = [NSMutableArray array];
    while ([rs next]) {
        NSString *fromid = [rs stringForColumn:@"fromid"];
        NSString *toid = [rs stringForColumn:@"toid"];
        double time = [rs doubleForColumn:@"time"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *type = [rs stringForColumn:@"type"];
        if ([type isEqualToString:@"text"]) {
            NSString *message = [rs stringForColumn:@"message"];
            NSDictionary *dict = @{@"fromid":fromid, @"toid":toid, @"type":type, @"message":message, @"time":date};
            [result addObject:dict];
        } else {
            NSString *object = [rs stringForColumn:@"object"];
            NSDictionary *dict = @{@"fromid":fromid, @"toid":toid, @"type":type, @"object":object, @"time":date};
            [result addObject:dict];
        }
    }
    return result;
}

- (void)getHistoryMessagesForPeerId:(NSString *)peerId callback:(AVArrayResultBlock)callback {
    AVHistoryMessageQuery *query = [AVHistoryMessageQuery queryWithFirstPeerId:_session.peerId secondPeerId:peerId];
    [query findInBackgroundWithCallback:^(NSArray *objects, NSError *error) {
        callback(objects, error);
    }];
}

- (void)getHistoryMessagesForGroup:(NSString *)groupId callback:(AVArrayResultBlock)callback {
    AVHistoryMessageQuery *query = [AVHistoryMessageQuery queryWithGroupId:groupId];
    [query findInBackgroundWithCallback:^(NSArray *objects, NSError *error) {
        callback(objects, error);
    }];
}
-(NSMutableDictionary*)fromAVMessage:(AVMessage *)message AVSession:(AVSession *)session
{
    NSError *error;
    NSData *data = [message.payload dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@", jsonDict);
    NSString *type = @"text";
    NSString *msg = [jsonDict objectForKey:@"content"];
    NSString *objectId = [jsonDict objectForKey:@"objectId"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if([[jsonDict objectForKey:@"type"] intValue]==1)
    {
        type = @"image";
    }
    [dict setObject:message.fromPeerId forKey:@"fromid"];
    [dict setObject:session.peerId forKey:@"toid"];
    [dict setObject:@(message.timestamp/1000) forKey:@"time"];
    [dict setObject:type forKey:@"type"];
    if ([type isKindOfClass:[NSString class]]&&[type isEqualToString:@"text"]) {

        FMResultSet *rs = [_database executeQuery:@"select count(*) from \"messages\" where \"object\"=? " withArgumentsInArray:@[objectId]];
        BOOL exsist = FALSE;
        while ([rs next]) {
            NSString *resultNum = [rs stringForColumnIndex:0];
            if ([resultNum intValue] > 0) {
                exsist = TRUE;
                break;
            }
        }
        if (!exsist) {
            [dict setObject:msg forKey:@"message"];
            [dict setObject:@"" forKey:@"object"];
            [_database executeUpdate:@"insert into \"messages\" (\"fromid\", \"toid\", \"type\", \"message\",\"object\", \"time\") values (:fromid, :toid, :type, :message,:object,  :time)" withParameterDictionary:dict];
        }
    }
    else
    {
        FMResultSet *rs = [_database executeQuery:@"select count(*) from \"messages\" where \"object\"=? " withArgumentsInArray:@[objectId]];
        BOOL exsist = FALSE;
        while ([rs next]) {
            NSString *resultNum = [rs stringForColumnIndex:0];
            if ([resultNum intValue] > 0) {
                exsist = TRUE;
                break;
            }
        }
        if (!exsist) {
            [dict setObject:msg forKey:@"message"];
            dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:msg]];
                if (data) {
                    NSString* fileName = [self saveFileToLocal:data ObjectID:[msg MD5EncodedString] Type:@"image"];
                    [dict setObject:fileName forKey:@"object"];
                    [_database executeUpdate:@"insert into \"messages\" (\"fromid\", \"toid\", \"type\", \"message\",\"object\", \"time\") values (:fromid, :toid, :type, :message,:object,  :time)" withParameterDictionary:dict];
                    
                    [self addChatWithPeerId:message.fromPeerId];
                    [self sortChatList:message.fromPeerId];
                    
                    dispatch_queue_t queue = dispatch_get_main_queue();
                    dispatch_async(queue, ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SESSION_UPDATED object:session userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:session userInfo:dict];
                                   });
                }
            });
        }
    }
    return dict;
}

#pragma mark - AVSessionDelegate
- (void)sessionOpened:(AVSession *)session {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@", session.peerId);
}

- (void)sessionPaused:(AVSession *)session {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@", session.peerId);
}

- (void)sessionResumed:(AVSession *)session {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@", session.peerId);
}

- (void)session:(AVSession *)session didReceiveMessage:(AVMessage *)message {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ message:%@ fromPeerId:%@", session.peerId, message, message.fromPeerId);
    if ([session.peerId isEqualToString:message.fromPeerId])
    {
        return;
    }

    //消息转换
    NSMutableDictionary* dict = [self fromAVMessage:message AVSession:session];

    [self addChatWithPeerId:message.fromPeerId];
    [self sortChatList:message.fromPeerId];
    
    if ([@"text" isEqualToString:[dict objectForKey:@"type"]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SESSION_UPDATED object:session userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:session userInfo:dict];
    }
}
- (void)session:(AVSession *)session messageSendFailed:(AVMessage *)message error:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ message:%@ toPeerId:%@ error:%@", session.peerId, message, message.toPeerId, error);
}

- (void)session:(AVSession *)session messageSendFinished:(AVMessage *)message {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ message:%@ toPeerId:%@", session.peerId, message, message.toPeerId);
}

- (void)session:(AVSession *)session messageArrived:(AVMessage *)message {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(AVSession *)session didReceiveStatus:(AVPeerStatus)status peerIds:(NSArray *)peerIds {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ peerIds:%@ status:%@", session.peerId, peerIds, status==AVPeerStatusOffline?@"offline":@"online");
}

- (void)sessionFailed:(AVSession *)session error:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ error:%@", session.peerId, error);
}

#pragma mark - AVGroupDelegate
- (void)group:(AVGroup *)group didReceiveMessage:(AVMessage *)message {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"group:%@ message:%@ fromPeerId:%@", group.groupId, message, message.fromPeerId);
    NSError *error;
    NSData *data = [message.payload dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@", jsonDict);
    
    NSString *type = [jsonDict objectForKey:@"type"];
    NSString *msg = [jsonDict objectForKey:@"msg"];
    NSString *object = [jsonDict objectForKey:@"object"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:message.fromPeerId forKey:@"fromid"];
    [dict setObject:group.groupId forKey:@"toid"];
    [dict setObject:@(message.timestamp/1000) forKey:@"time"];
    [dict setObject:type forKey:@"type"];
    if ([type isEqualToString:@"text"]) {
        [dict setObject:msg forKey:@"message"];
        [_database executeUpdate:@"insert into \"messages\" (\"fromid\", \"toid\", \"type\", \"message\", \"time\") values (:fromid, :toid, :type, :message, :time)" withParameterDictionary:dict];
    } else {
        [dict setObject:object forKey:@"object"];
        [_database executeUpdate:@"insert into \"messages\" (\"fromid\", \"toid\", \"type\", \"object\", \"time\") values (:fromid, :toid, :type, :object, :time)" withParameterDictionary:dict];
    }
    [self joinGroup:group.groupId];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:group.session userInfo:dict];
}

- (void)group:(AVGroup *)group didReceiveEvent:(AVGroupEvent)event peerIds:(NSArray *)peerIds {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"group:%@ event:%lu peerIds:%@", group.groupId, (long)event, peerIds);
    if (event == AVGroupEventSelfJoined) {
        [self joinGroup:group.groupId];
    }
}

- (void)group:(AVGroup *)group messageSendFinished:(AVMessage *)message {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"group:%@ message:%@", group.groupId, message.payload);
}

- (void)group:(AVGroup *)group messageSendFailed:(AVMessage *)message error:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"group:%@ message:%@ error:%@", group.groupId, message.payload, error);
}

- (void)session:(AVSession *)session group:(AVGroup *)group messageSent:(NSString *)message success:(BOOL)success {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"group:%@ message:%@ success:%d", group.groupId, message, success);
}

- (AVSignature *)signatureForPeerWithPeerId:(NSString *)peerId watchedPeerIds:(NSArray *)watchedPeerIds action:(NSString *)action {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"peerId:%@ action:%@", peerId, action);
    return nil;
}

- (AVSignature *)signatureForGroupWithPeerId:(NSString *)peerId groupId:(NSString *)groupId groupPeerIds:(NSArray *)groupPeerIds action:(NSString *)action {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"peerId:%@ groupId:%@ action:%@", peerId, groupId, action);
    return nil;
}
@end
