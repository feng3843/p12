//
//  CommentViewController.m
//  FlashTag
//
//  Created by py on 15/9/23.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  评论

#import "CommentViewController.h"
#import "NoteCommentView.h"
#import "NoteCommentModel.h"
#import "NoteConst.h"
#import "CommonInterface.h"
#import "PYAllCommon.h"
#import "UIView+AutoLayout.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
#import "UIImage+Extensions.h"
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property(nonatomic,weak)UITableView *commentTable;
@property(nonatomic ,strong)NSMutableArray *noteComments;
@property(nonatomic,copy)NSString *currentTargetUserId;
@property(nonatomic, strong)NoteCommentModel *currentTargetModel;
/** 回复提示*/
@property(nonatomic,weak)UILabel *replyPrompt;
/** 回复文本框*/
@property(nonatomic,weak)UITextView *replyTextView;
/** 回复*/
@property(nonatomic,weak)UIView *replyView;
/**
 *  当前回复了几条
 */
@property(nonatomic,assign)int currentCommentCount;
@end

@implementation CommentViewController



- (NSMutableArray *)noteComments
{
    if (_noteComments == nil) {
        _noteComments = [NSMutableArray array];
    }
    return _noteComments;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    UIImage *image = [UIImage resizedImage:@"bg_home_2nav"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    UIImage *image = [UIImage resizedImage:@"bg_home_2nav"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    [self creatBackButton];
    self.title = @"评论";
    self.view.backgroundColor = PYColor(@"e7e7e7");
    UITableView *noteDetailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight-64) style:UITableViewStylePlain];
    noteDetailTable.dataSource = self;
    noteDetailTable.delegate = self;
    noteDetailTable.backgroundColor = PYColor(@"e7e7e7");
    noteDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentTable = noteDetailTable;
    [self.view addSubview:noteDetailTable];
    [noteDetailTable autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 43 *rateH, 0)];
   
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    self.commentTable.footer = footer;
    
    [self setupReply];
    [self getupNoteComments];
    self.currentCommentCount = 0;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    self.commentCount([NSString stringWithFormat:@"%d",self.currentCommentCount]);
       
}
- (void) creatBackButton {
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.frame = CGRectMake(kCalculateH(21), kCalculateV(12), kCalculateH(12), kCalculateV(20));
    [left setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
}
- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupReply
{
    UIView *replyView = [[UIView alloc]initWithFrame:CGRectMake(0, fDeviceHeight - 43 *rateH, fDeviceWidth, 43*rateH)];
//    UIView *replyView = [[UIView alloc]initWithFrame:CGRectMake(0, fDeviceHeight-300, fDeviceWidth, 43*rateH)];

    replyView.backgroundColor = PYColor(@"ffffff");
    self.replyView = replyView;
    [self.view addSubview:replyView];
//    [replyView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
//    [replyView autoSetDimension:ALDimensionHeight toSize:43  *rateH];
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
    replyTextView.enablesReturnKeyAutomatically = YES;
    [replyTextView setTintColor:PYColor(@"a9a9a9")];
  
    [replyTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.5 *rateH, 19 *rateW, 0, 0)];
    UILabel *replyPrompt = [[UILabel alloc]init];
    replyPrompt.text = @"添加一条评论";
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillHideNotification object:nil];
    [self.replyTextView becomeFirstResponder];

}


- (void)keyboardFrameChange:(NSNotification *)note
{
    NSValue* aValue = [note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    self.replyView.y =  keyboardRect.origin.y - 43*rateH;
//    self.replyView.y =  keyboardRect.origin.y - 43*rateH -(_isNoHead?64:0);
    //self.replyView.hidden = (keyboardRect.origin.y == fDeviceHeight);
    // self.replyView.backgroundColor = [UIColor redColor];
    if (note.name==UIKeyboardWillHideNotification) {
        [self addNoteComment:@"添加一条评论"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (textView.text.length>0) {
               [self callingInterfacePostComment:textView.text];
        }
        
        [textView resignFirstResponder];
        return NO;
    }
    if ([text isEqualToString:@" "]&&textView.text.length<=0) {
        return  NO;
    }
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self.commentTable showEmptyList:self.noteComments Image:IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_NODATASTRING ByCSS:NoDataCSSTop];
    return self.noteComments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *noteCommentId = @"noteComment";
    NoteCommentView *cell = [tableView dequeueReusableCellWithIdentifier:noteCommentId];
    if (cell == nil) {
        cell = [[NoteCommentView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteCommentId];
    }
    cell.isFirst = NO;

    NoteCommentModel *model = self.noteComments[indexPath.row];
    cell.commentModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCommentModel *model = self.noteComments[indexPath.row ];
    NSDictionary *commentDic = @{NSFontAttributeName: noteCommentFont};
    CGFloat commentW = fDeviceWidth - noteCommentX - PYSpaceX;
    CGSize  commentSize = [model.commentContent boundingRectWithSize:CGSizeMake(commentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:commentDic context:nil].size;
    return noteNoFirstCommnetY + commentSize.height + 16 *rateH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCommentModel *model = self.noteComments[indexPath.row];
    if(![model.userId isEqualToString:[CMData getUserId]])
    {    NSString *title = [NSString stringWithFormat:@"回复 %@:",model.userName];
        self.currentTargetUserId = model.userId;
        self.currentTargetModel=model;
        [self addNoteComment:title];
        
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)addNoteComment:(NSString *)title
{
    
    self.replyPrompt.text = title;
    self.replyPrompt.hidden = YES;
    [self.replyTextView  becomeFirstResponder];
    
}

- (void)callingInterfacePostComment:(NSString *)text
{
    
    if([self.currentTargetUserId isEqualToString:@""] ||self.currentTargetUserId == nil)
    {
        self.currentTargetUserId = self.noteOwnerId;
    }
    NSDictionary *param = @{@"noteId":self.noteId,
                            @"noteOwnerId":self.noteOwnerId,
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
        model.noteOwnerId=_currentTargetModel.noteOwnerId==nil?model.targetUserId:_currentTargetModel.noteOwnerId;
        model.targetUserName=_currentTargetModel.userName;
        [self.noteComments insertObject:model atIndex:0];
        [self.commentTable reloadData];
        _replyTextView.text=@"";
        self.replyPrompt.hidden=NO;
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        self.currentCommentCount ++ ;

    }];
}
/** 获取评论信息*/
- (void)getupNoteComments
{
    NSDictionary *param = @{@"noteId":self.noteId,
                            @"orderRanking":@(self.noteComments.count),
                            @"count":@(10)
                            };
    [CMAPI postUrl:API_USER_GETCOMMENTLIST Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        PYLog(@"xxxxxx%@",result);
        if(succeed)
        {
            
            
            
            [self.noteComments addObjectsFromArray:[NoteCommentModel objectArrayWithKeyValuesArray:[result objectForKey:@"commentList"]]];
            
            [self.commentTable reloadData];
            
        }else
        {
            if (![[result objectForKey:@"code"] isEqualToString:@"4011"]) {
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
            }else{
                
                if (self.noteComments.count > 0)
                {
                    [self.commentTable.footer noticeNoMoreData];
                }
            }
        }
        
        [self.commentTable showEmptyList:self.noteComments Image:IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_NODATA Desc:IMG_DEFAULT_PERSONALCENTER_SETTING_MYDISCUESS_NODATASTRING ByCSS:NoDataCSSTop];
    }];
    
}


- (void)loadMoreData
{
   
    [self getupNoteComments];
   
    [self.commentTable.footer endRefreshing];
    
}
@end
