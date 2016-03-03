//
//  JSBubbleMessageCell.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSBubbleMessageCell.h"
#import "UIColor+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"
#import "CDEmotionUtils.h"
#import "UIColor+Extensions.h"
#import "CDEmotionUtils.h"
#import "CMTool.h"
#import "CMAPI.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#define TIMESTAMP_LABEL_HEIGHT 20.0f
#define NAME_LABEL_HEIGHT 14.5f
CGFloat const kJSAvatarSize_Height=41.0f;
CGFloat const kJSAvatarSize_Width=40.5f;

@interface JSBubbleMessageCell()

@property (strong, nonatomic) JSBubbleView *bubbleView;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (assign, nonatomic) JSAvatarStyle avatarImageStyle;

- (void)setup;
- (void)configureTimestampLabel;

- (void)configureWithType:(JSBubbleMessageType)type
              bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
              avatarStyle:(JSAvatarStyle)avatarStyle
                mediaType:(JSBubbleMediaType)mediaType
                timestamp:(BOOL)hasTimestamp
                  hasName:(BOOL)hasName;

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress;
- (void)handleMenuWillHideNotification:(NSNotification *)notification;
- (void)handleMenuWillShowNotification:(NSNotification *)notification;

@end



@implementation JSBubbleMessageCell
@synthesize topMarigin;
#pragma mark - Setup
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPress:)];
    [recognizer setMinimumPressDuration:0.4];
    [self addGestureRecognizer:recognizer];
}

- (void)configureTimestampLabel
{
//    self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
//                                                                    4.0f,
//                                                                    self.bounds.size.width,
//                                                                    TIMESTAMP_LABEL_HEIGHT)];
//    self.timestampLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
//    self.timestampLabel.backgroundColor = [UIColor clearColor];
//    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
//    self.timestampLabel.textColor = [UIColor messagesTimestampColor];
//    self.timestampLabel.shadowColor = [UIColor whiteColor];
//    self.timestampLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    self.timestampLabel.font = [UIFont boldSystemFontOfSize:11.5f];
//    [self.contentView addSubview:self.timestampLabel];
//    [self.contentView bringSubviewToFront:self.timestampLabel];
    NSLog(@"topMarigin:%f",topMarigin);
    //LA 修改日期设置
    self.timestampLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.bounds.size.width-120)/2,topMarigin,120.0f, 20.0f)];
    
//    self.timestampLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.0f,17.0f,self.bounds.size.width, 20.0f)];
    self.timestampLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
    self.timestampLabel.textColor=[UIColor whiteColor];
    self.timestampLabel.font=[UIFont boldSystemFontOfSize:10.0f];
    self.timestampLabel.layer.backgroundColor=[UIColor colorWithHexString:@"D1D1D1"].CGColor;
    
    self.timestampLabel.layer.cornerRadius=4;
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView bringSubviewToFront:self.timestampLabel];
    
//    UILabel *l=[[UILabel alloc]initWithFrame:CGRectMake(0.0f,0.0f, self.bounds.size.width,1.0f)];
//    l.backgroundColor=[UIColor redColor];
//    [self.contentView addSubview:l];
}

- (void)configureNameLabelWithOffsetY:(CGFloat)offsetY
{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,
                                                               offsetY,
                                                               self.bounds.size.width - 20,
                                                               NAME_LABEL_HEIGHT)];
    self.nameLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = [UIColor messagesNameColor];
    self.nameLabel.shadowColor = [UIColor whiteColor];
    self.nameLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.nameLabel.font = [UIFont boldSystemFontOfSize:11.5f];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView bringSubviewToFront:self.nameLabel];
    
}

- (void)configureWithType:(JSBubbleMessageType)type
              bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
              avatarStyle:(JSAvatarStyle)avatarStyle
                mediaType:(JSBubbleMediaType)mediaType
                timestamp:(BOOL)hasTimestamp
                  hasName:(BOOL)hasName
{
    CGFloat bubbleY = 0.0f;
    CGFloat bubbleX = 0.0f;

//    float tf=0.0f;
//    float tn=0.0f;
    if(hasTimestamp) {
        topMarigin= 17.0f;
//        if (self.tag !=0) {
//            topMarigin = 34.0f;
//        }
        NSLog(@"self.tag-indexrow:%i",self.tag);
        [self configureTimestampLabel];
        bubbleY+= topMarigin +20.0f+13.0f;
//        tf=self.timestampLabel.frame.size.height+8.0f;
    }
    else
    {
        bubbleY+=18.0f;
//        tf=34.0f;
    }
//     tf=34.0f;
    CGFloat offsetX = 0.0f;
    
    if(avatarStyle != JSAvatarStyleNone) {
        offsetX = 1.0f;
        bubbleX = kJSAvatarSize;
        CGFloat avatarX = 8.0f;
        
        if(type == JSBubbleMessageTypeOutgoing) {
            avatarX = (self.contentView.frame.size.width - kJSAvatarSize);
            offsetX = kJSAvatarSize - 1.0f;
        }
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(avatarX,
                                                                             bubbleY,
                                                                             kJSAvatarSize_Width,
                                                                             kJSAvatarSize_Height)];
        self.avatarImageView.backgroundColor=[UIColor whiteColor];
        self.avatarImageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin
                                                 | UIViewAutoresizingFlexibleRightMargin);
        self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame)/2;
        self.avatarImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
    }
    
    
    if (hasName) {
        [self configureNameLabelWithOffsetY:bubbleY];
        if(type == JSBubbleMessageTypeOutgoing) {
            self.nameLabel.textAlignment = NSTextAlignmentRight;
        }
        bubbleY += NAME_LABEL_HEIGHT;
//        tn=NAME_LABEL_HEIGHT;
    }
    else
    {
//        tn=0.0f;
    }
    
   
    
    
    CGRect frame = CGRectMake(bubbleX - offsetX,
                              bubbleY,
                              self.contentView.frame.size.width - bubbleX,
                              self.contentView.frame.size.height -bubbleY);
    self.bubbleView = [[JSBubbleView alloc] initWithFrame:frame
                                               bubbleType:type
                                              bubbleStyle:bubbleStyle
                                                mediaType:mediaType];
    [self.contentView addSubview:self.bubbleView];
    [self.contentView sendSubviewToBack:self.bubbleView];
}

#pragma mark - Initialization
- (id)initWithBubbleType:(JSBubbleMessageType)type
             bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
             avatarStyle:(JSAvatarStyle)avatarStyle
               mediaType:(JSBubbleMediaType)mediaType
            hasTimestamp:(BOOL)hasTimestamp
                 hasName:(BOOL)hasName
         reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
        self.avatarImageStyle = avatarStyle;
        [self configureWithType:type
                    bubbleStyle:bubbleStyle
                    avatarStyle:avatarStyle
                      mediaType:mediaType
                      timestamp:hasTimestamp
                        hasName:hasName];
    }
    return self;
}

- (void)dealloc
{
    self.bubbleView = nil;
    self.timestampLabel = nil;
    self.avatarImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters
- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    [self.contentView setBackgroundColor:color];
    [self.bubbleView setBackgroundColor:color];
}

#pragma mark - Message Cell
- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setMessage:(NSString *)msg
{
    if (!msg)
    {
        return;
    }
    self.bubbleView.text = [CDEmotionUtils convertWithText:msg toEmoji:YES];
}


- (void)setMedia:(id)data
{
    if (!data) {
        self.bubbleView.data = nil;
        return;
    }
    
	if ([data isKindOfClass:[UIImage class]])
	{
		// image
//		NSLog(@"show the image here");
        self.bubbleView.data = data;
	}
	else if ([data isKindOfClass:[NSData class]])
	{
		// show a button / icon to view details
		NSLog(@"icon view");
	}
}


- (void)setTimestamp:(NSDate *)date
{
//    self.timestampLabel.text = [NSDateFormatter localizedStringFromDate:date
//                                                              dateStyle:kCFDateFormatterMediumStyle
//                                                              timeStyle:NSDateFormatterShortStyle];
   //LA  格式化日期
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
    NSString* dateString = [fmt stringFromDate:date];
    self.timestampLabel.text=dateString;
}

- (void)setAvatarImage:(UIImage *)image
{
    UIImage *styledImg = nil;
    switch (self.avatarImageStyle) {
        case JSAvatarStyleCircle:
            styledImg = [image circleImageWithSize:kJSAvatarSize-8];
            break;
            
        case JSAvatarStyleSquare:
            styledImg = [image squareImageWithSize:kJSAvatarSize-8];
            break;
            
        case JSAvatarStyleNone:
        default:
            break;
    }
    self.avatarImageView.image = styledImg;
}

- (void)setAvatarImageName:(NSString *)imageName
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"img_default_me_user"]];
}

- (void)setAvatarImageTarget:(id)target action:(SEL)action
{
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *actionTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self.avatarImageView addGestureRecognizer:actionTap];
}

+ (CGFloat)neededHeightForText:(NSString *)bubbleViewText timestamp:(BOOL)hasTimestamp name:(BOOL)hasName avatar:(BOOL)hasAvatar
{
    CGFloat timestampHeight = (hasTimestamp) ? (TIMESTAMP_LABEL_HEIGHT+13.0f) : 0.0f;
    CGFloat nameHeight = (hasName) ? NAME_LABEL_HEIGHT : 0.0f;
    CGFloat avatarHeight = (hasAvatar) ? kJSAvatarSize_Height: 0.0f;

    return MAX(avatarHeight,[JSBubbleView cellHeightForText:[CDEmotionUtils convertWithText:bubbleViewText toEmoji:YES]]) + timestampHeight + nameHeight+18.0f;
}

+ (CGFloat)neededHeightForImage:(UIImage *)bubbleViewImage timestamp:(BOOL)hasTimestamp name:(BOOL)hasName avatar:(BOOL)hasAvatar{
    CGFloat timestampHeight = (hasTimestamp) ? (TIMESTAMP_LABEL_HEIGHT) : 0.0f;
    CGFloat nameHeight = (hasName) ? NAME_LABEL_HEIGHT : 0.0f;
    CGFloat avatarHeight = (hasAvatar) ? kJSAvatarSize : 0.0f;
    return MAX(avatarHeight, [JSBubbleView cellHeightForImage:bubbleViewImage]) + timestampHeight + nameHeight;
}

#pragma mark - Copying
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(self.bubbleView.data){
        if(action == @selector(saveImage:))
            return YES;
    }else{
        if(action == @selector(copy:))
            return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.bubbleView.text];
    [self resignFirstResponder];
}

#pragma mark - Touch events
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(![self isFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    [menu update];
    [self resignFirstResponder];
}

#pragma mark - Gestures
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan
       || ![self becomeFirstResponder])
        return;
    
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *saveItem;
    if(self.bubbleView.data){
        saveItem = [[UIMenuItem alloc] initWithTitle:@"Save" action:@selector(saveImage:)];
    }else{
        saveItem = nil;
    }
    
    [menu setMenuItems:[NSArray arrayWithObjects:saveItem, nil]];
    
    CGRect targetRect = [self convertRect:[self.bubbleView bubbleFrame]
                                 fromView:self.bubbleView];
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
    
    [menu update];
}

#pragma mark - Save Image
-(void)saveImage:(id)sender{
    
    
    
    
    UIImageWriteToSavedPhotosAlbum(self.bubbleView.data, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    UIAlertView *alertView;
    
    if (error != NULL){
        alertView = [[UIAlertView alloc] initWithTitle:@"Save Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
    }else{ 
        alertView = [[UIAlertView alloc] initWithTitle:@"Save Success" message:@"Image has Saved !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    [alertView show];
}




#pragma mark - Notification
- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    self.bubbleView.selectedToShowCopyMenu = NO;
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    self.bubbleView.selectedToShowCopyMenu = YES;
}


@end