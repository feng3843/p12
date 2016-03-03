////
////  IMConsTableViewCell.m
////  FlashTag
////
////  Created by LA－PC on 15/9/11.
////  Copyright (c) 2015年 Puyun. All rights reserved.
////
//
//#import "IMConsTableViewCell.h"
//#import "UIImageView+AFNetworking.h"
//#import "UUMessageFrame.h"
//
//#import "LibCM.h"
//
//#define CELLIconWH 40
//#define CELLTimeFont [UIFont systemFontOfSize:11]   //时间字体
//#define CELLNAMEFONT [UIFont systemFontOfSize:16]   //名称字体
//#define CELLOTHERFONT [UIFont systemFontOfSize:12]   //其他字体
//#define CELLNAMECOLOR @"000000"     //名称颜色
//#define CELLOTHERCOLOR @"BABAB6"     //其他颜色
//#define CELLTIMECOLOR @"BABAB6"     //时间颜色
//#define CELLHEIGHT 54
//#define CELLMARGIN 7
//#define CELLWIDTH [[UIScreen mainScreen] bounds].size.width
//
//
//@interface IMConsTableViewCell ()
//{
//    UIView *imgBgView;
//    UIImageView *imgAvatar;
//    UILabel *labName;
//    UILabel *labOther;
//    UILabel *labLastTime;
//}
//@end
//
//@implementation IMConsTableViewCell
//
//
//
//-(id)initWithFrame:(CGRect)frame{
//    
//    self=[super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor=[UIColor redColor];
//    }
//    
//    return self;
//}
//
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if(self){
//        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CELLWIDTH, CELLHEIGHT)];
//        view.backgroundColor=[UIColor whiteColor];
//        imgAvatar=[[UIImageView alloc]initWithFrame:CGRectMake(1, 1, CELLIconWH-2, CELLIconWH-2)];
//        imgAvatar.layer.masksToBounds=YES;
//        imgAvatar.layer.cornerRadius=imgAvatar.bounds.size.width*0.5;
//        imgBgView=[[UIView alloc]initWithFrame:CGRectMake(10,CELLMARGIN, CELLIconWH, CELLIconWH)];
//        imgBgView.layer.masksToBounds=YES;
//        imgBgView.layer.cornerRadius=CELLIconWH*0.5;
//        imgBgView.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.4];
//        [imgBgView addSubview:imgAvatar];
//        [view addSubview:imgBgView];
//        labName=[[UILabel alloc]initWithFrame:CGRectMake(54,CELLMARGIN, 200, CELLHEIGHT*0.5-CELLMARGIN)];
//        labName.font=CELLNAMEFONT;
//        labName.textAlignment=NSTextAlignmentLeft;
//        labName.textColor=[UIColor colorWithHexString:CELLNAMECOLOR];
//        [view addSubview:labName];
//        labOther=[[UILabel alloc]initWithFrame:CGRectMake(54,CELLHEIGHT*0.5, 200, CELLHEIGHT*0.5-CELLMARGIN)];
//        labOther.font=CELLOTHERFONT;
//        labOther.textAlignment=NSTextAlignmentLeft;
//        labOther.textColor=[UIColor colorWithHexString:CELLOTHERCOLOR];
////        labOther.backgroundColor=[UIColor redColor];
//        [view addSubview:labOther];
//        labLastTime=[[UILabel alloc]initWithFrame:CGRectMake(CELLWIDTH-80-20, 0, 80, CELLHEIGHT/2)];
//        labLastTime.textAlignment=NSTextAlignmentRight;
//        labLastTime.textColor=[UIColor colorWithHexString:CELLTIMECOLOR];
//        labLastTime.font=CELLTimeFont;
////        labLastTime.backgroundColor=[UIColor redColor];
//        [view addSubview:labLastTime];
//        [self addSubview:view];
//    }
//    
//    return self;
//}
//
//-(void)setStrAvatar:(NSString *)strAvatar
//{
//    [imgAvatar sd_setImageWithURL:[NSURL URLWithString:strAvatar] placeholderImage:[UIImage imageNamed:@"headImage.jpeg"]];
//}
//
//-(void)setStrName:(NSString *)strName
//{
//    labName.text=strName;
//}
//
//-(NSString*)strName
//{
//    return labName.text;
//}
//
//-(void)setStrOther:(NSString *)strOther
//{
//    labOther.text=strOther;
//}
//
//-(void)setStrLastTime:(NSString *)strLastTime
//{
//    labLastTime.text=strLastTime;
//}
//
//
//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}
//
//
//@end
