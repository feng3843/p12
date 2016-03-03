//
//  NoteInfoFrame.m
//  FlashTag
//
//  Created by 夏雪 on 15/8/28.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//

#import "NoteDetailFrame.h"
#import "NoteConst.h"
#import "NoteDetailModel.h"
@implementation NoteDetailFrame

- (void)setNoteInfo:(NoteDetailModel *)noteInfo
{
    _noteInfo = noteInfo;
    

    _noteImageF = CGRectMake(0, 0.5 *rateH, fDeviceWidth, noteDetailImageH * [noteInfo.notePicCount intValue] + 2 *rateH * ([noteInfo.notePicCount intValue] - 1));
     
     /** 帖子描述*/
    CGFloat descNoteX = noteDetailSpace;
    CGFloat descNoteY =  CGRectGetMaxY(_noteImageF) + noteDetailSpace;
    CGFloat descNoteW = fDeviceWidth - 2 *PYSpaceX;
    NSDictionary *descDic = @{NSFontAttributeName: noteDetailFont};
   CGSize  descNoteSize = [noteInfo.noteDesc boundingRectWithSize:CGSizeMake(descNoteW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:descDic context:nil].size;
    _descNoteF = (CGRect){{descNoteX, descNoteY}, descNoteSize};
    
    /** 标签*/
   _tagImageF = CGRectMake(noteDetailSpace, CGRectGetMaxY(_descNoteF) + noteDetailSpace, 12 *rateW, 12 *rateH);
    
    
   
        NSArray *tagsArray=[NSArray arrayWithArray:[noteInfo.tags componentsSeparatedByString:@","]];
    
    CGFloat tagY = CGRectGetMaxY(_tagImageF) + 20 *rateH;
    
    CGFloat tagBtnH = 12 *rateH;
    
    if (tagsArray.count == 1) {
     _tagOneBtnF = CGRectMake(CGRectGetMaxX(_tagImageF) + 16 *rateW, CGRectGetMinY(_tagImageF) + 1 *rateH, [self getTagWidth:tagsArray[0]], tagBtnH);
        
    }else if (tagsArray.count == 2)
    {
        _tagOneBtnF = CGRectMake(CGRectGetMaxX(_tagImageF) + 16 *rateW, CGRectGetMinY(_tagImageF) + 1 *rateH, [self getTagWidth:tagsArray[0]], tagBtnH);
       _tagTwoBtnF = CGRectMake(CGRectGetMaxX(_tagOneBtnF) + 20 *rateW, CGRectGetMinY(_tagImageF) + 1 *rateH, [self getTagWidth:tagsArray[1]],tagBtnH);
    }else if (tagsArray.count == 3)
    {
        _tagOneBtnF = CGRectMake(CGRectGetMaxX(_tagImageF) + 16 *rateW, CGRectGetMinY(_tagImageF) + 1 *rateH, [self getTagWidth:tagsArray[0]], tagBtnH);
        _tagTwoBtnF = CGRectMake(CGRectGetMaxX(_tagOneBtnF) + 20 *rateW, CGRectGetMinY(_tagImageF) + 1 *rateH, [self getTagWidth:tagsArray[1]], tagBtnH);
        
        CGFloat width = [self getTagWidth:tagsArray[2]];
        if (fDeviceWidth < ( 2 *noteDetailSpace + width +20 *rateW + CGRectGetMaxX(_tagTwoBtnF))) {
            _tagThreeBtnF = CGRectMake(CGRectGetMaxX(_tagImageF) + 16 *rateW, CGRectGetMaxY(_tagOneBtnF) + 10 *rateH, width, tagBtnH);
          //  [self.threeBtn setTitle:title forState:UIControlStateNormal];
            tagY = CGRectGetMaxY(_tagThreeBtnF) + 20 *rateH;
        }else
        {
         _tagThreeBtnF = CGRectMake(CGRectGetMaxX(_tagTwoBtnF) + 20 *rateW,CGRectGetMinY(_tagImageF) + 1 *rateH, width, tagBtnH);
        }
    }else if(tagsArray.count == 4)
    {
        _tagOneBtnF = CGRectMake(CGRectGetMaxX(_tagImageF) + 16 *rateW, CGRectGetMinY(_tagImageF) + 1 *rateH, [self getTagWidth:tagsArray[0]], tagBtnH);
        _tagTwoBtnF = CGRectMake(CGRectGetMaxX(_tagOneBtnF) + 20 *rateW, CGRectGetMinY(_tagImageF) + 1 *rateH, [self getTagWidth:tagsArray[1]], tagBtnH);
        
        CGFloat width = [self getTagWidth:tagsArray[2]];
        if (fDeviceWidth < ( 2 *noteDetailSpace + width +20 *rateW + CGRectGetMaxX(_tagTwoBtnF))) {
            _tagThreeBtnF = CGRectMake(CGRectGetMaxX(_tagImageF) + 16 *rateW, CGRectGetMaxY(_tagOneBtnF) + 10 *rateH, width, tagBtnH);
            _tagFourBtnF = CGRectMake(CGRectGetMaxX(_tagThreeBtnF) + 20 *rateH, CGRectGetMaxY(_tagOneBtnF) +10 *rateH, [self getTagWidth:tagsArray[3]], tagBtnH);
         tagY = CGRectGetMaxY(_tagThreeBtnF) + 20 *rateH;
        }else
        {
            
            _tagThreeBtnF = CGRectMake(CGRectGetMaxX(_tagTwoBtnF) + 20 *rateW,CGRectGetMinY(_tagImageF) + 1 *rateH, width, tagBtnH);
            
            CGFloat fourBtnWidth = [self getTagWidth:tagsArray[3]];
            if (fDeviceWidth < ( 2 *noteDetailSpace + fourBtnWidth +20 *rateW + CGRectGetMaxX(_tagThreeBtnF))) {
           _tagFourBtnF = CGRectMake(CGRectGetMaxX(_tagImageF) + 16 *rateW, CGRectGetMaxY(_tagOneBtnF) + 10 *rateH, fourBtnWidth, tagBtnH);
            tagY = CGRectGetMaxY(_tagFourBtnF) + 20 *rateH;
                
            }else
            {
            _tagThreeBtnF = CGRectMake(CGRectGetMaxX(_tagThreeBtnF) + 20 *rateW,CGRectGetMinY(_tagImageF) + 1 *rateH, fourBtnWidth, tagBtnH);
            }
         }
        
    }
  
    /** 浏览量*/
    NSDictionary *browseCountDic = @{NSFontAttributeName: noteBrowseCountTextFont};
    CGSize  browseCountSize = [[NSString stringWithFormat:@"浏览%@",[noteInfo.browseNum stringValue]] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:browseCountDic context:nil].size;
    CGFloat browseCountW = browseCountSize.width;
    CGFloat browseCountX = fDeviceWidth - browseCountW - PYSpaceX;
    CGFloat browseCountY = tagY ;
    _browseCountF = (CGRect){{browseCountX, browseCountY}, browseCountSize};
    /** 发布时间*/

    CGFloat publishTimeW = fDeviceWidth  - 2 * PYSpaceX - browseCountW;
    CGFloat publishTimeX = noteDetailSpace;
    CGFloat publishTimeY = tagY ;
    _publishTimeF = CGRectMake(publishTimeX, publishTimeY, publishTimeW, browseCountSize.height);
    
    _cellHeight = CGRectGetMaxY(_publishTimeF) + 16 *rateH;
    
    
}


- (CGFloat)getTagWidth:(NSString *)title
{
    NSDictionary *browseCountDic = @{NSFontAttributeName: noteDetailMarkFont};
    CGSize  tagOneBtn =[title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:browseCountDic context:nil].size;
    return tagOneBtn.width ;
}
@end
