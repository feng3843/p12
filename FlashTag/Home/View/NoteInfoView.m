//
//  NoteInfoView.m
//  SeaAmoy
//
//  Created by 夏雪 on 15/8/27.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  帖子信息

#import "TimeIntervalTool.h"
#import "NoteInfoView.h"
#import "PYAllCommon.h"
#import "UIView+Extension.h"
#import "NoteConst.h"
#import "NSString+Extensions.h"
#import "UIView+AutoLayout.h"
#import "CommonInterface.h"
#define topH 56.0f * rateH
#define space  10.0f * rateH

@interface NoteInfoView()
/** 设置顶部*/
@property(nonatomic ,weak)UIImageView *headImage;
@property(nonatomic ,weak)UILabel *nameLable;
@property(nonatomic ,weak)UILabel *addressLable;
@property(nonatomic ,weak)UIButton *attentionBtn;
/** 设置中间*/
@property(nonatomic ,weak)UIImageView *noteImage;
@property(nonatomic ,weak)UILabel *noteInfo;
@property(nonatomic ,weak)UIImageView *tagImage;
@property(nonatomic,weak)UILabel *publishTime;
@property(nonatomic,weak)UIButton *tagOneBtn;
@property(nonatomic,weak)UIButton *tagTwoBtn;
@property(nonatomic,weak)UIButton *tagThreeBtn;
@property(nonatomic,weak)UIButton *tagFourBtn;
@property(nonatomic,weak)UIImageView *timeImage;
/** 设置底部*/
@property(nonatomic ,weak)UIButton *commentBtn;
@property(nonatomic ,weak)UIButton *praiseBtn;
@property(nonatomic ,weak)UIButton *moreBtn;

@property(nonatomic ,weak)UIView *topImage;
@property(nonatomic ,weak)UIView *bottomImage;

@property(nonatomic,assign)int praiseCount;
@end
@implementation NoteInfoView


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if(reuseIdentifier)
        {
            [self setupTop];
            [self setupMiddle];
            [self setupBottom];
        }
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
 
    }
    return self;
}

-(void)setType:(HomeCellType)type
{
    _type = type;
    
    switch (self.type) {
        case HomeCellTypeMiddleBottom:
        {
            self.topImage.hidden = YES;
            self.noteImage.y = 0.5 *rateH;
            self.bottomImage.y = 263 *rateH;
        }
            break;
        case HomeCellTypeTopMiddleBottom:
        default:
        {
            self.topImage.hidden = NO;
            self.noteImage.y = 56.5*rateH;
            self.bottomImage.y = 315 *rateH;
        }
            break;
    }
    switch (self.type) {
        case HomeCellTypeMiddleBottom:
        {
            self.noteImage.frame = CGRectMake(0, 0, fDeviceWidth, noteImageH );
            self.bottomImage.frame = CGRectMake(0, (319.5 -0.5) *rateH - topH, fDeviceWidth, 147 * rateH);
        }
            break;
        case HomeCellTypeTopMiddleBottom:
        default:
        {
            self.noteImage.frame = CGRectMake(0, topH + 0.5 *rateH, fDeviceWidth, noteImageH );
            self.bottomImage.frame = CGRectMake(0, 319.5 *rateH , fDeviceWidth, 147 * rateH);
        }
            break;
    }
}

/** 设置顶部*/
- (void)setupTop
{


    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, 0.5 *rateH)];
    topLine.backgroundColor = PYColor(@"cccccc");
    // topLine.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:topLine];


    UIView *topImage = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5 *rateH, fDeviceWidth, topH)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5 *rateH, fDeviceWidth, topH)];
    bgView.backgroundColor = PYColor(@"ffffff");
//    [topImage addSubview:bgView];
//    bgView.alpha = 0.4;
//    if (IOS8) {
//        
//     bgView.alpha = 0.6;
//
//    }else
//    {

//    
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        topImage = [[UIVisualEffectView alloc] initWithEffect:blur];
//        topImage.frame = CGRectMake(0, 0, noteImage.size.width, topH);
         // bgView.alpha = 0.4;
//    }
    self.topImage = topImage;
    [self.contentView addSubview:topImage];
    
    [topImage addSubview:bgView];
//    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, topH)];
//    [self addSubview:topImage];
    /** 头像*/
    CGFloat headImageX = PYSpaceX;
    CGFloat headImageWH = 40.0f *rateW;
    CGFloat headImageY = 8.0f *rateH;
    UIImageView *headImage =[[UIImageView alloc]initWithFrame:CGRectMake(headImageX, headImageY, headImageWH, headImageWH)];
    headImage.layer.cornerRadius = 20.0 *rateW;
    headImage.clipsToBounds = YES;
    self.headImage = headImage;
//    self.headImage.backgroundColor = [UIColor redColor];
    headImage.userInteractionEnabled = YES;
    headImage.image = [UIImage imageNamed:@"img_default_user"];
    [topImage addSubview:headImage];
    
    /** 名字*/
    CGFloat nameX = CGRectGetMaxX(headImage.frame) + space;
    CGFloat nameY = 13 *rateH;
    CGFloat nameW = 200 *rateW;
    CGFloat nameH = 13 *rateH;
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
    self.nameLable = nameLable;
    nameLable.textColor = noteNameTextColor;
    nameLable.text = @"夏雪";
    nameLable.font = noteNameFont;
    [topImage addSubview:nameLable];

    /** 定位地址*/
    CGFloat addressX = nameX;
    CGFloat addressY = 30 *rateH;
    CGFloat addressW = nameW;
    CGFloat addressH = 13 *rateH;
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(addressX, addressY, addressW, addressH)];
    self.addressLable = addressLable;
    addressLable.textColor = noteAddressTextColor;
    addressLable.text = @"定位发帖地址";
    addressLable.font = noteAddressFont;
    [topImage addSubview:addressLable];
    
    CGFloat attentionW =topH;
    CGFloat attentionH = topH;
    CGFloat attentionX = (fDeviceWidth -PYSpaceX - attentionW);
    CGFloat attentionY = 0;
    UIButton *attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(attentionX, attentionY, attentionW, attentionH)];
      self.attentionBtn = attentionBtn;
   // [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [attentionBtn setImage:[UIImage imageNamed:@"ic_home_add_attention"] forState:UIControlStateNormal];
    [attentionBtn setImage:[UIImage imageNamed:@"ic_home_add_cancleattention"] forState:UIControlStateSelected];
  //  [attentionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [attentionBtn addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
  //  attentionBtn.backgroundColor = [UIColor redColor];
    attentionBtn.userInteractionEnabled = YES;
  
    [topImage addSubview:attentionBtn];
    
    
    UIImageView *noteImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, topH + 0.5 *rateH, fDeviceWidth, noteImageH )];
    noteImage.image = [UIImage imageNamed:@"Thome.png"];
    noteImage.userInteractionEnabled = YES;
    noteImage.contentMode = UIViewContentModeScaleAspectFill;
    noteImage.clipsToBounds = YES;
    self.noteImage = noteImage;
    
    [self.contentView addSubview:noteImage];
}
/** 设置中间*/
- (void)setupMiddle
{
    UIView *bottomImage = [[UIView alloc]initWithFrame:CGRectMake(0, 319.5 *rateH , fDeviceWidth, 147 * rateH)];

    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 319.5*rateH , fDeviceWidth, 147 * rateH)];
    bgView.backgroundColor = PYColor(@"ffffff");
//      bgView.alpha = 0.4;
//
//    if (IOS8) {
//        bgView.alpha = 0.6;
//    }else
//    {
//    #warning 夏雪-------高斯模糊
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        bottomImage = [[UIVisualEffectView alloc] initWithEffect:blur];
//        bottomImage.frame = CGRectMake(0, 263 *rateH, fDeviceWidth, 147 * rateH);
        // bgView.alpha = 0.4;
//    }
        self.bottomImage = bottomImage;
        [bottomImage addSubview:bgView];
     [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
//    [noteImage addSubview:topImage];
    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *bottomImage = [[UIVisualEffectView alloc] initWithEffect:blur];
//    bottomImage.frame = CGRectMake(0, 263 *rateH, fDeviceWidth, 147 * rateH);
 
    [self.contentView addSubview:bottomImage];
    
   
    
    
//    UIView *oneDivideLine = [[UIView alloc]initWithFrame:CGRectMake(0,0, fDeviceWidth, 0.5 *rateH)];
//    oneDivideLine.backgroundColor = dividingLineColor;
//     [bottomImage addSubview:oneDivideLine];
    
    CGFloat noteInfoX = 13 *rateW;
    CGFloat noteSpace = 12 *rateW;
    UILabel *noteInfo = [[UILabel alloc]initWithFrame:CGRectMake(noteInfoX,noteSpace , fDeviceWidth - 2 * noteInfoX, 52 *rateH)];
    self.noteInfo = noteInfo;
    noteInfo.alpha = 0.8;
    noteInfo.numberOfLines = 0;
    noteInfo.font = noteInfoFont;
    noteInfo.textColor = noteInfoTextColor;
    noteInfo.text = @"终于买到想嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻想嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻";
    //noteInfo.backgroundColor = [UIColor redColor];
    [bottomImage addSubview:noteInfo];
    
    
    UIImageView *tagImage = [[UIImageView alloc]initWithFrame:CGRectMake(noteInfoX, CGRectGetMaxY(noteInfo.frame) + space, 12 *rateW, 12 *rateH)];
    
    tagImage.image = [UIImage imageNamed:@"ic_home_2tag"];
    [bottomImage addSubview:tagImage];
    self.tagImage = tagImage;
    [tagImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:noteInfoX];
    [tagImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noteInfo withOffset:12 *rateH];
    [tagImage autoSetDimension:ALDimensionWidth toSize:12 *rateW];
    [tagImage autoSetDimension:ALDimensionHeight toSize:12 *rateH];
    
    CGFloat tagSpace = 17*rateW;
    /** 时间*/
    UILabel *publishTime = [[UILabel alloc]init];
    publishTime.text = @"7小时前";
    publishTime.textColor = PYColor(@"afafaf");
    publishTime.font = noteMarkFont;
    //publishTime.alpha = 0.2;
    self.publishTime = publishTime;
    [bottomImage addSubview:publishTime];
    [publishTime autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-noteInfoX*rateW];
   
    [publishTime autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noteInfo withOffset:12 *rateH];
  //  [publishTime autoSetDimension:ALDimensionWidth toSize:9 *rateW];
    [publishTime autoSetDimension:ALDimensionHeight toSize:13 *rateH];
    // 时间图片
    UIImageView *timeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_home_time"]];
    self.timeImage = timeImage;
    [bottomImage addSubview:timeImage];
    
    [timeImage autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:publishTime withOffset:-4*rateW];
    [timeImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noteInfo withOffset:12 *rateH];
    [timeImage autoSetDimension:ALDimensionWidth toSize:14 *rateW];
    [timeImage autoSetDimension:ALDimensionHeight toSize:14 *rateH];
   // 第一个标签
    UIButton *tagOneBtn = [[UIButton alloc]init];
    [tagOneBtn setTitleColor:noteMarkColor forState:UIControlStateNormal];
    tagOneBtn.titleLabel.font = noteMarkFont;
    self.tagOneBtn =tagOneBtn;
    [bottomImage addSubview:tagOneBtn];
    [tagOneBtn setTitle:@"日本" forState:UIControlStateNormal];
    [tagOneBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tagImage withOffset:tagSpace*rateW];
    [tagOneBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noteInfo withOffset:12 *rateH];
    [tagOneBtn autoSetDimension:ALDimensionHeight toSize:13 *rateH];
    
    // 第二个标签
    UIButton *tagTwoBtn = [[UIButton alloc]init];
    [tagTwoBtn setTitleColor:noteMarkColor forState:UIControlStateNormal];
    tagTwoBtn.titleLabel.font = noteMarkFont;
    self.tagTwoBtn = tagTwoBtn;
    [self addSubview:tagTwoBtn];
    [tagTwoBtn setTitle:@"果酱" forState:UIControlStateNormal];
    [tagTwoBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tagOneBtn withOffset:tagSpace*rateW];
    [tagTwoBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noteInfo withOffset:12 *rateH];
    [tagTwoBtn autoSetDimension:ALDimensionHeight toSize:13 *rateH];
    // 第三个标签
    UIButton *tagThreeBtn = [[UIButton alloc]init];
    [tagThreeBtn setTitleColor:noteMarkColor forState:UIControlStateNormal];
    tagThreeBtn.titleLabel.font = noteMarkFont;
    self.tagThreeBtn = tagThreeBtn;
    [self addSubview:tagThreeBtn];
    [tagThreeBtn setTitle:@"松饼松饼松饼" forState:UIControlStateNormal];
    [tagThreeBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tagTwoBtn withOffset:tagSpace*rateW];
    [tagThreeBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noteInfo withOffset:12 *rateH];
    [tagThreeBtn autoSetDimension:ALDimensionHeight toSize:13 *rateH];
    
    // 第四个标签
    UIButton *tagFourBtn = [[UIButton alloc]init];
    [tagFourBtn setTitleColor:noteMarkColor forState:UIControlStateNormal];
    tagFourBtn.titleLabel.font = noteMarkFont;
    self.tagFourBtn = tagFourBtn;
    [self addSubview:tagFourBtn];
    [tagFourBtn setTitle:@"代购" forState:UIControlStateNormal];
    [tagFourBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tagThreeBtn withOffset:tagSpace*rateW];
    [tagFourBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noteInfo withOffset:12 *rateH];
    [tagFourBtn autoSetDimension:ALDimensionHeight toSize:13 *rateH];
  
    // 分割线
    UIView *twoDivideLine = [[UIView alloc]initWithFrame:CGRectMake(0, 15 *rateH + CGRectGetMaxY(tagImage.frame), fDeviceWidth, 0.5 *rateH)];
    twoDivideLine.backgroundColor = PYColor(@"ececec");
    //twoDivideLine.alpha = 0.16;
    [bottomImage addSubview:twoDivideLine];
    [twoDivideLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:tagSpace*rateW];
    [twoDivideLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-tagSpace*rateW];
    [twoDivideLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tagImage withOffset:15 *rateH];
    [twoDivideLine autoSetDimension:ALDimensionHeight toSize:0.5 *rateH];
    
    
    
}
/** 设置底部*/
- (void)setupBottom
{
    CGFloat bottomH = 36 *rateH;
    CGFloat BtnFont = 12 *rateH;
    CGFloat btnWidth = (fDeviceWidth - 2 *15 *rateW)/ 3.0f;
    UIColor *btnColor = noteCommentBtnTitleColor;
    CGFloat LineH = BtnFont;
    CGFloat LineY = (bottomH - LineH) * 0.5;
    CGFloat LineW = 0.5 * rateW;
 
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tagImage.frame) + 15.5 *rateH , fDeviceWidth, bottomH)];
    [self.bottomImage addSubview:bottomView];
    
    [bottomView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15*rateW];
    [bottomView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15*rateW];
    [bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tagImage withOffset:15.5 *rateH];
    [bottomView autoSetDimension:ALDimensionHeight toSize:bottomH];

    /** 评论*/
    UIButton *commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,btnWidth, bottomH)];
    self.commentBtn = commentBtn;
    [commentBtn setTitle:@"评论5" forState:UIControlStateNormal];
    [commentBtn setTitleColor: btnColor forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"ic_home_nomal_postcomment"] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"ic_home_press_postcomment"] forState:UIControlStateSelected];
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 *rateW)];
   // commentBtn.alpha = 0.4;
    commentBtn.titleLabel.font = noteCommentBtnTitleFont;
    [bottomView addSubview:commentBtn];
    [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(btnWidth - LineW , LineY, LineW, LineH)];
    lineOne.backgroundColor = PYColor(@"ececec");
    //lineOne.alpha = 0.2;
    [bottomView addSubview:lineOne];
    /** 点赞*/
    UIButton *praiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnWidth, 0,  btnWidth, bottomH)];
    self.praiseBtn = praiseBtn;
    [praiseBtn setTitle:@"点赞1252" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:btnColor forState:UIControlStateNormal];
    praiseBtn.titleLabel.font = noteCommentBtnTitleFont;
    [praiseBtn setImage:[UIImage imageNamed:@"ic_home_nomal_praise"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"ic_home_press_praise"] forState:UIControlStateSelected];
    //praiseBtn.alpha = 0.4;
    [praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 *rateW)];
    [praiseBtn addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:praiseBtn];
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(2 *btnWidth - LineW , LineY, LineW, LineH)];
    lineTwo.backgroundColor = PYColor(@"ececec");
  //  lineTwo.alpha = 0.2;
    [bottomView addSubview:lineTwo];
    
    /** 更多*/
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(2 * btnWidth, 0,  btnWidth, bottomH)];
    self.moreBtn = moreBtn;
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"ic_home_nomal_more"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"ic_home_press_more"] forState:UIControlStateSelected];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 *rateW)];
   // moreBtn.alpha = 0.4;
    moreBtn.titleLabel.font = noteCommentBtnTitleFont;
    [bottomView addSubview:moreBtn];
    
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(bottomView.frame) , fDeviceWidth, 0.5 *rateH)];
    bottomLine.backgroundColor = PYColor(@"cccccc");
    //bottomLine.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:bottomLine];
    [bottomLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
    [bottomLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
    [bottomLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:bottomView withOffset:1 *rateH];
    [bottomLine autoSetDimension:ALDimensionHeight toSize:0.5*rateH];

}

- (void)setModel:(NoteInfoModel *)model
{
    _model = model;
  
    
   [self.headImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"userIcon/icon%@.jpg",model.userId]]]placeholderImage:[UIImage imageNamed:@"img_default_user"]];
    self.nameLable.text = model.userDisplayName;
    self.addressLable.text = model.noteLocation;
   
    //self.attentionBtn.hidden = model.followed;
   
    NSString *userId = [model.userId get2Subs];
    NSString *url = [[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_1.jpg",userId,model.noteId]];
    [self.noteImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
    self.noteInfo.text = model.noteDesc;
    
      NSDictionary *browseCountDic = @{NSFontAttributeName: noteInfoFont};
     CGSize  descH =[model.noteDesc boundingRectWithSize:CGSizeMake(fDeviceWidth -26 *rateW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:browseCountDic context:nil].size;
    if(descH.height >51 *rateH)descH.height=51*rateH;
     self.noteInfo.height = descH.height;
//    
//    CGFloat noteImageHeight = 263*rateH ;
//    self.noteImage.height = noteImageHeight;
//    self.noteImage.width = fDeviceWidth * (noteImageHeight / 263 *rateH);
   // self.noteImage.x = - (self.noteImage.width - fDeviceWidth) *0.5;
     self.bottomImage.height = 12 *rateH+descH.height*rateH +12 *rateH +14*rateH +15 *rateH+36*rateH;
    // 标签
    NSArray *tagsArray=[NSArray arrayWithArray:[model.tags componentsSeparatedByString:@","]];
    if(tagsArray.count == 1)
    {
        [self.tagOneBtn setTitle:tagsArray[0] forState:UIControlStateNormal];
        self.tagTwoBtn.hidden = self.tagThreeBtn.hidden = self.tagFourBtn.hidden = YES;
        self.tagOneBtn.hidden = NO;
     
    }else if(tagsArray.count == 2)
    {
        [self.tagOneBtn setTitle:tagsArray[0] forState:UIControlStateNormal];
        [self.tagTwoBtn setTitle:tagsArray[1] forState:UIControlStateNormal];
         self.tagThreeBtn.hidden = self.tagFourBtn.hidden = YES;
        self.tagOneBtn.hidden =self.tagTwoBtn.hidden = NO;
    }else if(tagsArray.count == 3)
    {
        [self.tagOneBtn setTitle:tagsArray[0] forState:UIControlStateNormal];
        [self.tagTwoBtn setTitle:tagsArray[1] forState:UIControlStateNormal];
        [self.tagThreeBtn setTitle:tagsArray[2] forState:UIControlStateNormal];
      
        self.tagTwoBtn.hidden = self.tagThreeBtn.hidden = self.tagOneBtn.hidden = NO;
        self.tagFourBtn.hidden = YES;
    }else if(tagsArray.count == 4)
    {
        [self.tagOneBtn setTitle:tagsArray[0] forState:UIControlStateNormal];
        [self.tagTwoBtn setTitle:tagsArray[1] forState:UIControlStateNormal];
        [self.tagThreeBtn setTitle:tagsArray[2] forState:UIControlStateNormal];
        [self.tagFourBtn setTitle:tagsArray[3] forState:UIControlStateNormal];
   
        self.tagOneBtn.hidden =self.tagTwoBtn.hidden = self.tagThreeBtn.hidden = self.tagFourBtn.hidden = NO;
 
    }else
    {
          self.tagOneBtn.hidden =self.tagTwoBtn.hidden = self.tagThreeBtn.hidden = self.tagFourBtn.hidden = YES;
    }
    
    if (CGRectGetMinX(self.timeImage.frame)>0&&(CGRectGetMaxX(self.tagFourBtn.frame) + 17 *rateW > CGRectGetMinX(self.timeImage.frame))) {
        self.tagFourBtn.hidden = YES;
    }else
    {
        if(tagsArray.count == 4) self.tagFourBtn.hidden = NO;
    }
    if (CGRectGetMinX(self.timeImage.frame)>0&&(CGRectGetMaxX(self.tagThreeBtn.frame) + 17 *rateW > CGRectGetMinX(self.timeImage.frame))) {
        self.tagThreeBtn.hidden = YES;
    }else
    {
        if(tagsArray.count >= 3)  self.tagThreeBtn.hidden = NO;
    }
    
    if (CGRectGetMinX(self.timeImage.frame)>0&&(CGRectGetMaxX(self.tagTwoBtn.frame) + 17 *rateW > CGRectGetMinX(self.timeImage.frame))) {
        self.tagTwoBtn.hidden = YES;
    }else
    {
        if(tagsArray.count >= 2)  self.tagTwoBtn.hidden = NO;
    }
    if (CGRectGetMinX(self.timeImage.frame)>0&&(CGRectGetMaxX(self.tagOneBtn.frame) + 17 *rateW > CGRectGetMinX(self.timeImage.frame))) {
        self.tagOneBtn.hidden = YES;
    }else
    {
        if(tagsArray.count >= 1)  self.tagOneBtn.hidden = NO;
    }
    
    if(model.isLiked)
    {
       self.praiseBtn.selected =YES;
        //self.praiseBtn.alpha = 0.8;
    }else
    {
        self.praiseBtn.selected =NO;
        //self.praiseBtn.alpha = 0.4;
    }
    self.attentionBtn.selected = model.followed;
    
 
    [self.commentBtn setTitle:[NSString stringWithFormat:@"评论%@",model.comments] forState:UIControlStateNormal];
     [self.praiseBtn setTitle:[NSString stringWithFormat:@"点赞%@",model.likes] forState:UIControlStateNormal];
    self.praiseCount = [model.likes intValue];
    
//    PYLog(@"%@",);
//    
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *dead = [fmt dateFromString:model.postTime];
//    NSDate *now = [NSDate date];
//    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute|NSCalendarUnitSecond;
//    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:dead toDate:now options:0];
//    if (cmps.year) {
//        self.publishTime.text = [NSString stringWithFormat:@"%d年前",cmps.year];
//        return;
//    }else if (cmps.month)
//    {
//        self.publishTime.text = [NSString stringWithFormat:@"%d月前",cmps.month];
//        return;
//    }
//    else if (cmps.day) {
//        
//        self.publishTime.text = [NSString stringWithFormat:@"%d天前",cmps.day];
//        return;
//    }else if (cmps.hour)
//    {
//        self.publishTime.text = [NSString stringWithFormat:@"%d小时前",cmps.hour];
//        return;
//    }else if (cmps.minute)
//    {
//        self.publishTime.text = [NSString stringWithFormat:@"%d分钟前",cmps.minute];
//        return;
//    }else if (cmps.second)
//    {
//        self.publishTime.text = [NSString stringWithFormat:@"%d秒前",cmps.second];
//        return;
//    }
    self.publishTime.text = [TimeIntervalTool getTimeInterValToNowWithString:model.leftMinutes];
    
    //没有定位信息，名字居中
    if ([model.noteLocation isEqualToString:@""]) {
        self.nameLable.y = 0;
        self.nameLable.height = 56*rateH;
    }else
    {
        self.nameLable.y = 13 *rateH;
        self.nameLable.height = 13 *rateH;
    
    }
}

#pragma mark -点击事件
- (void)commentBtnClick
{
    if ([self.delegate respondsToSelector:@selector(CommentBtnClick:withUserId:)]) {
        [self.delegate CommentBtnClick:self.model.noteId withUserId:self.model.userId];
    }
}

- (void)praiseBtnClick
{
    NSDictionary *param = @{@"token":[CMData getToken],
                            @"userId":@([CMData getUserIdForInt]),
                            @"noteId":self.model.noteId,
                            @"targetId":self.model.userId,
                            @"isLiked":self.praiseBtn.selected?@"no":@"yes"};
    
//    int likeCount = [self.praiseBtn.currentTitle intValue] ;
    [CommonInterface callingInterfacePraise:param succeed:^{
        
     //   [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
        if (self.praiseBtn.selected) {
            self.praiseCount --;
           //  [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
            self.praiseBtn.selected = NO;
            self.praiseBtn.alpha = 0.4;
           [self.praiseBtn setTitle:[NSString stringWithFormat:@"点赞%d",self.praiseCount ] forState:UIControlStateNormal];
        }else
        {
       
              [SVProgressHUD showSuccessWithStatus:@"积分+1"];
             self.praiseCount ++;
            self.praiseBtn.selected = YES;
            self.praiseBtn.alpha = 0.8;
            [self.praiseBtn setTitle:[NSString stringWithFormat:@"点赞%d",self.praiseCount ] forState:UIControlStateNormal];
        }
    }];
}

- (void)attentionBtnClick
{
    
    
    if ([[CMData getToken] isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:DEFAULT_NO_LOGIN];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [CMData  getToken];
    param[@"userId"] = @([CMData getUserIdForInt]);
    param[@"attentionType"] = @(2);
    param[@"attentionObject"] = self.model.userId;
    if(self.attentionBtn.selected)
    {
         param[@"attention"] = @"no";
    }else
    {
         param[@"attention"] = @"yes";
    }
   
    
    [CommonInterface callingInterfaceAttention:param succeed:^{
        
        if (self.attentionBtn.selected) {
            
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            self.attentionBtn.selected = NO;
        }else
        {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            self.attentionBtn.selected = YES;
        }
     
    }];
}

-(void)moreBtnClick
{
    if ([self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
        [self.delegate moreBtnClick:self.model];
    }
}
@end
