////
////  IMTableViewController.m
////  liaotian
////
////  Created by LA－PC on 15/9/8.
////  Copyright (c) 2015年 LA. All rights reserved.
////
//
//#import "IMTableViewController.h"
//#import "IMConsTableViewCell.h"
//#import "UIColor+Extensions.h"
//#import "LibTimeParse.h"
//#import "NSDate+Utils.h"
//#import "LibUserDefaultsExtModel.h"
//#import "ExtModel.h"
//#import "NSDate+Extensions.h"
//#import "NSString+Extensions.h"
//#import "LibCM.h"
//
//#define HEADTABLEHIGHT 16
//#define CELLTABLEHIGHT 62
//#define BGTABLECOLOR @"F0F0F0"
//
//
//@interface IMTableViewController ()
//
//@property(nonatomic)NSMutableArray *datasource;
//
//@end
//
//@implementation IMTableViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
//    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
//    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
//    
//    [self DataInit];
//}
//- (void)leftItemAction
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//}
//
//-(void)DataInit
//{[LibUserDefaultsExtModel clearExtModelCache];
//    //设置初始值
//    if (!self.selfClientID) {
////        self.selfClientID=@"linda";
//        self.selfClientID=[CMData getUserId];
//    }
//    //self.title=_chatName;
//    self.datasource=[[NSMutableArray alloc]init];
//    self.datasource=[[LibUserDefaultsExtModel getExtModelListInCache]mutableCopy];
//    self.tableView.backgroundColor=[UIColor colorWithHexString:BGTABLECOLOR];
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.tableView.tableFooterView = [[UIView alloc] init];
//    [self UpdateChatHistoryList];
//}
//
//-(void)UpdateChatHistoryList
//{
//    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(queue, ^{
//        
//        //处理数据操作
//        __block BOOL isNeedRefresh=NO;
//        
//        NSString* clientId=self.selfClientID;
//        
//        
//        __block NSMutableArray *newDataSource=[[NSMutableArray alloc]init];
//        
//        dispatch_sync(queue, ^{
//            __block BOOL flg_exec_once=NO;
//            __block BOOL flg_complete_findRecentConversation=NO;
//            //这里
//            do {
//                if(!flg_exec_once)
//                {
//                    //需要执行一次
//                    [[LeanMessageManager manager] openSessionWithClientID:clientId completion:^(BOOL succeeded, NSError *error) {
//                        
//                        if(!error){
//                            
//                            [[LeanMessageManager manager]  findRecentConversationsWithBlock:^(NSArray *objects, NSError *error) {
//                                
//                                //获取最近聊天记录列表
//                                
//                                //这里对获取数据进行解析处理
//                                ExtModel* extModel=nil;
//                                NSMutableDictionary *dic=nil;
//                                for(AVObject* obj in objects) {
//                                    //解析保存
//                                    extModel=[[ExtModel alloc]init];
//                                    dic=[obj objectForKey:@"localData"];
//                                    extModel.str1=[obj objectForKey:@"objectId"];
//                                    extModel.str2=[[dic objectForKey:@"lm"] GetString_FormatString:@"yyyy-MM-dd HH:mm:ss"];
//                                    
//                                    //从数组中查询该会话是否存在
//                                    BOOL flg=NO;
//                                    for(NSData* item in self.datasource)
//                                    {
//                                        ExtModel* extm=[NSKeyedUnarchiver unarchiveObjectWithData:item];
//                                        if([extModel.str1 isEqualToString:extm.str1])
//                                        {
//                                            //存在
//                                            //对最后一次时间进行判断
//                                            if([extModel.str2 isEqualToString:extm.str2])
//                                            {
//                                                flg=YES;//不需要更新了
//                                                extModel.str3=extm.str3;
//                                                extModel.str4=extm.str4;
//                                                extModel.arr1=extm.arr1;
//                                                extModel.arr2=extm.arr2;
//                                                extModel.arr3=extm.arr3;
//                                                break;
//                                            }
//                                            else
//                                            {
//                                                flg=NO;
//                                                //数据需要更新
//                                            }
//                                        }
//                                    }
//                                    if (!flg) {
//                                        //需要请求完成数据
//                                        //可以进行名称和头像的保存
//                                        NSMutableArray* arrHMs=[[NSMutableArray alloc]init];
//                                        NSMutableArray* arrHmides=[[NSMutableArray alloc]init];
//                                        NSMutableArray* arrAvatar=[[NSMutableArray alloc]init];
//                                        NSString* idename=@"";
//                                        NSString* ideavatar=@"";
//                                        NSMutableArray* members=[dic objectForKey:@"m"];
//                                        for (NSString* item in members) {
//                                            if([item isEqualToString:clientId])
//                                                continue;
//                                            [arrHmides addObject:item];
//                                            NSString* strUserInfo=[self getUserInfoById:item];
//                                            NSDictionary* dicUserInfo=[strUserInfo GetDictionary];
//                                            NSString* code=[dicUserInfo objectForKey:@"code"];
//                                            if([code isEqualToString:@"2000"])
//                                            {
//                                                NSDictionary* dic=[dicUserInfo objectForKey:@"result"];
//                                                idename=[dic objectForKey:@"targetDisplayName"];//名称  转换好的名称
//                                                ideavatar=[LibCM getUserAvatarByUserID:item];//头像
//                                            }
//                                            [arrHMs addObject:idename];
//                                            [arrAvatar addObject:ideavatar];
//                                        }
//                                        extModel.arr2=[arrHMs copy];
//                                        extModel.arr3=[arrAvatar copy];
//                                        extModel.arr1=[arrHmides copy];
//                                        extModel.str4=@"1";//需要更新
//                                    }
//                                    [newDataSource addObject:extModel];
//                                    isNeedRefresh=YES;
//                                }
//                                flg_complete_findRecentConversation=YES;
//                            }];
//                        }else{
//                            flg_complete_findRecentConversation=YES;
//                            NSLog(@"error=%@",error);
//                        }
//                    }];
//                    flg_exec_once=YES;
//                }
//            } while (!flg_complete_findRecentConversation);
//        });
//        dispatch_sync(queue, ^{
//            __block BOOL flg_exec_once=NO;
//            __block BOOL flg_complete_getLastMessage=NO;
//            if (isNeedRefresh) {
//                //清掉之前的缓存，重新保存
//                [LibUserDefaultsExtModel clearExtModelCache];
//                for (ExtModel* ext in newDataSource) {
//                    //执行
//                    __block NSString *strChatContent=@"";
//                    if([ext.str4 isEqualToString:@"1"])
//                    {
//                        //需要更新的
//                        do {
//                            if(!flg_exec_once)
//                            {
//                                ConversationType type;
//                                if(ext.arr1.count>1){
//                                    type=ConversationTypeGroup;
//                                }else{
//                                    type=ConversationTypeOneToOne;
//                                }
//                                [[LeanMessageManager manager] createConversationsWithClientIDs:ext.arr1 conversationType:type completion:^(AVIMConversation *conversation, NSError *error) {
//                                    if(error){
//                                        NSLog(@"error=%@",error);
//                                    }else{
//                                        //
//                                        NSMutableArray* arrMsgs=[[NSMutableArray alloc]init];
//                                        NSArray* arrAVIMTypedMessage=[[conversation queryMessagesFromCacheWithLimit:1] copy];
//                                        for(AVIMTypedMessage* item in arrAVIMTypedMessage)
//                                        {
//                                            AVIMMessageMediaType msgType=item.mediaType;
//                                            switch (msgType) {
//                                                case kAVIMMessageMediaTypeText:{
//                                                    [arrMsgs addObject:item.text];
//                                                    break;
//                                                }
//                                                case kAVIMMessageMediaTypeImage:{
//                                                    [arrMsgs addObject:@"[图片]"];
//                                                    break;
//                                                }
//                                                case kAVIMMessageMediaTypeAudio:{
//                                                    [arrMsgs addObject:@"[语音]"];
//                                                    break;
//                                                }
//                                                case kAVIMMessageMediaTypeVideo:{
//                                                    [arrMsgs addObject:@"[视频]"];
//                                                    break;
//                                                }
//                                                case kAVIMMessageMediaTypeLocation:{
//                                                    [arrMsgs addObject:@"[位置]"];
//                                                    break;
//                                                }
//                                                default:
//                                                    break;
//                                            }
//                                        }
//                                        if(arrMsgs)
//                                            strChatContent=[arrMsgs componentsJoinedByString:@","];
//                                    }
//                                    flg_complete_getLastMessage=YES;
//                                    flg_exec_once=NO;
//                                }];
//                                flg_exec_once=YES;
//                            }
//                            [NSThread sleepForTimeInterval:0.06f];//每执行一次停顿0.06秒
//                        } while (!flg_complete_getLastMessage);
//                        ext.str4=@"0";
//                    }
//                    ext.str3=[NSString stringWithFormat:@"%@",strChatContent];
//                    [LibUserDefaultsExtModel addExtModelInCache:ext];//本地缓存
//                }
//            }
//        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //通知界面刷新
//            if(isNeedRefresh)
//            {
//                self.datasource=[[LibUserDefaultsExtModel getExtModelListInCache]mutableCopy];
//                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//            }
//        });
//    });
//}
//
//-(NSString*)getUserInfoById:(NSString*)strID
//{
////    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?targetUserId=%@",CMAPIBaseURL,API_USER_PRPFILE,self.selfClientID]];//这里暂时先写4 后面修改
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?targetUserId=%@",CMAPIBaseURL,API_USER_PRPFILE,strID]];
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//    return str;
//}
//
//-(void)returnBack{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//-(void)reloadData
//{
//    [self.tableView reloadData];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
////
////- (void)openSessionByClientId:(NSString*)clientId navigationToIMWithTargetClientIDs:(NSArray *)clientIDs {
////    WEAKSELF
////    NSLog(@"%@",clientId);
////    [[LeanMessageManager manager] openSessionWithClientID:clientId completion:^(BOOL succeeded, NSError *error) {
////        if(!error){
////            ConversationType type;
////            if(clientIDs.count>1){
////                type=ConversationTypeGroup;
////            }else{
////                type=ConversationTypeOneToOne;
////            }
////            [[LeanMessageManager manager] createConversationsWithClientIDs:clientIDs conversationType:type completion:^(AVIMConversation *conversation, NSError *error) {
////                if(error){
////                    NSLog(@"error=%@",error);
////                }else{
////                    ChatViewController *vc=[[ChatViewController alloc] initWithConversation:conversation];
////                    vc.ChatName=@"Chat";
////                    [weakSelf.navigationController pushViewController:vc animated:YES];
////                }
////            }];
////        }else{
////            NSLog(@"error=%@",error);
////        }
////    }];
////}
//
//- (void)openSessionByClientId:(NSString*)clientId navigationToIMWithTargetClientIDs:(NSArray *)clientIDs StringChatName:(NSString*)chatName {
//    WEAKSELF
//    NSLog(@"%@",clientId);
//    [[LeanMessageManager manager] openSessionWithClientID:clientId completion:^(BOOL succeeded, NSError *error) {
//        if(!error){
//            ConversationType type;
//            if(clientIDs.count>1){
//                type=ConversationTypeGroup;
//            }else{
//                type=ConversationTypeOneToOne;
//            }
//            [[LeanMessageManager manager] createConversationsWithClientIDs:clientIDs conversationType:type completion:^(AVIMConversation *conversation, NSError *error) {
//                if(error){
//                    NSLog(@"error=%@",error);
//                }else{
//                    ChatViewController *vc=[[ChatViewController alloc] initWithConversation:conversation];
//                    vc.ChatName=chatName;
//                    vc.chatUserId=clientIDs[0];
//                    vc.isFromMessage=YES;
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
//                }
//            }];
//        }else{
//            NSLog(@"error=%@",error);
//        }
//    }];
//}
//
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        
//        IMConsTableViewCell* cell = (IMConsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        NSString *chatName=cell.strName;
//        [self openSessionByClientId:self.selfClientID navigationToIMWithTargetClientIDs:cell.arrIdentifier StringChatName:chatName];
//    }
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    //PYLog(@"%@",self.datasource);
//    return self.datasource.count;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat h=0;
//    if (section==0)
//        h=HEADTABLEHIGHT;
//    return h;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat h=0;
//    if(indexPath.section==0)
//        h=CELLTABLEHIGHT;
//    return h;
//    
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width,HEADTABLEHIGHT)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIndentifier=@"consCell";
//    IMConsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//    if (!cell) {
//        cell=[[IMConsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
//        cell.backgroundColor=[UIColor colorWithHexString:BGTABLECOLOR];
//    }
//    ExtModel* extModel=[NSKeyedUnarchiver unarchiveObjectWithData:[self.datasource objectAtIndex:indexPath.row]];
//    cell.arrIdentifier=extModel.arr1;
//    cell.strAvatar=[extModel.arr3 componentsJoinedByString:@","];
//    cell.strName=[extModel.arr2 componentsJoinedByString:@","];
////    cell.strName=[extModel.arr1 componentsJoinedByString:@","];
//    cell.strOther=extModel.str3;
////    cell.strLastTime=[LibTimeParse dateStringParse:extModel.str2];
//    cell.strLastTime=[LibTimeParse dateParse:extModel.str2];
////    cell.arrIdentifier=extModel.arr1;
//    return cell;
//}
//
//
//
///*
// // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
// // Return NO if you do not want the specified item to be editable.
// return YES;
// }
// */
//
///*
// // Override to support editing the table view.
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
// if (editingStyle == UITableViewCellEditingStyleDelete) {
// // Delete the row from the data source
// [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
// } else if (editingStyle == UITableViewCellEditingStyleInsert) {
// // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
// }
// }
// */
//
///*
// // Override to support rearranging the table view.
// - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
// }
// */
//
///*
// // Override to support conditional rearranging of the table view.
// - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
// // Return NO if you do not want the item to be re-orderable.
// return YES;
// }
// */
//
///*
// #pragma mark - Navigation
// 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }
// */
//
//@end
