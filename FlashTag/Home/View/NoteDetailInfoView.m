//
//  NoteDetailInfoView.m
//  FlashTag
//
//  Created by 夏雪 on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  帖子详情介绍

#import "NoteDetailInfoView.h"
#import "PYAllCommon.h"
#import "NoteConst.h"
#import "NoteDetailFrame.h"
#import "NoteDetailModel.h"
#import "SDImageView+SDWebCache.h"
#import "NSString+Extensions.h"
#import "MarkView.h"
@interface NoteDetailInfoView ()

/** 帖子照片*/
@property(nonatomic ,weak)UIImageView *noteImage;
@property(nonatomic ,weak)UIImageView *noteTwoImage;
@property(nonatomic ,weak)UIImageView *noteThreeImage;
@property(nonatomic ,weak)UIImageView *noteFourImage;
/** 帖子描述*/
@property(nonatomic ,weak)UILabel *descNote;
/** 标签*/
@property(nonatomic ,weak)UIImageView *tagImage;
@property(nonatomic,weak)UIButton *tagOneBtn;
@property(nonatomic,weak)UIButton *tagTwoBtn;
@property(nonatomic,weak)UIButton *tagThreeBtn;
@property(nonatomic,weak)UIButton *tagFourBtn;
/** 发布时间*/
@property(nonatomic ,weak)UILabel *publishTime;
/** 浏览量*/
@property(nonatomic ,weak)UILabel *browseCount;
@property(nonatomic,weak)UIView *line;
@end
@implementation NoteDetailInfoView
 
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGFloat imageSpace = 2*rateH;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *oneLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, 0.5 *rateH)];
        oneLine.backgroundColor = PYColor(@"bbbbbb");
        [self addSubview:oneLine];
        
        /** 帖子照片*/
        UIImageView *noteImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, noteDetailImageH)];
        noteImage.image = [UIImage imageNamed:@"Thome.png"];
        noteImage.contentMode = UIViewContentModeScaleAspectFill;
        noteImage.clipsToBounds = YES;
        self.noteImage = noteImage;
        noteImage.tag = 1;
        [self.contentView addSubview:noteImage];
        
        UIImageView *noteTwoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noteImage.frame) + imageSpace , fDeviceWidth, noteDetailImageH)];
        noteTwoImage.image = [UIImage imageNamed:@"Thome.png"];
        noteTwoImage.contentMode = UIViewContentModeScaleAspectFill;
        noteTwoImage.clipsToBounds = YES;
        self.noteTwoImage = noteTwoImage;
        noteTwoImage.tag = 2;
       [self.contentView addSubview:noteTwoImage];
        
        UIImageView *noteThreeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noteTwoImage.frame) + imageSpace, fDeviceWidth, noteDetailImageH)];
        noteThreeImage.image = [UIImage imageNamed:@"Thome.png"];
        noteThreeImage.contentMode = UIViewContentModeScaleAspectFill;
        noteThreeImage.clipsToBounds = YES;
        self.noteThreeImage = noteThreeImage;
         noteThreeImage.tag = 3;
        [self.contentView addSubview:noteThreeImage];
        
        UIImageView *noteFourImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noteThreeImage.frame) + imageSpace, fDeviceWidth, noteDetailImageH)];
        noteFourImage.image = [UIImage imageNamed:@"Thome.png"];
        noteFourImage.contentMode = UIViewContentModeScaleAspectFill;
        noteFourImage.clipsToBounds = YES;
        self.noteFourImage = noteFourImage;
         noteFourImage.tag = 4;
        [self.contentView addSubview:noteFourImage];
        /** 帖子描述*/
        UILabel *descNote = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noteImage.frame), fDeviceWidth, 180)];
//        descNote.backgroundColor = [UIColor redColor];
        descNote.font = noteDetailFont;
        descNote.textColor = noteDetailTextColor;
        self.descNote = descNote;
        descNote.numberOfLines = 0;
        [self.contentView addSubview:descNote];
        descNote.text = @"加载中...";
        /** 标签*/
        UIImageView *tagImage = [[UIImageView alloc]initWithFrame:CGRectMake(noteDetailSpace, CGRectGetMaxY(descNote.frame), 12 *rateW, 12 *rateH)];
        tagImage.image = [UIImage imageNamed:@"ic_home_2tag"];
        self.tagImage = tagImage;
        [self addSubview:tagImage];
        
        UIButton *tagOneBtn = [[UIButton alloc]init];
        [tagOneBtn setTitleColor:noteDetailMarkTextColor forState:UIControlStateNormal];
        tagOneBtn.titleLabel.font = noteDetailMarkFont;
        self.tagOneBtn =tagOneBtn;
        [tagOneBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tagOneBtn];
        
        UIButton *tagTwoBtn = [[UIButton alloc]init];
        [tagTwoBtn setTitleColor:noteDetailMarkTextColor forState:UIControlStateNormal];
         tagTwoBtn.titleLabel.font = noteDetailMarkFont;
        [tagTwoBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.tagTwoBtn = tagTwoBtn;
        
        [self addSubview:tagTwoBtn];
        
        UIButton *tagThreeBtn = [[UIButton alloc]init];
        [tagThreeBtn setTitleColor:noteDetailMarkTextColor forState:UIControlStateNormal];
         tagThreeBtn.titleLabel.font = noteDetailMarkFont;
        [tagThreeBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.tagThreeBtn = tagThreeBtn;
        [self addSubview:tagThreeBtn];
        
        UIButton *tagFourBtn = [[UIButton alloc]init];
        [tagFourBtn setTitleColor:noteDetailMarkTextColor forState:UIControlStateNormal];
         tagFourBtn.titleLabel.font = noteDetailMarkFont;
        [tagFourBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.tagFourBtn = tagFourBtn;
        [self addSubview:tagFourBtn];
        
//        /** 标签*/
//        UILabel *markLable = [[UILabel alloc]initWithFrame:CGRectMake(PYSpaceX, CGRectGetMaxY(descNote.frame), fDeviceWidth - PYSpaceX, 11 *rateH)];
//        markLable.text = @"标签：lamy 钢笔 限量版";
//        markLable.textColor = noteDetailMarkTextColor;
//        markLable.font = noteDetailMarkFont;
//        markLable.numberOfLines = 0;
//        self.markLable = markLable;
//        [self.contentView addSubview:markLable];
        /** 发布时间*/
        UILabel *publishTime = [[UILabel alloc]init];
        publishTime.text = @"发布于 2015-08-26 12：20";
        publishTime.textColor = notePublishTimeTextColor;
        publishTime.font = notePublishTimeTextFont;
        self.publishTime = publishTime;
        [self.contentView addSubview:publishTime];
        /** 浏览量*/
        UILabel *browseCount = [[UILabel alloc]init];
        browseCount.textAlignment = NSTextAlignmentRight;
        browseCount.font = noteBrowseCountTextFont;
        browseCount.textColor = noteBrowseCountTextColor;
        browseCount.text = @"浏览20342";
        self.browseCount = browseCount;
        [self.contentView addSubview:browseCount];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = PYColor(@"cccccc");
        [self.contentView addSubview:line];
        self.line = line;
    }
    return self;
}

- (void)setNoteInfoFrame:(NoteDetailFrame *)noteInfoFrame
{
    _noteInfoFrame = noteInfoFrame;
    
    NoteDetailModel *model = noteInfoFrame.noteInfo;
 
    [self.noteImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_1.jpg",[model.userId get2Subs],model.noteId]]] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
   
//    [self.noteImage sd_setImageWithURL:[NSURL URLWithString:@"http://haitao.beyondnet.com.cn:80/../haitao_res/02/note88_1.jpg"]  refreshCache:YES placeholderImage:[UIImage imageNamed:@"Thome.png"]];
//    [self.noteImage sd_setImageWithURL:[NSURL URLWithString:@"http://haitao.beyondnet.com.cn:80/../haitao_res/02/note88_1.jpg"] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
     if ([model.notePicCount intValue] == 2)
     {
     [self.noteTwoImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_2.jpg",[model.userId get2Subs],model.noteId]]] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
         self.noteThreeImage.hidden =  self.noteThreeImage.hidden = YES;
         self.noteTwoImage.hidden = NO;
     }else if ([model.notePicCount intValue] == 3)
    {
        [self.noteTwoImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_2.jpg",[model.userId get2Subs],model.noteId]]] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
          [self.noteThreeImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_3.jpg",[model.userId get2Subs],model.noteId]]] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
        self.noteFourImage.hidden = YES;
        self.noteTwoImage.hidden = self.noteThreeImage.hidden= NO;
    }else if ([model.notePicCount intValue] == 4)
    {
        [self.noteTwoImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_2.jpg",[model.userId get2Subs],model.noteId]]] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
        [self.noteThreeImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_3.jpg",[model.userId get2Subs],model.noteId]]] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
        [self.noteFourImage sd_setImageWithURL:[NSURL URLWithString:[[CMData getCommonImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/note%@_3.jpg",[model.userId get2Subs],model.noteId]]] placeholderImage:[UIImage imageNamed:@"Thome.png"]];
        self.noteTwoImage.hidden = self.noteThreeImage.hidden=self.noteFourImage.hidden= NO;
    }else
    {
         self.noteTwoImage.hidden = self.noteThreeImage.hidden=self.noteFourImage.hidden= YES;
    }
    
    
    
    /** 帖子描述*/
    self.descNote.text = model.noteDesc;
    self.descNote.frame = noteInfoFrame.descNoteF;
    /** 标签*/
    self.tagImage.frame = noteInfoFrame.tagImageF;
    NSArray *tagsArray=[NSArray arrayWithArray:[model.tags componentsSeparatedByString:@","]];
    if(tagsArray.count == 1)
    {
        [self.tagOneBtn setTitle:tagsArray[0] forState:UIControlStateNormal];
        self.tagOneBtn.frame = noteInfoFrame.tagOneBtnF;
        self.tagOneBtn.hidden = NO;
        self.tagTwoBtn.hidden = self.tagThreeBtn.hidden = self.tagFourBtn.hidden = YES;
    }else if(tagsArray.count == 2)
    {
        [self.tagOneBtn setTitle:tagsArray[0] forState:UIControlStateNormal];
        [self.tagTwoBtn setTitle:tagsArray[1] forState:UIControlStateNormal];
        self.tagOneBtn.frame = noteInfoFrame.tagOneBtnF;
        self.tagTwoBtn.frame = noteInfoFrame.tagTwoBtnF;
        self.tagOneBtn.hidden = self.tagTwoBtn.hidden =  NO;
       self.tagThreeBtn.hidden = self.tagFourBtn.hidden = YES;
    }else if(tagsArray.count == 3)
    {
        [self.tagOneBtn setTitle:tagsArray[0] forState:UIControlStateNormal];
        [self.tagTwoBtn setTitle:tagsArray[1] forState:UIControlStateNormal];
        [self.tagThreeBtn setTitle:tagsArray[2] forState:UIControlStateNormal];
        self.tagOneBtn.frame = noteInfoFrame.tagOneBtnF;
        self.tagTwoBtn.frame = noteInfoFrame.tagTwoBtnF;
        self.tagThreeBtn.frame = noteInfoFrame.tagThreeBtnF;
        self.tagOneBtn.hidden = self.tagTwoBtn.hidden =  self.tagThreeBtn.hidden = NO;
        self.tagFourBtn.hidden = YES;
    }else if(tagsArray.count == 4)
    {
        [self.tagOneBtn setTitle:tagsArray[0] forState:UIControlStateNormal];
        [self.tagTwoBtn setTitle:tagsArray[1] forState:UIControlStateNormal];
        [self.tagThreeBtn setTitle:tagsArray[2] forState:UIControlStateNormal];
        [self.tagFourBtn setTitle:tagsArray[3] forState:UIControlStateNormal];
        self.tagOneBtn.frame = noteInfoFrame.tagOneBtnF;
        self.tagTwoBtn.frame = noteInfoFrame.tagTwoBtnF;
        self.tagThreeBtn.frame = noteInfoFrame.tagThreeBtnF;
        self.tagFourBtn.frame = noteInfoFrame.tagFourBtnF;
        self.tagOneBtn.hidden = self.tagTwoBtn.hidden =  self.tagThreeBtn.hidden = self.tagFourBtn.hidden = NO;
    
    }
    /** 发布时间*/
    self.publishTime.text = [NSString stringWithFormat:@"发布于 %@",model.postTime];
    self.publishTime.frame = noteInfoFrame.publishTimeF;
    /** 浏览量*/
    self.browseCount.text = [NSString stringWithFormat:@"浏览%@",model.browseNum];
    self.browseCount.frame = noteInfoFrame.browseCountF;
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(noteInfoFrame.browseCountF) + (16 *rateH- 0.5*rateH), fDeviceWidth, 0.5 *rateH);
    
    // 1:40.16x59.32\;68.59x84.79,3:40.16x59.32\;68.59x84.79  markAttr
    // 1:手机\;5000元,3:手机\;5000元                             marks
  // mark和mark位置
    if(model.marks.length > 0)
    {
        NSArray *markArray = [model.marks componentsSeparatedByString:@","]; // 按照,分割
        NSArray *markAttrArray  = [model.markAttribute componentsSeparatedByString:@","];
        for (int i = 0;i< markArray.count ;i++) {
        
             NSArray *mark = [markArray[i]  componentsSeparatedByString:@":"];
            if ([mark[0] isEqualToString:@""]) {
                break;
            }
            NSInteger currentMarkInImage = [mark[0] integerValue];
            NSArray *markText = [mark[1]  componentsSeparatedByString:@"\\;"];
            NSArray *markAttr = [markAttrArray[i]  componentsSeparatedByString:@":"];
            NSArray *markAttrText = [markAttr[1] componentsSeparatedByString:@"\\;"];
            
            for(int j = 0;j<markText.count;j++)
            {
                
                if ([markText[j] isEqualToString:@""]) {
                    break;
                }
                NSDictionary *dic = @{NSFontAttributeName :[UIFont systemFontOfSize:15]};
                CGSize size = [markText[j] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
                NSArray *itemMarkAtti = [markAttrText[j] componentsSeparatedByString:@"x"];
                double markAttributesX = [itemMarkAtti[0] floatValue] * fDeviceWidth  / 100;
                double markAttributesY =[itemMarkAtti[1] floatValue] *  263 *rateH /100;
                MarkView *markView = [[MarkView alloc]initWithFrame:CGRectMake(markAttributesX, markAttributesY, size.width + 35, 40)];
                
                [markView setDragEnable:YES];
                [markView setTitle:markText[j]];
                
            UIImageView *currentImage = (UIImageView *)[self viewWithTag:currentMarkInImage];
                [currentImage addSubview:markView];
            }
        }
    }
}
- (void)tagBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(tagBtnClickWithTitle:)]) {
        [self.delegate tagBtnClickWithTitle:btn.currentTitle];
    }
}
@end
