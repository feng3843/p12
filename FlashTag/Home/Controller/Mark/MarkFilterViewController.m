//
//  MarkFilterViewController.m
//  FlashTag
//
//  Created by py on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "MarkFilterViewController.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "MarkView.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "EditNoteViewController.h"
#import "SVProgressHUD.h"
#import "DataBaseTool.h"
#import "MD5.h"
#import "UIView+Extension.h"
#import "MarkBtn.h"
#import "MarkModel.h"
#import "ImageFilter.h"
@interface MarkFilterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic)  UITextField *textField;
@property (weak, nonatomic)  UIImageView *imageView;
@property(nonatomic,weak)UIButton *navRightbtn;

@property(nonatomic,weak)UIScrollView *scrollerView;
@property(nonatomic ,strong)UIImage *currentImage;
@property(nonatomic,weak)UIView *markView;


@property(nonatomic,weak)UIButton *filterBtn;
@property(nonatomic,weak)UIButton *markBtn;
@property(nonatomic,weak)UIButton *cover;
@property(nonatomic,weak)UIButton *selectBtn;

@property(nonatomic,assign)BOOL isModification;
@property(nonatomic,weak)MarkView *currentMarkView;
@property(nonatomic,weak)UIImageView *currentImageView;
@end

@implementation MarkFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 33 *rateH, fDeviceWidth, 320 *rateH)];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
 
    {
        self.currentImage =self.image;
        
        self.imageView.image = self.currentImage;
        [self setupFilter];
        [self setupMark];
        
        UIButton *cover = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, fDeviceWidth, fDeviceHeight - 64)];
        cover.alpha = 0;
        cover.backgroundColor = PYColor(@"000000");
        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:cover];
        self.cover = cover;
    }

    [self setupBottom];
    
  // 导航栏
    UIButton *navBack = [[UIButton alloc]initWithFrame:CGRectMake(15 *rateW, 0, 24 *rateW, 24 *rateW)];
   // [navBack setTitle:@"返回" forState:UIControlStateNormal];
    [navBack addTarget:self action:@selector(navBackClick) forControlEvents:UIControlEventTouchUpInside];
    [navBack setBackgroundImage:[UIImage imageNamed:@"ic_home_mark_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navBack];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 221 *rateH, 35 *rateH)];
    [textField setBackgroundColor:PYColor(@"cdcdcd")];
    [textField setTextColor:PYColor(@"222222")];
    textField.layer.cornerRadius = 4 *rateW;
    textField.clipsToBounds = YES;
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = PYColor(@"222222");
    self.textField = textField;
    self.textField.placeholder = @"请输入商品名称";
    [textField setTintColor:PYColor(@"999999") ];
   UIView *leftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15 *rateH, 35 *rateH)];
    leftView.backgroundColor = [UIColor redColor];
    [textField setLeftView:leftView];
  
    self.navigationItem.titleView = textField;
    //textField.backgroundColor = [UIColor greenColor];
    
    UIButton *navRightbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,60, 44)];
    [navRightbtn setTitle:@"完成" forState:UIControlStateNormal];
    [navBack setTitleColor:PYColor(@"267cc6") forState:UIControlStateNormal];
    navBack.titleLabel.font = PYSysFont(16 *rateW);
    self.navRightbtn = navRightbtn;
//    [navBack setTitleColor:PYColor(@"267cc6") forState:UIControlStateSelected];
    [navRightbtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightbtn];
  //  navRightbtn.backgroundColor = [UIColor redColor];
    
    self.isModification = NO;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSString* text=self.textField.text;
//    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
//    if ([text isEqualToString:@""]) {
//        self.navRightbtn.userInteractionEnabled = NO;
//    }ghv,nb,bb.bj .≥  cv
}

- (void)navBackClick
{
    self.textField.text = @"";
    self.selectBtn.selected = NO;
    self.selectBtn.layer.borderWidth = 0;
    self.navigationController.navigationBarHidden = YES;
    self.cover.alpha = 0;
}
- (void)setupBottom
{
   // CGFloat bottomBtnWH = 60 *rateH;
    CGFloat bottomMargin =  60 *rateH;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 *rateW, fDeviceHeight - bottomMargin + 8 *rateH , 24 *rateH, 24 *rateH)];
    //[backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_mark_back"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    MarkBtn *filterBtn = [[MarkBtn alloc]initWithFrame:CGRectMake(80 *rateW, fDeviceHeight - bottomMargin,44 *rateH, 44 *rateH)];
      filterBtn.titleLabel.font = PYSysFont(11 *rateH);
    [filterBtn setTitle:@"滤镜" forState:UIControlStateNormal];
    filterBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [filterBtn setTitleColor:PYColor(@"ffffff") forState:UIControlStateSelected];
    [filterBtn setImage:[UIImage imageNamed:@"ic_home_normal_filter"] forState:UIControlStateNormal];
    [filterBtn setImage:[UIImage imageNamed:@"ic_home_press_filter"] forState:UIControlStateSelected];
    [filterBtn addTarget:self action:@selector(filterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:filterBtn];
    self.filterBtn = filterBtn;
    self.filterBtn.selected = YES;
    
    MarkBtn *markBtn  = [[MarkBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(filterBtn.frame) + 36 *rateW, fDeviceHeight - bottomMargin , 44 *rateH, 44 *rateH)];
    [markBtn setTitle:@"MARK" forState:UIControlStateNormal];
    markBtn.titleLabel.font = PYSysFont(11 *rateH);
    [markBtn setImage:[UIImage imageNamed:@"ic_home_normal_mark"] forState:UIControlStateNormal];
    [markBtn setImage:[UIImage imageNamed:@"ic_home_press_mark"] forState:UIControlStateSelected];
    [markBtn setTitleColor:PYColor(@"ffffff") forState:UIControlStateSelected];
    markBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:markBtn];
    [markBtn addTarget:self action:@selector(markBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.markBtn = markBtn;
    
    CGFloat completeBtnX =CGRectGetMaxX(markBtn.frame) + 39 *rateW;
   
    UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(completeBtnX, fDeviceHeight - bottomMargin  , fDeviceWidth - 15 *rateW - completeBtnX, 44 *rateH)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeBtn];
}
- (void)setupMark
{
    
    UIView *markView = [[UIView alloc]initWithFrame:CGRectMake(0, 353 *rateH, fDeviceWidth, 135 *rateH)];
    markView.backgroundColor = PYColor(@"222222");
    [self.view addSubview:markView];
    self.markView = markView;
    CGFloat markBtnWH = 65 *rateH;
    CGFloat margin = 27 *rateW;
    /** 价格*/
    UIButton *priceBtn = [[UIButton alloc]initWithFrame:CGRectMake(margin, 35 *rateH, markBtnWH, markBtnWH)];
    [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    [priceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [priceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    priceBtn.backgroundColor = [UIColor grayColor];
     priceBtn.titleLabel.font = PYSysFont(14 *rateW);
    priceBtn.layer.cornerRadius = markBtnWH * 0.5;

    [priceBtn addTarget:self action:@selector(addMark:) forControlEvents:UIControlEventTouchUpInside];
    [markView addSubview:priceBtn];
    /** 名称*/
    UIButton *goodBtn = [[UIButton alloc]initWithFrame:CGRectMake(margin + (markBtnWH + margin), 35 *rateH, markBtnWH, markBtnWH)];
    [goodBtn setTitle:@"名称" forState:UIControlStateNormal];
    [goodBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   [goodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    goodBtn.titleLabel.font = PYSysFont(14 *rateW);
    goodBtn.backgroundColor = [UIColor grayColor];
    goodBtn.layer.cornerRadius =32.5 *rateH;
//    goodBtn.layer.borderWidth = 2;
//    goodBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [goodBtn addTarget:self action:@selector(addMark:) forControlEvents:UIControlEventTouchUpInside];
    [markView addSubview:goodBtn];
  
    /** 地点*/
    UIButton *placeBtn = [[UIButton alloc]initWithFrame:CGRectMake(margin + 2 *(markBtnWH + margin), 35 *rateH, markBtnWH, markBtnWH)];
    [placeBtn setTitle:@"地点" forState:UIControlStateNormal];
    [placeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [placeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    placeBtn.backgroundColor = [UIColor grayColor];
    placeBtn.layer.cornerRadius = 32.5 *rateH;
    placeBtn.titleLabel.font = PYSysFont(14 *rateW);
    [placeBtn addTarget:self action:@selector(addMark:) forControlEvents:UIControlEventTouchUpInside];
    [markView addSubview:placeBtn];
    self.markView.hidden = YES;
}

- (void)setupFilter
{
    
    
//    NSArray *arr = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色", nil];
        NSArray *arr = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色", nil];
    UIScrollView  *scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 353 *rateH, fDeviceWidth, 135 *rateH)];
    scrollerView.backgroundColor = PYColor(@"222222");
    scrollerView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;//关闭纵向滚动条
    scrollerView.bounces = NO;
    self.scrollerView = scrollerView;
    float x = 0;
    for(int i=0;i<6;i++)
    {
        x = (15  + 80 *i) *rateW;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageStyle:)];
        recognizer.numberOfTouchesRequired = 1;
        recognizer.numberOfTapsRequired = 1;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 100 *rateH, 65 *rateW, 14 *rateH)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[arr objectAtIndex:i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:14.0 *rateH]];
        [label setTextColor:PYColor(@"ffffff")];
        [label setUserInteractionEnabled:YES];
        [label setTag:i];
        [label addGestureRecognizer:recognizer];
        
        [scrollerView addSubview:label];
        
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 24 *rateH, 65 *rateH,  65 *rateH)];
        [bgImageView setTag:i];
        bgImageView.layer.borderColor = PYColor(@"70b2f5").CGColor;
        bgImageView.layer.cornerRadius = 5 *rateW;
        bgImageView.clipsToBounds = YES;
        [bgImageView addGestureRecognizer:recognizer];
        [bgImageView setUserInteractionEnabled:YES];
        
//        
       UIImage *bgImage = [self changeImage:i imageView:nil];
        
//       UIImage *bgImage =  [UIImage imageWithCIImage:[self oldPhoto:self.currentImage.CIImage withAmount:215]];
        bgImageView.image = bgImage;
        [scrollerView addSubview:bgImageView];
        
        if (i == 0) {
            self.currentImageView = bgImageView;

            self.currentImageView.layer.borderWidth = 1*rateW;
        }
        
    }
    scrollerView.contentSize = CGSizeMake(x + 80, 0);
    [self.view addSubview:scrollerView];
    [self editMarkAndMarkAttribute];
}


#pragma mark - 编辑mark和mark位置
- (void)setModel:(MarkModel *)model
{
    _model = model;
    
}

- (void)editMarkAndMarkAttribute
{
    
    if (![self.model.mark isEqualToString:@""]) {
        NSArray *markArray =[NSArray arrayWithArray:[self.model.mark componentsSeparatedByString:@"\\;"]];
        NSArray *markAttributesArray =[NSArray arrayWithArray:[self.model.markAttributes componentsSeparatedByString:@"\\;"]];
        
        
        for (int i = 0; i <markArray.count ; i++) {
            NSDictionary *dic = @{NSFontAttributeName :[UIFont systemFontOfSize:15]};
            CGSize size = [markArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            NSString *itemArray = markAttributesArray[i];
            NSArray *itemMarkAtti = [NSArray arrayWithArray:[itemArray componentsSeparatedByString:@"x"]];
            double markAttributesX = [itemMarkAtti[0] floatValue] * fDeviceWidth  / 100;
            double markAttributesY =[itemMarkAtti[1] floatValue] *  263 *rateH /100;
            MarkView *markView = [[MarkView alloc]initWithFrame:CGRectMake(markAttributesX, markAttributesY, size.width + 35, 40)];
            
            [markView setDragEnable:YES];
            [markView setTitle:markArray[i]];
            markView.currentBtn = self.selectBtn;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mark:)];
            [markView addGestureRecognizer:tap];
            [self.imageView addSubview:markView];
            
        }
    }
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
       self.navigationController.navigationBarHidden = YES;
}
#pragma mark - 底部按钮点击事件
- (void)backBtnClick
{
   
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)filterBtnClick
{   self.filterBtn.selected = YES;
    self.markBtn.selected = NO;
    self.markView.hidden = YES;
    self.scrollerView.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)markBtnClick
{
    self.markBtn.selected = YES;
    self.filterBtn.selected = NO;
    self.markView.hidden = NO;
    self.scrollerView.hidden = YES;

}

- (void)completeBtnClick
{

    NSString *marks = @"";
    NSString *markAttributes = @"";
    for (MarkView *view in self.imageView.subviews) {
      //  PYLog(@"%@",view);
        if (marks.length > 0) {
         marks = [NSString stringWithFormat:@"%@\\;%@",marks ,view.title];
         
        }else
        {
            marks = view.title;
        }
        double markAttributesX = view.x  / fDeviceWidth * 100;
        double markAttributesY = view.y  / 263 *rateH * 100;
        if (markAttributes.length > 0) {
          //float markAttributesX = markAttributes,view.x % fDeviceWidth;
            markAttributes = [NSString stringWithFormat:@"%@\\;%.2fx%.2f",markAttributes,markAttributesX,markAttributesY];
        }else
        {
            markAttributes = [NSString stringWithFormat:@"%.2fx%.2f",markAttributesX,markAttributesY];
        }
    }

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];

    
    NSString *fileName = @"";
    // 删除文件
    if (self.model) {
        
        if (self.image != self.imageView.image) {
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath = [path stringByAppendingPathComponent:self.model.imageName];
            BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
            if (bRet) {
                //
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
            }
             fileName = [NSString stringWithFormat:@"note_%@.jpg", [NSDate new]];
        }else
        {
                    fileName = self.model.imageName;
        }
      
    }else
     {
          fileName = [NSString stringWithFormat:@"note_%@.jpg", [NSDate new]];
     }
    
    
   
    // 保存文件

    NSString *filePath = [path stringByAppendingPathComponent:fileName];   // 保存文件的名称
    PYLog(@"%@",filePath);
    [UIImageJPEGRepresentation((self.imageView.image), 1) writeToFile:filePath atomically:YES];
    if (self.isFirst) {
        MarkModel *model = [[MarkModel alloc]init];
        model.imageName = fileName;
        model.mark = marks;
        model.markAttributes = markAttributes;
        UIStoryboard *View = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditNoteViewController *vc = [View instantiateViewControllerWithIdentifier:@"editNoteId"];
        vc.firstNoteImageInfo = model;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }else
    {
        if(self.model)
        {
            [PYNotificationCenter postNotificationName:DEFAULT_NOTEIMAGE_NOTIFICATION object:nil userInfo:@{DEFAULT_NOTEIMAGENAME:fileName,DEFAULT_NOTEIMAGEMARK:marks,DEFAULT_NOTEIMAGEATTRIBUTES:markAttributes,DEFAULT_NOTEIMAGETYPE:DEFAULT_NOTEIMAGETYPEEDIT}];
        }else
        {
            [PYNotificationCenter postNotificationName:DEFAULT_NOTEIMAGE_NOTIFICATION object:nil userInfo:@{DEFAULT_NOTEIMAGENAME:fileName,DEFAULT_NOTEIMAGEMARK:marks,DEFAULT_NOTEIMAGEATTRIBUTES:markAttributes,DEFAULT_NOTEIMAGETYPE:DEFAULT_NOTEIMAGETYPEADD}];
        }
   
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    
}

#pragma mark - coverClick
- (void)coverClick
{
    self.textField.text = @"";
    self.selectBtn.selected = NO;
    self.selectBtn.layer.borderWidth = 0;
    self.navigationController.navigationBarHidden = YES;
    self.cover.alpha = 0;
}
#pragma mark - 完成
- (void)finish
{

    NSString* text=self.textField.text;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    if(text.length > 8)
    {
        [SVProgressHUD showErrorWithStatus:@"mark不能超过8个字"];
        return;
    }
    if (!self.isModification) {
        if (![self.textField.text isEqualToString:@""]) {
          
                
                NSDictionary *dic = @{NSFontAttributeName :[UIFont systemFontOfSize:15]};
                CGSize size = [self.textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
                CGFloat x = arc4random() % 200;
                CGFloat y = arc4random() % 200 ;
                MarkView *markView = [[MarkView alloc]initWithFrame:CGRectMake(x, y, size.width + 35, 40)];
            
                [markView setDragEnable:YES];
                [markView setTitle:self.textField.text];
                markView.currentBtn = self.selectBtn;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mark:)];
                [markView addGestureRecognizer:tap];
                [self.imageView addSubview:markView];
            
        }
    }
    else{
        if (![self.textField.text isEqualToString:@""]) {

               self.currentMarkView.title = self.textField.text;
         }else
        {
            self.selectBtn.userInteractionEnabled = YES;
            self.selectBtn.layer.borderWidth = 0;
            self.selectBtn.selected = NO;
            [self.currentMarkView removeFromSuperview];
          self.currentMarkView = nil;
            
        }
    }
    self.selectBtn.selected = NO;
    self.selectBtn.layer.borderWidth = 0;
    self.textField.text = @"";
    self.navigationController.navigationBarHidden = YES;
    self.cover.alpha = 0;
  
}
#pragma mark - 点击mark
- (void)mark:(UITapGestureRecognizer *)info
{
    
    self.isModification = YES;
    MarkView *view = (MarkView *)info.view;
    self.currentMarkView = view;
    self.selectBtn = view.currentBtn;
    self.selectBtn.selected = YES;
    self.selectBtn.layer.borderWidth = 2;
    self.selectBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    if ([view.currentBtn.currentTitle isEqualToString:@"价格"]) {
//        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
//    }else
//    {
//        self.textField.keyboardType =   UIKeyboardTypeDefault;
//    }
    self.navigationController.navigationBarHidden = NO;
    self.cover.alpha = 0.5;
    self.textField.text = view.title;
}
#pragma mark - 点击价格、名称、地点
- (void)addMark:(UIButton *)btn {
    
    
    self.isModification = NO;
    self.selectBtn = btn;
    btn.selected = YES;
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    

//    if ([btn.currentTitle isEqualToString:@"价格"]) {
//        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
//    }else
//    {
//        self.textField.keyboardType = UIKeyboardTypeDefault;
//    }

    self.navigationController.navigationBarHidden = NO;
    self.cover.alpha = 0.5;
    
    self.textField.placeholder = [NSString stringWithFormat:@"请输入商品%@",btn.currentTitle];
    [self.textField becomeFirstResponder];
    
}
- (void)setImageStyle:(UITapGestureRecognizer *)sender
{

 
    self.currentImageView.layer.borderWidth = 0*rateW;
    self.currentImageView = sender.view;
    self.currentImageView.layer.borderWidth = 1*rateW;
//    UIImage *image = [UIImage imageWithCIImage:[self oldPhoto:self.currentImage.CIImage withAmount:0.5]];
    
   UIImage *image = (UIImage *)[self changeImage:sender.view.tag imageView:nil];   [self.imageView setImage:image];
}
-(UIImage *)changeImage:(int)index imageView:(UIImageView *)imageView
{
    UIImage *image;
    switch (index) {
        case 0:
        {
            return self.currentImage;
        }
            break;
   case 1:
    {
        image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_lomo];
    }
            break;
        case 2:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_ruise];
        }
            break;
//        case 6:
//        {
//            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_danya];
//        }
//            break;
//        case 7:
//        {
//            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_jiuhong];
//        }
//            break;
//        case 8:
//        {
//            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_qingning];
//        }
//            break;
//        case 9:
//        {
//            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_langman];
//        }
//            break;
//        case 10:
//        {
//            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_guangyun];
//        }
//            break;
//        case 11:
//        {
//            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_landiao];
//            
//        }
//            break;
//        case 12:
//        {
//            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_menghuan];
//            
//        }
//            break;
//        case 13:
//        {
//            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_yese];
//            
//        }
    }
//    UIImage *image = self.currentImage;
//  
//    switch (index) {
//        case 0:
//            image = image;
//            break;
//        case 1:
//            image = [image contrast:(1.3)];
//            break;
//        case 2:
//            image = [image saturate:(0.1)];;
//            break;
//        case 3:
//          image = [image brightness:(0.6)];
//            break;
//        case 4:
//            image = [image posterize:(5)];
//            break;
//        case 5:
//         image = [image gamma:(1.2)];
//            break;
//        case 6:
//          image =[image noise:0.5];
//            break;                
//        default:
//            break;
//    }
    return image;
}

-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity {
    
    // 1
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputIntensity"];
    
    // 2
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    // 3
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - intensity) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];
    
    // 4
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[img extent]];
    
    // 5
    CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
    [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];
    
    // 6
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
    [vignette setValue:@(intensity * 2) forKey:@"inputIntensity"];
    [vignette setValue:@(intensity * 30) forKey:@"inputRadius"];
    
    // 7
    return vignette.outputImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    //    PYLog(@"ssss%@",string);
    if([CMTool stringContainsEmoji:string]) return NO;
    return YES;
}

@end
