//
//  AddTagsViewController.m
//  FlashTag
//
//  Created by py on 15/9/8.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  添加帖子标签

#import "AddTagsViewController.h"
#import "PYAllCommon.h"
#import "AddTagsCell.h"
#import "UIView+Extension.h"

#define bottomViewH 60*rateH
#define btnTextSize PYSysFont(13 *rateW)
#define btnMargin 16 * rateH
#define btnH 30 *rateH
#define btnColor PYColor(@"3385cb")
@interface AddTagsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *systemTags;
@property(nonatomic,weak)UITableView *mainTable;
@property(nonatomic,weak)UIView *bottomView;
@property(nonatomic,weak)UIButton *oneBtn;
@property(nonatomic,weak)UIButton *twoBtn;
@property(nonatomic,weak)UIButton *threeBtn;
@property(nonatomic,weak)UIButton *fourBtn;
@property(nonatomic,weak)UITextField *textField;
@property(nonatomic,weak)UIButton *selectBtn;
@property(nonatomic ,strong)NSMutableArray *addTagsArray;
@end

@implementation AddTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = viewBackgroundColor;
    self.title = @"添加标签";
    UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    completeBtn.backgroundColor = [UIColor redColor];
    [completeBtn setTitleColor:btnColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    

    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:mainTable];
    
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self callingGetSysAndHotTags];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, fDeviceHeight - bottomViewH, fDeviceWidth, bottomViewH )];
    bottomView.backgroundColor = PYColor(@"eeeeee");
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(PYSpaceX, 10, 240 *rateW, 40 *rateH)];
    textField.placeholder = @"新建一个标签...";
    textField.backgroundColor = PYColor(@"cccccc");
    textField.layer.cornerRadius = 5;
    textField.delegate = self;
    self.textField = textField;
    [bottomView addSubview:textField];
    [self.view addSubview:bottomView];
    
    CGFloat confirmBtnW =32 *rateW;
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(fDeviceWidth -confirmBtnW -PYSpaceX , 10, confirmBtnW, 40 *rateH)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = PYSysFont(16 *rateW);
    [confirmBtn setTitleColor:PYColor(@"cccccc") forState:UIControlStateNormal];
    [bottomView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchDown];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
 
    CGRect frame = mainTable.frame;
    frame.size.height = frame.size.height - CGRectGetHeight(bottomView.frame);
    mainTable.frame = frame;
    self.mainTable = mainTable;
}

- (void)viewDidAppear:(BOOL)animated
{

        [super viewDidAppear:animated];
}
- (void)setTags:(NSString *)tags
{
    _tags = tags;

}
- (void)keyboardFrameChange:(NSNotification *)note
{
    NSValue* aValue = [note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];

   self.bottomView.y =  keyboardRect.origin.y - bottomViewH ;
  

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
//    PYLog(@"ssss%@",string);
    if([CMTool stringContainsEmoji:string]) return NO;
    return YES;
}

- (NSMutableArray *)addTagsArray
{
    if (_addTagsArray == nil) {
        _addTagsArray = [NSMutableArray array];
    }
    return _addTagsArray;
}
- (NSMutableArray *)systemTags
{
    if (_systemTags == nil) {
        _systemTags = [NSMutableArray array];
    }
    return _systemTags;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(PYSpaceX, 0, fDeviceWidth, 30)];
    [view addSubview:lable];
    view.backgroundColor = dividingLineColor;
    if (section == 0) {
    lable.text = @"已添加";
 }else
 {
     lable.text = @"系统标签";
 }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
//    return 11;
    return self.systemTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section == 0) {
        static NSString *addTagsId = @"addTagsOne";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addTagsId];
        if (cell == nil) {
           cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addTagsId];
            
            UIButton *oneBtn = [[UIButton alloc]initWithFrame:CGRectMake(PYSpaceX, btnMargin, 100, btnH)];
            oneBtn.layer.borderWidth = 0.5 * rateW;
            oneBtn.layer.cornerRadius = 4 *rateW;
            oneBtn.layer.borderColor = btnColor.CGColor;
            ;
            oneBtn.tag = 1;
            oneBtn.titleLabel.font = btnTextSize;
       //     [oneBtn setTitle:@"心情很美丽" forState:UIControlStateNormal];
            [oneBtn setTitleColor:btnColor forState:UIControlStateNormal];
            [oneBtn addTarget:self action:@selector(deleteTag:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:oneBtn];
            self.oneBtn = oneBtn;
            oneBtn.hidden = YES;
            UIButton *twoBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, btnMargin, 100, btnH)];
            twoBtn.layer.borderWidth = 0.5 *rateW;
            twoBtn.layer.cornerRadius = 4 *rateW;
            twoBtn.layer.borderColor = btnColor.CGColor;
            twoBtn.titleLabel.font = btnTextSize;
             twoBtn.tag = 2;
         //   [twoBtn setTitle:@"心情很美丽" forState:UIControlStateNormal];
            [twoBtn setTitleColor:btnColor forState:UIControlStateNormal];
            [twoBtn addTarget:self action:@selector(deleteTag:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:twoBtn];
            self.twoBtn = twoBtn;
            twoBtn.hidden = YES;
            UIButton *threeBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, btnMargin, 100, btnH)];
            threeBtn.layer.borderWidth = 0.5 *rateW;
            threeBtn.layer.cornerRadius = 4 *rateW;
            threeBtn.layer.borderColor = btnColor.CGColor;
            threeBtn.tag = 3;
          //  [threeBtn setTitle:@"心情很美丽" forState:UIControlStateNormal];
            [threeBtn setTitleColor:btnColor forState:UIControlStateNormal];
            [threeBtn addTarget:self action:@selector(deleteTag:) forControlEvents:UIControlEventTouchDown];
             threeBtn.titleLabel.font = btnTextSize;
            [cell.contentView addSubview:threeBtn];
            self.threeBtn = threeBtn;
            threeBtn.hidden = YES;
            UIButton *fourBtn = [[UIButton alloc]initWithFrame:CGRectMake(PYSpaceX,2 * btnMargin +btnH  , 100, btnH)];
            fourBtn.layer.borderWidth = 0.5 *rateW;
            fourBtn.layer.cornerRadius = 4 *rateW;
            fourBtn.layer.borderColor = btnColor.CGColor;
            fourBtn.titleLabel.font = btnTextSize;
            fourBtn.tag = 4;
           // [fourBtn setTitle:@"心情很美丽" forState:UIControlStateNormal];
            [fourBtn setTitleColor:btnColor forState:UIControlStateNormal];
            [fourBtn addTarget:self action:@selector(deleteTag:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:fourBtn];
            self.fourBtn = fourBtn;
            fourBtn.hidden = YES;
        }
        
//       cell.textLabel.text = @"您还没有标签咯";
      return cell;
    }else
    {
        static NSString *addTagsId = @"addTagsTwo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addTagsId];
      if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addTagsId];
      }

        cell.textLabel.text = self.systemTags[indexPath.row];
        return cell;
    }
   
 
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }

    NSString *title = self.systemTags[indexPath.row];

//    [self.addTagsArray addObject:title];
    [self addTag:title];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.fourBtn.hidden && !self.threeBtn.hidden ) {
            if (self.threeBtn.y != self.oneBtn.y) {
                 return 2 *btnMargin + 3 * btnH;
            }
        }
        if (!self.fourBtn.hidden) {
            if (self.fourBtn.y != self.oneBtn.y) {
                return 2 *btnMargin + 3 * btnH;
            }
      
        }
          return 2 *btnMargin + btnH;
    }
    return 44;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - 获取系统标签
- (void)callingGetSysAndHotTags
{
    NSDictionary *param = @{@"type":@"less"};
    [CMAPI postUrl:API_GET_SYSANDHOTTAGS Param:param Settings:nil completion:^(BOOL succeed, NSDictionary *detailDict, NSError *error) {
        id result = [detailDict objectForKey:@"result"] ;
        if(succeed)
        {
            NSArray *sysTagsArr = result[@"sysTags"]; //系统标签数组
            
            for (NSDictionary *dataDic in sysTagsArr) {
                [self.systemTags addObject: [dataDic objectForKey:@"tagName"]];
            }
            [self.mainTable reloadData];
            
            
            
            if(self.tags.length > 0)
            {
                
                NSArray *tagsArray=[NSArray arrayWithArray:[self.tags componentsSeparatedByString:@","]];
                
                for (NSString *title in tagsArray) {
                    [self addTag:title];
                }
            }
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"reason"]];
        }
        
    }];
}
#pragma mark - 添加标签
- (void)addTag:(NSString *)title
{
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([@"" isEqualToString:title])
    {
        [SVProgressHUD showInfoWithStatus:@"标签不能输入空白字符咯"];
        return;
    }
    for (NSString* tagName in self.addTagsArray) {
        if ([tagName isEqualToString:title]) {
            [SVProgressHUD showInfoWithStatus:@"标签重复咯"];
            return;
        }
    }
    
    NSDictionary *dic = @{NSFontAttributeName :btnTextSize};
   CGSize size =  [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat addWidth = 20 *rateW;
    if (self.addTagsArray.count == 0) {
        self.oneBtn.width = size.width + addWidth;
       [self.oneBtn setTitle:title forState:UIControlStateNormal];
        self.oneBtn.hidden = NO;
            [self.addTagsArray addObject:title];
        return;
    }
    if (self.addTagsArray.count == 1) {
        
        self.twoBtn.x = CGRectGetMaxX(self.oneBtn.frame) + 10 *rateW;
        self.twoBtn.width = size.width + addWidth;
        [self.twoBtn setTitle:title forState:UIControlStateNormal];
        self.twoBtn.hidden = NO;
            [self.addTagsArray addObject:title];
          return;
    }
    if (self.addTagsArray.count == 2) {
        
        if (fDeviceWidth < ( 2 *PYSpaceX + size.width + addWidth + CGRectGetMaxX(self.twoBtn.frame))) {
            self.threeBtn.x = PYSpaceX;
            self.threeBtn.y = CGRectGetMaxY(self.oneBtn.frame) + btnMargin;
            self.threeBtn.width = size.width + addWidth;;
            [self.threeBtn setTitle:title forState:UIControlStateNormal];
        }else
        {
            self.threeBtn.x = CGRectGetMaxX(self.twoBtn.frame) + 10 *rateW;
            self.threeBtn.width = size.width + addWidth;
            [self.threeBtn setTitle:title forState:UIControlStateNormal];
        }
       [self.threeBtn setTitle:title forState:UIControlStateNormal];
        self.threeBtn.hidden = NO;
        [self.mainTable reloadData];
            [self.addTagsArray addObject:title];
          return;
    }
    if (self.addTagsArray.count == 3) {
        if (CGRectGetMaxY(self.oneBtn.frame) == CGRectGetMaxY(self.threeBtn.frame) ) {
            
            if (fDeviceWidth < ( 2 *PYSpaceX + size.width + addWidth + CGRectGetMaxX(self.threeBtn.frame))) {
                self.fourBtn.x = PYSpaceX;
                self.fourBtn.y = CGRectGetMaxY(self.oneBtn.frame) + btnMargin;
                self.fourBtn.width = size.width + addWidth;;
                [self.fourBtn setTitle:title forState:UIControlStateNormal];
            }else
            {
                self.fourBtn.x = CGRectGetMaxX(self.threeBtn.frame) + 10 *rateW;
                self.fourBtn.y = self.oneBtn.y;
                self.fourBtn.width = size.width + addWidth;
             
            }
        }else
        {
            self.fourBtn.x = CGRectGetMaxX(self.threeBtn.frame) + 10 *rateW;
            self.fourBtn.y = self.threeBtn.y;
            self.fourBtn.width = size.width + addWidth;
          
        }
      [self.addTagsArray addObject:title];
      [self.mainTable reloadData];
      [self.fourBtn setTitle:title forState:UIControlStateNormal];
      self.fourBtn.hidden = NO;
      return;
    }
    
    [SVProgressHUD showInfoWithStatus:@"只能添加4个标签咯"];
}

- (void)modifyTag:(NSString *)title ByButton:(UIButton *)btn
{
 
    NSDictionary *dic = @{NSFontAttributeName :btnTextSize};
    CGSize size =  [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat addWidth = 20 *rateW;
    if (btn.tag == 1) {
        self.oneBtn.width = size.width + addWidth;
        [self.oneBtn setTitle:title forState:UIControlStateNormal];
        self.oneBtn.hidden = NO;
        return;
    }
    if (btn.tag == 2) {
        
        self.twoBtn.x = CGRectGetMaxX(self.oneBtn.frame) + 10 *rateW;
        self.twoBtn.width = size.width + addWidth;
        [self.twoBtn setTitle:title forState:UIControlStateNormal];
        self.twoBtn.hidden = NO;
        return;
    }
    if (btn.tag == 3) {
        
        if (fDeviceWidth < ( 2 *PYSpaceX + size.width + addWidth + CGRectGetMaxX(self.twoBtn.frame))) {
            self.threeBtn.x = PYSpaceX;
            self.threeBtn.y = CGRectGetMaxY(self.oneBtn.frame) + btnMargin;
            self.threeBtn.width = size.width + addWidth;;
            [self.threeBtn setTitle:title forState:UIControlStateNormal];
        }else
        {
            self.threeBtn.x = CGRectGetMaxX(self.twoBtn.frame) + 10 *rateW;
            self.threeBtn.width = size.width + addWidth;
            [self.threeBtn setTitle:title forState:UIControlStateNormal];
        }
        [self.threeBtn setTitle:title forState:UIControlStateNormal];
        self.threeBtn.hidden = NO;
        [self.mainTable reloadData];
        return;
    }
    if (btn.tag == 4) {
        if (CGRectGetMaxY(self.oneBtn.frame) == CGRectGetMaxY(self.threeBtn.frame) ) {
            
            if (fDeviceWidth < ( 2 *PYSpaceX + size.width + addWidth + CGRectGetMaxX(self.threeBtn.frame))) {
                self.fourBtn.x = PYSpaceX;
                self.fourBtn.y = CGRectGetMaxY(self.oneBtn.frame) + btnMargin;
                self.fourBtn.width = size.width + addWidth;;
                [self.fourBtn setTitle:title forState:UIControlStateNormal];
            }else
            {
                self.fourBtn.x = CGRectGetMaxX(self.threeBtn.frame) + 10 *rateW;
                self.fourBtn.y = self.oneBtn.y;
                self.fourBtn.width = size.width + addWidth;
                
            }
        }else
        {
            self.fourBtn.x = CGRectGetMaxX(self.threeBtn.frame) + 10 *rateW;
            self.fourBtn.y = self.threeBtn.y;
            self.fourBtn.width = size.width + addWidth;
            
        }
        [self.fourBtn setTitle:title forState:UIControlStateNormal];
        self.fourBtn.hidden = NO;

        [self.mainTable reloadData];
     
        return;
    }

}
#pragma mark - 点击确定按钮
- (void)confirmBtnClick
{
    NSString *title = self.textField.text;
    if (title.length > 8) {
        [SVProgressHUD showErrorWithStatus:@"标签不能超过8个字"];
        return;
    }
    [self addTag:title];

    self.textField.text = nil;
    [self.view endEditing:YES];
}
#pragma mark - 删除标签
- (void)deleteTag:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除标签吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    self.selectBtn = btn;
    
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        PYLog(@"%@",self.addTagsArray);
       if(self.selectBtn.tag == 1)
       {
           NSString *three = self.threeBtn.currentTitle ;
           NSString *four =self.fourBtn.currentTitle;
           if(!self.twoBtn.hidden)
           {  [self modifyTag:self.twoBtn.currentTitle ByButton:self.oneBtn];
           }
            if(!self.threeBtn.hidden)
            {
                [self modifyTag:three ByButton:self.twoBtn];
            }
           if (!self.fourBtn.hidden) {
                  [self modifyTag:four ByButton:self.threeBtn];
            }
           
          }else if (self.selectBtn.tag == 2)
          {
           NSString *four = self.fourBtn.currentTitle;
           if(!self.threeBtn.hidden)
           {
            [self modifyTag:self.threeBtn.currentTitle ByButton:self.twoBtn];
           }
           if (!self.fourBtn.hidden) {
            [self modifyTag:four ByButton:self.threeBtn];
           }
         }else if (self.selectBtn.tag == 3)
         {
           if (!self.fourBtn.hidden) {
           [self modifyTag:self.fourBtn.currentTitle ByButton:self.threeBtn];
           }
        }
      
        if (self.addTagsArray.count == 4) {
         [self.addTagsArray removeLastObject];
            self.fourBtn.hidden = YES;
        }else if (self.addTagsArray.count == 3) {
              [self.addTagsArray removeLastObject];
            self.threeBtn.hidden = YES;
        }else if (self.addTagsArray.count == 2) {
              [self.addTagsArray removeLastObject];
               self.twoBtn.hidden = YES;
        }else
        {
            [self.addTagsArray removeLastObject];
            self.oneBtn.hidden = YES;
        }
      
    }
}

#pragma mark - completeBtnClick完成按钮
- (void)completeBtnClick
{
    NSString *tags = @"";
    
    if (!self.oneBtn.hidden) {
        tags = self.oneBtn.currentTitle;
    }
    if (!self.twoBtn.hidden) {
        tags = [NSString stringWithFormat:@"%@,%@",tags,self.twoBtn.currentTitle];
    }
    if (!self.threeBtn.hidden) {
        tags = [NSString stringWithFormat:@"%@,%@",tags,self.threeBtn.currentTitle];
    }
    if (!self.fourBtn.hidden) {
        tags = [NSString stringWithFormat:@"%@,%@",tags,self.fourBtn.currentTitle];
    }
    if([tags isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"至少需要添加一个标签"];
        return;
    }
    [PYNotificationCenter postNotificationName:DEFAULT_ADDTAGS_NOTIFICATION object:nil userInfo:@{DEFAULT_ADD_TAGS : tags}];
    [self.navigationController popViewControllerAnimated:YES];
//    [SVProgressHUD showInfoWithStatus:@"已发布成功"];
}

@end
