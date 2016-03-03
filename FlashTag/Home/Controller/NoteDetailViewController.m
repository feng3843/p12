//
//  NoteDetailViewController.m
//  FlashTag
//
//  Created by 夏雪 on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  帖子详情
#import "PYAllCommon.h"
#import "NoteDetailViewController.h"
#import "NoteDetailInfoView.h"
#import "NoteDetailFrame.h"
#import "NoteDetailModel.h"
#import "NotePraiseView.h"
#import "NoteCommentView.h"
#import "NoteCommentModel.h"
#import "NoteConst.h"
#import "NoteMoreComment.h"
#import "NoteAddComment.h"
#import "UIView+AutoLayout.h"
#import "AssumeYouLike.h"
#import "UIImage+Extensions.h"
#import "UIView+Extension.h"
#import "MJExtension.h"
#import "NSString+Extensions.h"
#import "CommonInterface.h"
#import "ConfirmBuyViewController.h"
#import "NSDate+Extensions.h"
#import "FolderOperationViewController.h"
#import "UIViewController+Puyun.h"
#import "VisitSellerViewController.h"
#import "BiaoQianVC.h"
#import "UIView+AutoLayout.h"

@interface NoteDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,NoteMoreCommentDelegate,NoteAddCommentDelegate,UIActionSheetDelegate,FolderOperationViewControllerDelegate,NoteDetailInfoViewDelegate,UIAlertViewDelegate,AssumeYouLikeDelegate>
{
    NSString* noteId;
    NoteMoreComment *noteMoreCommentCell;
    BOOL loading;
}


// 导航栏
@property(nonatomic ,weak)UIImageView *headImage;
@property(nonatomic ,weak)UILabel *nameLable;
@property(nonatomic ,weak)UILabel *addressLable;


@property(nonatomic ,weak)UITableView *noteDetailTable;
@property(nonatomic ,strong)NSMutableArray *noteDetails;
@property(nonatomic ,strong)NoteDetailFrame *noteDetailF;
@property(nonatomic ,strong)NSMutableArray *noteComments;
@property(nonatomic ,strong)NSMutableArray *notePraisedUser;
@property(nonatomic ,strong)NSMutableArray *noteArray;
//@property(nonatomic,weak)UICollectionView *likeCollection;
/** 回复提示*/
@property(nonatomic,weak)UILabel *replyPrompt;
/** 回复文本框*/
@property(nonatomic,weak)UITextView *replyTextView;
/** 回复*/
@property(nonatomic,weak)UIView *replyView;

@property(nonatomic,copy)NSString *currentTargetUserId;
@property(nonatomic,copy)NSString *currentTargetUserName;

// 底部按钮
@property(nonatomic,weak)UIButton *collectionBtn;
@property(nonatomic,weak)UIButton *lastBtn;
@property(nonatomic,weak)UIButton *praiseBtn;

@end
//
//
//static NSString *likeCollectionId = @"AssumeYouLikeId";
@implementation NoteDetailViewController
@synthesize noteId;

- (NSMutableArray *)noteComments
{
    if (_noteComments == nil) {
        _noteComments = [NSMutableArray array];
    }
    return _noteComments;
}
- (NSMutableArray *)noteDetails
{
    if (_noteDetails == nil) {
        _noteDetails = [NSMutableArray array];
    }
    return _noteDetails;
}
- (NSMutableArray *)notePraisedUser
{
    if (_notePraisedUser == nil) {
        _notePraisedUser = [NSMutableArray array];
    }
    return _notePraisedUser;
}
- (NSMutableArray *)noteArray
{
    if (_noteArray == nil) {
        _noteArray = [NSMutableArray array];
    }
    return _noteArray;
}
- (NoteDetailFrame *)noteDetailF
{
    if (_noteDetailF == nil) {
        _noteDetailF = [[NoteDetailFrame alloc]init];
    }
    return _noteDetailF;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   self.view.autoresizingMask = UIViewAutoresizingNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    loading=NO;
   
    UITableView *noteDetailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight - 44 *rateH) style:UITableViewStyleGrouped];
    noteDetailTable.dataSource = self;
    noteDetailTable.delegate = self;
    noteDetailTable.backgroundColor = PYColor(@"e7e7e7");
    noteDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.noteDetailTable = noteDetailTable;
 
    [self.view addSubview:noteDetailTable];
    
    [noteDetailTable autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 44 *rateH, 0)];
//    [noteDetailTable autoSetDimension:ALDimensionHeight toSize:44  *rateH];
//    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    // 隐藏时间
    //footer.refreshingTitleHidden = YES;
    
    // 隐藏状态
    footer.refreshingTitleHidden = YES;
    
    NSArray* refreshingImages = [CMTool getRefreshingImages];
    
    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateIdle];
    // 设置无新数据状态的动画图片
    [footer setImages:@[[UIImage imageNamed:IMG_DEFAULT_HOME_FIND_LISTEND]] forState:MJRefreshStateNoMoreData];
    
    self.noteDetailTable.footer = footer;
    
    // 导航栏
    [self setupNav];

    // 回复评论
    [self setupReply];
    
    // 底部
    [self setupBottom];

}
- (void)dealloc
{
    [PYNotificationCenter removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    UIImage *image = [UIImage resizedImage:@"bg_home_2nav"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
//        [PYNotificationCenter addObserver:self selector:@selector(keyboardFrameChange:) name:UITextFieldTextDidChangeNotification object:nil];
//   

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    UIImage *image = [UIImage resizedImage:@"bg_home_2nav"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [PYNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)setupNav
{
 
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200*rateW, 44)];

    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(-20*rateW,0, 44 *rateW+10, 44)];
    [backBtn setImage:[UIImage imageNamed:@"ic_home_back"] forState:UIControlStateNormal];
//    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [bgView addSubview:backBtn];
    

    CGFloat space = 7 *rateW ;
    /** 头像*/
    CGFloat headImageX = 0 *rateW + CGRectGetMaxX(backBtn.frame);
    CGFloat headImageWH = 31.0f *rateW;
    CGFloat headImageY = 6.5 *rateH;
    UIImageView *headImage =[[UIImageView alloc]initWithFrame:CGRectMake(headImageX, headImageY, headImageWH, headImageWH)];
    self.headImage = headImage;
    headImage.userInteractionEnabled = YES;
    headImage.layer.cornerRadius = 15.5 *rateW;
    headImage.clipsToBounds = YES;
//        self.headImage.backgroundColor = [UIColor redColor];
    
    headImage.image = [UIImage imageNamed:@"img_default_user"];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageClick)];
    [headImage addGestureRecognizer:gestureRecognizer];
    
    [bgView addSubview:headImage];
    
    /** 名字*/
    CGFloat nameX = CGRectGetMaxX(headImage.frame) + space;
    CGFloat nameY = 8 *rateH;
    CGFloat nameW = 200 *rateW;
    CGFloat nameH = 12 *rateH;
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
    self.nameLable = nameLable;
    nameLable.textColor = noteDetailNameColor;
    nameLable.text = @"夏雪";
    nameLable.font = noteDetailNameFont ;
    [bgView addSubview:nameLable];
    
    /** 定位地址*/
    CGFloat addressX = nameX;
    CGFloat addressY = 23 *rateH;
    CGFloat addressW = nameW;
    CGFloat addressH = 12 *rateH;
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(addressX, addressY, addressW, addressH)];
    self.addressLable = addressLable;
    addressLable.textColor = noteAddressTextColor;
    addressLable.text = @"定位发帖地址";
    addressLable.font = noteAddressFont;
    [bgView addSubview:addressLable];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bgView];
    UIImage *rightImg = [UIImage imageNamed:@"ic_home_2more"];
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //更多按钮
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
  
}

- (void)headImageClick
{
   
    
    if ([self.noteDetailF.noteInfo.role isEqualToString:@"2"]) {
        VisitSellerViewController *vc = [VisitSellerViewController new];
        
        vc.userId = self.noteDetailF.noteInfo.userId;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.returnBackBlock = ^(NSString *str) {
            self.returnBackBlock(str);
        };
    }else if ([self.noteDetailF.noteInfo.role isEqualToString:@"0"]){
        
        VisitBuyerViewController *vc = [VisitBuyerViewController new];
        
        vc.userId = self.noteDetailF.noteInfo.userId;
        [self.navigationController pushViewController:vc animated:YES];
        vc.returnBackBlock = ^(NSString *str) {
          self.returnBackBlock(str); 
        };
    }
}
- (void)setupReply
{
    UIView *replyView = [[UIView alloc]initWithFrame:CGRectMake(0, fDeviceHeight -64 , fDeviceWidth  , 43*rateH)];
    replyView.backgroundColor = PYColor(@"ffffff");
    self.replyView = replyView;
    [self.view addSubview:replyView];
//    [replyView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
//    [replyView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
//    [replyView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.view];
//    [replyView autoSetDimension:ALDimensionHeight toSize:43 *rateH];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = PYColor(@"cccccc");
    [replyView addSubview:line];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [line autoSetDimension:ALDimensionHeight toSize:0.5 *rateH ];
    
    UITextView *replyTextView = [[UITextView alloc]init];
  //  [replyTextView setTextColor:PYColor(@"a9a9a9")];
    replyTextView.font = PYSysFont(14 *rateH);
    self.replyTextView = replyTextView;
    self.replyTextView.delegate = self;
    replyTextView.textContainerInset = UIEdgeInsetsMake(14.5 *rateH, 0, 0, 0);
    [replyView addSubview:replyTextView];
    replyTextView.returnKeyType = UIReturnKeySend;
//    replyTextView.backgroundColor = PYColor(@"000000");
//    replyTextView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [replyTextView setTintColor:PYColor(@"a9a9a9")];
    replyTextView.delegate = self;
    [replyTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.5 *rateH, 19 *rateW, 0, 0)];
    replyTextView.enablesReturnKeyAutomatically = YES;
    UILabel *replyPrompt = [[UILabel alloc]init];
    replyPrompt.text = @"回复。。。。";
    replyPrompt.font = PYSysFont(14 *rateH);
    replyPrompt.textColor = PYColor(@"a9a9a9");
    [replyView addSubview:replyPrompt];
    //replyPrompt.backgroundColor = [UIColor redColor];
    self.replyPrompt = replyPrompt;
    [replyPrompt autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.5 *rateH, 25 *rateW, 0, 0)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
}

- (void)setupBottom
{
    
  
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, fDeviceHeight - 44 *rateH , fDeviceWidth, 44 *rateH)];
    
    bottomView.backgroundColor = PYColor(@"ffffff");
//    PYLog(@"ffffffffff%f",self.view.frame.origin.y);
    bottomView.alpha = 0.9;
    [self.view addSubview:bottomView];
    
   [bottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [bottomView autoSetDimension:ALDimensionHeight toSize:44  *rateH];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, 0.5 *rateH)];
    line.backgroundColor = PYColor(@"cccccc");
    [bottomView addSubview:line];
    
    
    UIButton *praiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(24 *rateW, 0, 20 *rateH, 44*rateH)];
    [praiseBtn setImage:[UIImage imageNamed:@"ic_home_normal_2praise"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"ic_home_press_2praise"] forState:UIControlStateSelected];
//     [praiseBtn setImage:[UIImage imageNamed:@"ic_home_press_2praise"] forState:UIControlStateSelected];
    [praiseBtn addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:praiseBtn];
    self.praiseBtn = praiseBtn;
    UIButton *backToHome = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(praiseBtn.frame) + 24 *rateW, 0, 20 *rateH, 44*rateH)];
    [backToHome setImage:[UIImage imageNamed:@"ic_home_normal_backhome"] forState:UIControlStateNormal];
    [backToHome addTarget:self action:@selector(backToHomeClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:backToHome];
    
    UIButton *collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backToHome.frame) + 24 *rateW, 0, 20 *rateH, 44*rateH)];
    [collectionBtn setImage:[UIImage imageNamed:@"ic_home_normal_2collectnote"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"ic_home_press_2collectnote"] forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:collectionBtn];
    self.collectionBtn = collectionBtn;
    
    UIButton *lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(fDeviceWidth - 82*rateW - 15 *rateW, 6 *rateH, 82 *rateW, 30 *rateH)];
    self.lastBtn = lastBtn;
   [lastBtn setImage:[UIImage imageNamed:@"btn_home_normal_collectnote"] forState:UIControlStateNormal];
   [lastBtn setImage:[UIImage imageNamed:@"btn_home_press_collectnote"] forState:UIControlStateSelected];
   
    [bottomView addSubview:lastBtn];
    [lastBtn addTarget:self action:@selector(lastBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)keyboardFrameChange:(NSNotification *)note
{
    NSValue* aValue = [note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
   // PYLog(@"eeee%f",keyboardRect.origin.y );
    self.replyView.y =  keyboardRect.origin.y - 43*rateH -64 ;
   // self.replyView.hidden = (keyboardRect.origin.y == fDeviceHeight);
   // self.replyView.backgroundColor = [UIColor redColor];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.replyPrompt.hidden = NO;
    }else
    {
        self.replyPrompt.hidden = YES;
        
    }
}

- (void)setNoteId:(NSString *)strNoteId
{
    
//    [self loadGif];
    
    noteId = strNoteId;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"noteId"] = noteId;
    param[@"more"] = @"yes";
    
    if(![[CMData getUserId] isEqualToString:@""])
    {
        param[@"userId"] = [CMData getUserId];
    }   
    
    [CMAPI postUrl:API_USER_NOTEDETAIL Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        PYLog(@"%@",result);
        if(succeed)
        {
  
            NoteDetailModel *model = [NoteDetailModel objectWithKeyValues:result];
            NoteDetailFrame *modleFrame = [[NoteDetailFrame alloc]init];
            modleFrame.noteInfo = model;
            self.model = model;
            self.noteDetailF = modleFrame;
            self.nameLable.text = model.userDisplayName;
            self.addressLable.text = model.noteLocation;
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"userIcon/icon%@.jpg",model.userId]]]placeholderImage:[UIImage imageNamed:@"img_default_user"]];
            
            [self getupNoteComments];
           
            //NSArray *item = [result objectForKey:@"praisedUserList"];
            
            self.notePraisedUser = [result objectForKey:@"praisedUserList"];
            
          //  [self callingInterfacenoteList:model.tags];
            
            self.collectionBtn.hidden = YES;
            if (model.isForSale) {
                self.collectionBtn.hidden = NO;
                self.collectionBtn.selected = model.isCollect;
                [self.lastBtn setImage:[UIImage imageNamed:@"btn_home_normal_trade"] forState:UIControlStateNormal];
                [self.lastBtn setImage:[UIImage imageNamed:@"btn_home_press_trade"] forState:UIControlStateSelected];
                 [self.lastBtn setImage:[UIImage imageNamed:@"btn_home_disable_trade"] forState:UIControlStateDisabled];
                if([model.leftDays isEqualToString:@"0"]&&[model.fileType isEqualToString:@"pay"])
                {
                    self.lastBtn.enabled = NO;
                }
            }else
            {
               self.lastBtn.selected = model.isCollect;
            }
            self.praiseBtn.selected =model.isLiked;
            
            if ([model.noteLocation isEqualToString:@""]) {
                self.nameLable.y = 0;
                self.nameLable.height = 44;
            }else
            {
                self.nameLable.y = 8 *rateH;
                self.nameLable.height = 12 *rateH;
                
            }
           
            [self.noteDetailTable reloadData];
            
  
        }else
        {
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
        
        [self loadEnd];
    }];
}


#pragma mark - 接口调试
///** 获取帖子信息*/
//- (void)getupNoteDetailInfo
//{
//
//    
//}
/** 获取评论信息*/
- (void)getupNoteComments
{
    NSDictionary *param = @{@"noteId":self.noteDetailF.noteInfo.noteId,
                            @"orderRanking":@(self.noteComments.count),
                            @"count":self.noteComments.count == 0?@(2):@(10)
                            };
    [CMAPI postUrl:API_USER_GETCOMMENTLIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
       // PYLog(@"xxxxxx%@",result);
        if(succeed)
        {
         
          //  [self.noteComments removeAllObjects];
            [self.noteComments addObjectsFromArray:[NoteCommentModel objectArrayWithKeyValuesArray:[result objectForKey:@"commentList"]]];
            
            [self.noteDetailTable reloadData];
  
        }else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }else{
                [noteMoreCommentCell setHidden4MoreBtn:YES];
            }
        }
        
    }];
    
}

- (void)callingInterfacePostComment:(NSString *)text
{
    NSDictionary *param = @{@"noteId":self.noteDetailF.noteInfo.noteId,
                            @"noteOwnerId":self.noteDetailF.noteInfo.userId,
                            @"commentContent":text,
                            @"targetUserId":self.currentTargetUserId,
                            @"userId":@([CMData getUserIdForInt]),
                            @"token":[CMData getToken]
                            };
    [CommonInterface callingInterfacePostComment:param succeed:^{
        
        NoteCommentModel *model = [[NoteCommentModel alloc]init];
        model.userName = [CMData getUserName];
        model.userId = [CMData getUserId];
        
        NSDate *  senddate=[NSDate new];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        model.commentTime = locationString;
        model.commentContent = text;
        model.targetUserId = self.currentTargetUserId;
        model.targetUserName = self.currentTargetUserName;
        model.noteOwnerId = self.noteDetailF.noteInfo.userId;
        [self.noteComments insertObject:model atIndex:0];
        [self.noteDetailTable reloadData];
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
    }];
}
/**
 *  猜你喜欢接口
 *
 *  @param tag <#tag description#>
 */
- (void)callingInterfacenoteList:(NSString *)tag
{
   NSInteger count = self.noteArray.count;
//    if (loading ||count >= 40)
//    {
//        if(count>=40)
//        {
//            [self.noteDetailTable.footer noticeNoMoreData];
//            
//            loading=NO;
//        }
//        return;
//    }
    loading=YES;
//    self.noteDetailTable.scrollEnabled = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"orderRule"] = @"noteDetail";
    param[@"tagNames"] = tag;
    param[@"orderRanking"] =@(count);
    if (![[CMData getUserId] isEqualToString:@""]) {
        param[@"userId"] = @([CMData getUserIdForInt]);
    }
    if(40 - count >= 10)
    {
            param[@"count"]=@(10);
    }else
    {
        param[@"count"]=@(40 - count);
    }
    PYLog(@"cccccc%@",param);
    
//    param[@"count"]=[NSString stringWithFormat:@"%d",(40 - count)];
    [CMAPI postUrl:API_GET_NOTELIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"];
        
        if(succeed)
        {
//             self.noteDetailTable.scrollEnabled = YES;
            //            [self.noteArray r]
            [self.noteArray addObjectsFromArray:[NoteInfoModel objectArrayWithKeyValuesArray:[result objectForKey:@"noteList"]]];
           // PYLog(@"xxxxxxxxXXXX%@",self.noteArray);
            NSInteger count = self.noteArray.count;
          
                if(count>=40)
                {
                    [self.noteDetailTable.footer noticeNoMoreData];
                 }
          
            
            [self.noteDetailTable reloadData];
            //[self loadEnd];
        }else
        {
            //  [self loadEnd];
               self.noteDetailTable.scrollEnabled = YES;
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }
            else
            {
                if (self.noteArray.count > 0) {
                    [self.noteDetailTable.footer noticeNoMoreData];
                }
            }
        }
        loading=NO;
        
    }];
}

#pragma mark - tableView的方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (self.noteDetailF == nil) {
        return 0;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else if (section == 2)
        
    {
        if (self.noteComments.count) {
            return  self.noteComments.count + 1;
        }
    
    }else if(section == 3)
    {
        return 1;
    }else if(section == 4)
    {
        return self.noteArray.count * 0.5;
    }
        
    return 0;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * view = [[UIView alloc] init];
//    CGFloat SpaceX = 10 *rateW;
//    CGFloat allcommentY = 16 *rateH;
//    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(allcommentY, SpaceX, 0, 0) excludingEdge:ALEdgeBottom];
//    [view autoSetDimension:ALDimensionHeight toSize:13 *rateH];
//    UILabel *allComment = [[UILabel alloc]init];
//    allComment.text = @"所有评论";
//    allComment.textColor = noteAllCommentTextColor;
//    allComment.font = noteAllCommentFont;
//    [view addSubview:allComment];
//    return view;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 帖子信息*/
    if (indexPath.section == 0) {
        static NSString *noteDetailId = @"noteDetail";
        NoteDetailInfoView *cell = [tableView dequeueReusableCellWithIdentifier:noteDetailId];
        if (cell == nil) {
            cell = [[NoteDetailInfoView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteDetailId];
            cell.delegate = self;
        }
        cell.noteInfoFrame = self.noteDetailF;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    /** 点赞*/
    else if (indexPath.section == 1)
    {
        static NSString *notePraiseId = @"notePraise";
        NotePraiseView *cell = [tableView dequeueReusableCellWithIdentifier:notePraiseId];
        if (cell == nil) {
            cell = [[NotePraiseView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notePraiseId];
        }
        cell.notePraisedUser = self.notePraisedUser;
        cell.likes = self.noteDetailF.noteInfo.likes;
        cell.comments = self.noteDetailF.noteInfo.comments;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
    }
    /** 评论*/
    else if(indexPath.section == 2)
    {
        if (indexPath.row < self.noteComments.count) {
            static NSString *noteCommentId = @"noteComment";
            NoteCommentView *cell = [tableView dequeueReusableCellWithIdentifier:noteCommentId];
            if (cell == nil) {
                cell = [[NoteCommentView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteCommentId];
            }
        //    PYLog(@"xxxxxxx%ld",indexPath.row);
            cell.isFirst = (indexPath.row == 0);
//            if(indexPath.row == 9)
//            {
//                PYLog(@"xxxxxxx%ld",indexPath.row);
//            }
//            else
//            {
//                cell.allComment.text = @"所有评论";
//            }
//            if (indexPath.row == (self.noteComments.count - 1)) {
//                cell.isLast = YES;
//            }else
//            {
//                cell.isLast = NO;
//            }
//            
            NoteCommentModel *model = self.noteComments[indexPath.row];
            cell.commentModel = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
      /** 更多评论*/
       else
        {
            static NSString *noteMoreCommentId = @"noteMoreComment";
            noteMoreCommentCell = [tableView dequeueReusableCellWithIdentifier:noteMoreCommentId];
        
            if (noteMoreCommentCell == nil) {
                noteMoreCommentCell = [[NoteMoreComment alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteMoreCommentId];
                noteMoreCommentCell.delegate = self;
            }
            noteMoreCommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return noteMoreCommentCell;
            
        }
     
    }
     /** 增加一条评论*/
    else if(indexPath.section == 3)
    {
        static NSString *noteAddCommentId = @"noteAddComment";
        NoteAddComment *cell = [tableView dequeueReusableCellWithIdentifier:noteAddCommentId];
        if (cell == nil) {
            cell = [[NoteAddComment alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteAddCommentId];
            cell.delegate = self;
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    /** 猜你喜欢*/
    else if (indexPath.section == 4)
    {
        static NSString *youLike = @"assumeYouLike";
       AssumeYouLike *cell = [tableView dequeueReusableCellWithIdentifier:youLike];
        if (cell == nil) {
            cell = [[AssumeYouLike alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:youLike];
            cell.delegate = self;
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.NoteInfoModelFirst = self.noteArray[indexPath.row * 2];
        cell.NoteInfoModelSec = self.noteArray[indexPath.row * 2+ 1];
        cell.isFirst = (indexPath.row == 0);
        //cell.backgroundColor = PYColor(@"e7e7e7");
        return cell;
        
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       return self.noteDetailF.cellHeight;
    }else if (indexPath.section == 1)
    {
        return 82 *rateH;
    }else if (indexPath.section == 2)
    {
          if (indexPath.row < self.noteComments.count) {
              if (indexPath.row == 0) {
                  NoteCommentModel *model = self.noteComments[indexPath.row];
                  
                  PYLog(@"%@",model.userId);
                  NSDictionary *commentDic = @{NSFontAttributeName: noteCommentFont};
                  CGFloat commentW = fDeviceWidth - noteCommentX - PYSpaceX;
                  CGSize  commentSize = [model.commentContent boundingRectWithSize:CGSizeMake(commentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:commentDic context:nil].size;
                  return noteIsFirstCommentY + commentSize.height + 16 *rateH ;
                  //            return 100;
              }else {
//                  static NSString *noteCommentId = @"noteComment";
                  //  NoteCommentView *cell = [tableView dequeueReusableCellWithIdentifier:noteCommentId];
                  //    cell.allComment.text=@"";
                  NoteCommentModel *model = self.noteComments[indexPath.row ];
                  NSDictionary *commentDic = @{NSFontAttributeName: noteCommentFont};
                  CGFloat commentW = fDeviceWidth - noteCommentX - PYSpaceX;
                  CGSize  commentSize = [model.commentContent boundingRectWithSize:CGSizeMake(commentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:commentDic context:nil].size;
                  return noteNoFirstCommnetY + commentSize.height + 16 *rateH;
              }
          }else
           {
            return 40.0 *rateH;
          }

    }else if (indexPath.section ==3)
    {
        return 60 * rateH;
    }else if (indexPath.section ==4)
    {
        
        return indexPath.row == 0 ? (210 + 30)*rateH : (210 + 10)*rateH;
    }


        return 44;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section ==3) {
        return 10 *rateH;
    }

    return 0.05;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        if (indexPath.row < self.noteComments.count) {
            NoteCommentModel *model = self.noteComments[indexPath.row];
            if(![model.userId isEqualToString:[CMData getUserId]])
            {
                NSString *title = [NSString stringWithFormat:@"回复 %@:",model.userName];
                self.currentTargetUserId = model.userId;
                self.currentTargetUserName = model.userName;
                [self addNoteComment:title];
            }
        }
    }
//    else
//    if (indexPath.section == 4)
//    {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
////        //
////        NoteInfoModel *model = self.noteArray[indexPath.row];
////        
////        NoteDetailViewController *note = [[NoteDetailViewController alloc]init];
////        note.noteId = model.noteId;
////        note.noteUserId = model.userId;
////        
////        //  note.tag = self.currentTag;
////        [self.navigationController pushViewController:note animated:YES];
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 0.05;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 按钮点击事件
// 返回按钮
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -最底下按钮点击事件

// 最后一个按钮（收藏获取代购）
- (void)lastBtnClick
{
    if (self.noteDetailF.noteInfo.isForSale) {
        if ([[CMData getToken] isEqualToString:@""]) {
            
            [SVProgressHUD showInfoWithStatus:DEFAULT_NO_LOGIN];
            return;
        }
        
            ConfirmBuyViewController *vc = [[ConfirmBuyViewController alloc]init];
            if([CMData getUserType]==0)
            {
                vc.userType = BuyUserTypeBuyer;
            }
            else
            {
                vc.userType = BuyUserTypeSeller;
            }
            vc.type = BuyTypeApply;
            vc.strID = self.noteDetailF.noteInfo.noteId;
            vc.strOwnerID = self.noteDetailF.noteInfo.userId;
            vc.strContent = self.noteDetailF.noteInfo.noteDesc;
            vc.strImage = [[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_1.jpg",[self.noteDetailF.noteInfo.userId get2Subs],self.noteDetailF.noteInfo.noteId]];
            vc.maxNum = 2;
            [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        NSDictionary *param = @{@"token":[CMData getToken],
                                @"userId":@([CMData getUserIdForInt]),
                                @"noteId":self.noteDetailF.noteInfo.noteId,
                                @"targetId":self.noteDetailF.noteInfo.userId,
                                @"type":self.lastBtn.selected?@"no":@"yes"
                                };
        
        [CommonInterface callingInterfaceCollectNote:param succeed:^{
            
            if (self.lastBtn.selected) {
                [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                self.lastBtn.selected = NO;
            }else
            {
                self.lastBtn.selected = YES;
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                
            }
        }];
    }
}

// 回到首页

- (void)backToHomeClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
// 点赞
- (void)praiseBtnClick
{
    
    
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"noteId":self.noteDetailF.noteInfo.noteId,
                            @"targetId":self.noteDetailF.noteInfo.userId,
                            @"isLiked":self.praiseBtn.selected?@"no":@"yes"};
    
    //    int likeCount = [self.praiseBtn.currentTitle intValue] ;
    [CommonInterface callingInterfacePraise:param succeed:^{
        
        //   [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
        if (self.praiseBtn.selected) {
            self.praiseBtn.selected = NO;
        }else
        {
            self.praiseBtn.selected = YES;
            [SVProgressHUD showSuccessWithStatus:@"积分+1"];
         
        }
    }];
}



// 收藏
- (void)collectionBtnClick
{
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"noteId":self.noteDetailF.noteInfo.noteId,
                            @"targetId":self.noteDetailF.noteInfo.userId,
                            @"type":self.collectionBtn.selected?@"no":@"yes"
                            };
    
    [CommonInterface callingInterfaceCollectNote:param succeed:^{
        
        if (self.collectionBtn.selected) {
            [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
            self.collectionBtn.selected = NO;
        }else
        {
            self.collectionBtn.selected = YES;
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            
        }
    }];
}



- (void)addNoteComment:(NSString *)title
{
    self.replyPrompt.text = title;
    self.replyPrompt.hidden = NO;
    [self.replyTextView  becomeFirstResponder];
}


-(void)moreBtnClick:(NoteInfoModel *)model
{
    [self moreClick];
}

#pragma mark -NoteMoreCommentDelegate
- (void)LoadMoreComment
{
    [self getupNoteComments];
}

#pragma mark - NoteAddCommentDelegate

-(void)addComment
{
    
//    if([self.noteDetailF.noteInfo.userId isEqualToString:[CMData getUserId]]) return;
    
//    NoteCommentModel *model = self.noteComments[indexPath.row];
   NSString *title = @"添加一条评论";
    self.currentTargetUserId = self.noteDetailF.noteInfo.userId;
    self.currentTargetUserName = self.noteDetailF.noteInfo.userDisplayName;
   
     [self addNoteComment:title];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [self callingInterfacePostComment:textView.text];
//        PYLog(@"%@",textView.text);
        [textView resignFirstResponder];
        textView.text = @"";
     //   [self.noteDetailTable reloadData];
        return NO;
    }
    
    if ([text isEqualToString:@" "]&&textView.text.length<=0) {
        return  NO;
    }
    return YES;
}

#pragma mark - NoteDetailInfoViewDelegate
-(void)tagBtnClickWithTitle:(NSString *)title
{
    BiaoQianVC *vc = [BiaoQianVC new];
    vc.biaoQianName = title;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadMoreData
{
    if(!loading)
    {
     [self callingInterfacenoteList:self.model.tags];
    }
 
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    
    // 刷新表格
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.noteDetailTable.footer endRefreshing];
    
}

#pragma mark - AssumeYouLikeDelegate
- (void)CommentBtnClick:(NSString *)nId withUserId:(NSString *)userId
{
    CommentViewController *commentVc = [[CommentViewController alloc]init];
    commentVc.noteId = nId;
    commentVc.noteOwnerId = userId;
    [self.navigationController pushViewController:commentVc animated:YES];
    commentVc.commentCount = ^(NSString *commentCount)
    {
        if (![commentCount isEqualToString:@"0"]) {
            for (NoteInfoModel *model in self.noteArray) {
                if([model.noteId isEqualToString:nId])
                {
                    
                    model.comments = @([model.comments intValue ] +[commentCount intValue]);
                    [self.noteDetailTable reloadData];
                    return;
                }
            }
        }
    };
}

- (void)noteClick:(NSString *)nId withUserId:(NSString *)userId
{
    NoteDetailViewController *note = [[NoteDetailViewController alloc]init];
    note.noteId = nId;
    note.noteUserId = userId;
    
            //  note.tag = self.currentTag;
    [self.navigationController pushViewController:note animated:YES];
}
@end
