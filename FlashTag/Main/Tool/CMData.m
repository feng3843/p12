//
//  CMData.m
//  NewCut
//
//  Created by py on 15-7-18.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import "CMData.h"
#import "NSDate+Extensions.h"
#import "NSDate+Extensions.h"
#import "EGODatabase.h"
#import "CMContact.h"
#import "ChineseToPinyin.h"

#define USER_KEY_ID @"id"
#define USER_KEY_NAME @"name"
#define USER_KEY_TEL @"tel"
#define USER_KEY_USERIMAGE @"userImage"
#define USER_KEY_TOKEN @"token"
#define USER_KEY_PWD @"pwd"
#define USER_KEY_ICKNAME @"ickname"
#define USER_KEY_OTHERLOGIN @"otherLogin"
//#define USER_KEY_JOB @"job"
//#define USER_KEY_EMAIL @"email"
//#define USER_KEY_COMPANY_ID @"tradecode"
//#define USER_KEY_COMPANY_NAME @"companyname"
//#define USER_KEY_AVATAR @"avatar"

//#define USER_KEY_STATUS @"username_status"
//#define USER_KEY_CREATEDATE @"createdate"
//#define USER_KEY_BGCOVER @"bgcover"
//#define USER_KEY_PACKAGE @"package"
//#define USER_KEY_VALID_TIME @"validtime"

@implementation CMData

//初始化数据库
+ (void)initDatabase
{
    //最终数据库路径
    NSString* strUser = [CMData getUserId];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *dbFilePath = [NSString stringWithFormat:@"Documents/%@",strUser];
    NSString *filename = [NSHomeDirectory() stringByAppendingPathComponent:dbFilePath];
//    
//   NSString  *filename22 = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, DOMAIN, YES) lastObject];
//    NSLog(@"%@    <<<<<<<<<\n   %@",NSHomeDirectory(),filename22);
    BOOL isDir = NO;
    if (![filemanager fileExistsAtPath:filename isDirectory:&isDir])
    {
        // 创建数据文件所在目录
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:dbFilePath] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    else if (!isDir)
    {
        NSLog(@"创建目录失败:%@",filename);
        // Throw exception
    }
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/database.db",dbFilePath];
    strDatabasePath  = [NSHomeDirectory() stringByAppendingPathComponent:dbPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:strDatabasePath])
    {
        EGODatabase* database = [EGODatabase databaseWithPath:strDatabasePath];
        
        NSString *strSql = nil;
        
        //联系人表
        strSql = @"create table if not exists contact(id integer primary key asc, orgid text, contactid integer, name text,nickname text,job text,pinyin text,tel text,address text,avatar text,birth text,corpname text,corpaddress text,corpemail text,email text,gender text,motion text, corp_intro text,corpid text,groupid text,vc integer,readmsgtime integer);";
        EGODatabaseResult* result = [database executeQuery:strSql];
        [database close];
        if(result)
        {
        
        }
        else
        {
            
        }
    }
}

+(NSString *) getStringInDefByKey:(NSString *)key
{
    
    return [self getStringInDefByKey:key Default:@""];
}

+ (NSString*) getStringInDefByKey:(NSString*)key Default:(NSString *)strDefault
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *result = [def valueForKey:key];
    
    if (!result) {
        result = strDefault;
    }
    return result;
}



+(void)setToken:(NSString*)token
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:token forKey:USER_KEY_TOKEN];
}


+(void)setUserId:(NSString *)userId
{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userId forKey:USER_KEY_ID];
}

+(void)setUserName:(NSString *)name
{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:name forKey:USER_KEY_NAME];
}


+(void)setPassword:(NSString *)password{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:password forKey:USER_KEY_PWD];
    
}

+(void)setUserImage:(NSString *)imagePath
{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:imagePath forKey:USER_KEY_USERIMAGE];
}

+(void)setVersion:(NSString *)Version{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //    [userDefaults setValue:Version forKey:@"version"];
    //后台的版本是给安卓使用的，iOS直接取pinfo.list里的配置
    [userDefaults setValue:[NSString stringWithFormat:@"v%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] forKey:@"version"];
}



+(void)setLoginType:(BOOL )type{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:type forKey:USER_KEY_OTHERLOGIN];
    
}
+(BOOL)getLoginType{
    
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"xxxxxxx%@",[userDefaults valueForKey:USER_KEY_OTHERLOGIN]);
   return [[userDefaults valueForKey:USER_KEY_OTHERLOGIN] isEqualToNumber:@(1)];
 
}
+(NSString *)getVersion{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=
    //(NSString *)[defaults objectForKey:@"version"];
    [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    return str;
    
}

+(NSString*) getToken
{
    return [self getStringInDefByKey:USER_KEY_TOKEN Default:@""];
}
+ (NSString*)getMemId
{
    return [self getStringInDefByKey:USER_KEY_ID Default:@""];
}
+(NSString*) getUserName
{
    return [self getStringInDefByKey:USER_KEY_NAME Default:@""];
}
+(NSString*) getUserId
{
    return [self getStringInDefByKey:USER_KEY_ID Default:@""];//先给个默认值s
}
+(NSString*)getPassword{
   return [self getStringInDefByKey:USER_KEY_PWD Default:@""];
    
}
+(NSString*) getUserImage
{
    return [self getStringInDefByKey:USER_KEY_USERIMAGE Default:@""];//先给个默认值
}

/** 图片路径*/
+(void)setCommomImagePath:(NSString *)imagePath
{
    
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:imagePath forKey:DEFAULT_COMMEOT_IMAGEPATH];
}
+(NSString*)getCommonImagePath
{
 __block NSString *imagePath = [self getStringInDefByKey:DEFAULT_COMMEOT_IMAGEPATH Default:@""];
    if ([imagePath isEqualToString:@""]) {
        
        [CMAPI postUrl:API_GET_COMMONPATH Param:nil Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
            id result = [detailDict objectForKey:@"result"] ;
            if(succeed)
            {
               imagePath = [result objectForKey:@"commonPath"];
               
                [CMData setCommomImagePath:imagePath];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            
        }];
    }
    return imagePath;
}
/** 发布帖子id*/
+(void)setPublishNoteId:(NSString *)noteId
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:noteId forKey:DEFAULT_PUBLISH_NOTEID];
    
}
+(NSString *)getPublishNoteId
{
        return [self getStringInDefByKey:DEFAULT_PUBLISH_NOTEID Default:@""];
}

+ (int)getUserIdForInt
{
    return [[self getUserId] intValue];
}

+ (int)getUserType
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"zpzUserInfo.plist"];
    NSDictionary *token = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return [token[@"role"] intValue];
}
+ (void)updateReadTime:(int64_t)readTime ContactID:(NSString *)strContactID
{
    EGODatabase* database = [EGODatabase databaseWithPath:strDatabasePath];
    NSString *sqlUpdate = [[NSString alloc]initWithFormat:@"update contact set readmsgtime='%lld' where contactid = '%@'",readTime,strContactID];
    [database executeQuery:sqlUpdate];
}

//保存联系人
+ (BOOL)saveContacts:(NSMutableArray*) contactArray OrgId:(NSString*) orgid
{
    if (contactArray.count == 0) {
        return FALSE;
    }
    
    if (!orgid)
    {
        orgid = @"1";
    }
    
    EGODatabase* database = [EGODatabase databaseWithPath:strDatabasePath];
    
    [contactArray enumerateObjectsUsingBlock:^(CMContact* obj, NSUInteger idx, BOOL *stop) {
        //插入一笔
        NSString* strContactID = obj.strContactID;
        NSString* strName = obj.strName;
        NSString* strJob = obj.strJob;
        NSString* strTelePhone = obj.strTelePhone;
        NSString* strAvatar = obj.strAvatar;
        NSString* strEmail = obj.strEmail;
        NSString* strCorpName = obj.strCorpName;
        NSString* strCorpID = obj.strContactID;
        NSString* strGroupID = obj.strContactID;
        NSString* strVC = obj.strContactID;
        NSString* pinyin = [ChineseToPinyin pinyinFromChiniseString:strName];
        
        //查询是否已经存在联系人，如果有就直接返回，没有就插
        NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from contact where contactid = %@ and orgid = '%@'",strContactID,orgid];
        EGODatabaseResult *result = [database executeQuery:sqlQuery];
        NSMutableArray* arrayContact = [NSMutableArray arrayWithCapacity:10];
        for(EGODatabaseRow* row in result) {
            [arrayContact insertObject:[self result2contact:row] atIndex:0];
        }
        if ([arrayContact count] > 0)
        {
            //更新联系人
            NSString* sqlDelete = [[NSString alloc]initWithFormat:@"delete from contact where contactid = '%@' and orgid = '%@'",strContactID,orgid];
            [database executeQuery:sqlDelete];
        }
        NSString *sqlInsert = [[NSString alloc]initWithFormat:@"insert into contact(orgid,contactid,name,job,tel,avatar,corpname,email,corpid,pinyin,groupid,vc,readmsgtime) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,%lld)",
                               orgid,strContactID,strName,strJob,strTelePhone,strAvatar,strCorpName,strEmail,strCorpID,pinyin,strGroupID,[strVC intValue],((CMContact*)arrayContact.firstObject).readMsgTimestamp];
        
        [database executeQuery:sqlInsert];
    }];
    [database close];
    
    return TRUE;
}
//查询联系人
+ (CMContact*)queryContactById:(NSString *)contactId
{
    CMContact *contact = nil;
    
    EGODatabase* database = [EGODatabase databaseWithPath:strDatabasePath];
    
    //先按照汉字查找
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from contact where contactid = '%@' order by tel",contactId];
    
    EGODatabaseResult *result = [database executeQuery:sqlQuery];
    for(EGODatabaseRow* row in result) {
        contact = [self result2contact:row];
    }
    [database close];
    
    return contact;
}

#pragma mark CONTACT
+ (CMContact*) result2contact:(EGODatabaseRow*)row
{
    CMContact *msg = [[CMContact alloc]init];
    
    msg.strContactID = [row stringForColumn:@"contactid"];
    msg.strName = [row stringForColumn:@"name"];
    msg.strPinyin = [row stringForColumn:@"pinyin"];
    msg.strAvatar = [row stringForColumn:@"avatar"];
    msg.strTelePhone = [row stringForColumn:@"tel"];
    msg.strEmail = [row stringForColumn:@"email"];
    msg.strCorpName = [row stringForColumn:@"corpname"];
    msg.strJob = [row stringForColumn:@"job"];
    msg.strGroupID = [row stringForColumn:@"groupid"];
    msg.strOrgID = [row stringForColumn:@"orgid"];
    msg.strVC = [row stringForColumn:@"vc"];
    msg.readMsgTimestamp = [row intForColumn:@"readmsgtime"];
    
    msg.strOrgID = @"1";
    return msg;
}
@end
