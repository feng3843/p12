//
//  MarkView.m
//  MarkDemo
//
//  Created by py on 15/9/3.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import "MarkView.h"
#import <objc/runtime.h>
#import "UIImage+Extensions.h"

static void *DragEnableKey = &DragEnableKey;
@interface MarkView ()
/** mark上的字*/
@property(nonatomic,weak)UIButton *titleBtn;

@end

@implementation MarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        BgView.backgroundColor = [UIColor whiteColor];
        BgView.alpha = 0.3;
        [self addSubview:BgView];
        BgView.layer.cornerRadius = 7;
        BgView.clipsToBounds = YES;
        UIButton *circleBtn = [[UIButton alloc]initWithFrame:CGRectMake(3.5, 3.5, 8, 8)];
        circleBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:circleBtn];
        circleBtn.layer.cornerRadius = 3.5;
        circleBtn.clipsToBounds = YES;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12.5, 12.5, 200, 25)];
//        btn.backgroundColor = [UIColor greenColor];
        [btn setBackgroundImage:[UIImage resizedImage:@"img_mark_text.png"] forState:UIControlStateNormal];
        [btn setTitle:@"非常美味非常美味" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:btn];
        self.titleBtn = btn;
        btn.userInteractionEnabled = NO;
    }
    return self;
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    
    NSDictionary *dic = @{NSFontAttributeName :[UIFont systemFontOfSize:15]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.titleBtn.frame = CGRectMake(12.5, 12.5, size.width + 20 , 25);
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
    
    
}
-(void)setDragEnable:(BOOL)dragEnable
{
    objc_setAssociatedObject(self, DragEnableKey,@(dragEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isDragEnable
{
    return [objc_getAssociatedObject(self, DragEnableKey) boolValue];
}


CGPoint beginPoint;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    
    //x轴左右极限坐标
    if (self.center.x > (self.superview.frame.size.width-self.frame.size.width/2))
    {
        CGFloat x = self.superview.frame.size.width-self.frame.size.width/2;
        self.center = CGPointMake(x, self.center.y + offsetY);
    }
    else if (self.center.x < self.frame.size.width/2)
    {
        CGFloat x = self.frame.size.width/2;
        self.center = CGPointMake(x, self.center.y + offsetY);
    }
    
    //y轴上下极限坐标
    if (self.center.y > (self.superview.frame.size.height-self.frame.size.height/2))
    {
        CGFloat x = self.center.x;
        CGFloat y = self.superview.frame.size.height-self.frame.size.height/2;
        self.center = CGPointMake(x, y);
    }
    else if (self.center.y <= self.frame.size.height/2)
    {
        CGFloat x = self.center.x;
        CGFloat y = self.frame.size.height/2;
        self.center = CGPointMake(x, y);
    }
}



@end
