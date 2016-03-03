//
//  JSMessagesViewController.m
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

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"
#import "UIColor+Extensions.h"
#import "XHEmotionManagerView.h"
#import "CDEmotion.h"
#import "CDEmotionUtils.h"
#import "UITextField+ExtentRange.h"
#import "SVProgressHUD.h"

#define OSVersionIsAtLeastiOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define INPUT_HEIGHT 46.0f
#define TABLE_INPUT_DIS 3

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate,XHEmotionManagerViewDelegate,XHEmotionManagerViewDataSource,XHShareMenuViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)setup;

@end

@implementation JSMessagesViewController

- (void)loadView
{
    [super loadView];
    [self fixFrame];
}

- (void)fixFrame
{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (OSVersionIsAtLeastiOS7 == YES) {
//        float v = NSFoundationVersionNumber;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }else{
        frame.size.height -= 20 + 44;
    }
    
    self.view.frame = frame;
    self.view.bounds = frame;
}


#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    self.keyboardViewHeight = (kIsiPad ? 264 : 216);
    
    CGSize size = self.view.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f, 0.0f, size.width, size.height - INPUT_HEIGHT);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self; 
	[self.view addSubview:self.tableView];
	
	UIButton* mediaButton = nil;
	if (kAllowsMedia)
	{
		// set up the image and button frame
		UIImage* image = [UIImage imageNamed:@"PhotoIcon"];
		CGRect frame = CGRectMake(4, 0, image.size.width, image.size.height);
		CGFloat yHeight = (INPUT_HEIGHT - frame.size.height) / 2.0f;
		frame.origin.y = yHeight;
		
		// make the button
		mediaButton = [[UIButton alloc] initWithFrame:frame];
		[mediaButton setBackgroundImage:image forState:UIControlStateNormal];
		
		// button action
		[mediaButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputBar alloc] initWithFrame:inputFrame delegate:self];

    [self.view addSubview:self.inputToolBarView];
    
    

	if (kAllowsMedia)
	{
		// adjust the size of the send button to balance out more with the camera button on the other side.
		CGRect frame = self.inputToolBarView.sendButton.frame;
		frame.size.width -= 16;
		frame.origin.x += 16;
		self.inputToolBarView.sendButton.frame = frame;
		
		// add the camera button
		[self.inputToolBarView addSubview:mediaButton];
        
		// move the tet view over
		frame = self.inputToolBarView.textView.frame;
		frame.origin.x += mediaButton.frame.size.width + mediaButton.frame.origin.x;
		frame.size.width -= mediaButton.frame.size.width + mediaButton.frame.origin.x;
		frame.size.width += 16;		// from the send button adjustment above

		self.inputToolBarView.textView.frame = frame;
	}
    
    
    self.selectedMarks = [NSMutableArray new];
    
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
}

- (XHShareMenuView*)shareMenuView
{
    if(!_shareMenuView)
    {
        XHShareMenuView* shareMenuView = [[XHShareMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
        shareMenuView.delegate = self;
        XHShareMenuItem* item1 = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"chat_add_camera_normal"] title:@"拍照"];
        XHShareMenuItem* item2 = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"chat_add_picture_normal"] title:@"相册"];
        shareMenuView.shareMenuItems = @[item1,item2];
        shareMenuView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        shareMenuView.alpha = 0.0;
        [self.view addSubview:shareMenuView];
        _shareMenuView = shareMenuView;
    }
    
    [self.view bringSubviewToFront:_emotionManagerView];
    return _shareMenuView;
}
- (XHEmotionManagerView *)emotionManagerView {
    if (!_emotionManagerView) {
        XHEmotionManagerView *emotionManagerView = [[XHEmotionManagerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
        emotionManagerView.delegate = self;
        emotionManagerView.dataSource = self;
        emotionManagerView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        emotionManagerView.alpha = 0.0;
        [self.view addSubview:emotionManagerView];
        _emotionManagerView = emotionManagerView;
    }
    [self.view bringSubviewToFront:_emotionManagerView];
    return _emotionManagerView;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self layoutOtherMenuViewHiden:YES];
    [self scrollToBottomAnimated:NO];
    
    
    _originalTableViewContentInset = self.tableView.contentInset;
    
    // KVO 检查contentSize
//    [self.inputToolBarView.textView addObserver:self
//                                          forKeyPath:@"contentSize"
//                                             options:NSKeyValueObservingOptionNew
//                                             context:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self layoutOtherMenuViewHiden:YES];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.inputToolBarView = nil;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.textViewInputViewType != XHInputViewTypeNormal) {
        [self layoutOtherMenuViewHiden:YES];
        self.textViewInputViewType = XHInputViewTypeNormal;
    }
}

- (void)didSelectedMultipleMediaAction {
    DLog(@"didSelectedMultipleMediaAction");
    self.textViewInputViewType = XHInputViewTypeShareMenu;
    [self layoutOtherMenuViewHiden:NO];
}

- (void)didSendFaceAction:(BOOL)sendFace {
    if (sendFace) {
        self.textViewInputViewType = XHInputViewTypeEmotion;
        [self layoutOtherMenuViewHiden:NO];
    } else {
        [self.inputToolBarView resignFirstResponder];
    }
}

- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    [self.inputToolBarView resignFirstResponder];

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = self.inputToolBarView.frame;
        __block CGRect otherMenuViewFrame;

        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            inputViewFrame.origin.y = (hide ? (CGRectGetHeight(self.view.frame) - CGRectGetHeight(inputViewFrame)) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(inputViewFrame) - CGRectGetHeight(otherMenuViewFrame)));
            self.inputToolBarView.frame = inputViewFrame;
        };

        void (^EmotionManagerViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.emotionManagerView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.emotionManagerView.alpha = !hide;
            self.emotionManagerView.frame = otherMenuViewFrame;
        };

        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.shareMenuView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.shareMenuView.alpha = !hide;
            self.shareMenuView.frame = otherMenuViewFrame;
        };

        if (hide) {
            switch (self.textViewInputViewType) {
                case XHInputViewTypeEmotion: {
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeShareMenu: {
                    ShareMenuViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeText: {
                    EmotionManagerViewAnimation(hide);
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        } else {
            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
            switch (self.textViewInputViewType) {
                case XHInputViewTypeEmotion: {
                    // 1、先隐藏和自己无关的View
                    ShareMenuViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeShareMenu: {
                    // 1、先隐藏和自己无关的View
                    EmotionManagerViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    // 1、先隐藏和自己无关的View
                    EmotionManagerViewAnimation(!hide);
                    ShareMenuViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    break;
            }
        }
        InputViewAnimation(hide);
        [self setTableViewInsetsWithBottomValue:CGRectGetHeight(self.tableView.frame) - self.inputToolBarView.frame.origin.y];
        [self scrollToBottomAnimated:YES];
    } completion:^(BOOL finished) {

    }];
}

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.scrollIndicatorInsets = insets;
    insets.bottom += TABLE_INPUT_DIS;
    self.tableView.contentInset = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;

    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = 0;
    }
    insets.bottom = bottom;
    return insets;
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Initialization
- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
    UIView* view;
    NSString *content;

    PYInputViewStyle style = [JSMessageInputBar inputViewStyle];
    switch (style) {
        case PYInputViewStyleTextView:
            view = self.inputToolBarView.textView;
            content = [self.inputToolBarView.textView.text trimWhitespace];
            break;
        default:
            view = self.inputToolBarView.textField;
            content = [self.inputToolBarView.textField.text trimWhitespace];
            break;
    }

    [view resignFirstResponder];

    if ([content isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"多少写点嘛！"];
        return;
    }
    [self.delegate sendPressed:sender withText:content];
}


- (void)cameraAction:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cameraPressed:)]){
        [self.delegate cameraPressed:sender];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSBubbleMediaType mediaType = [self.delegate messageMediaTypeForRowAtIndexPath:indexPath];
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasName = [self shouldHaveNameForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasName, hasAvatar,mediaType];
    JSBubbleMessageCell *cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(!cell)
    {
        cell = [JSBubbleMessageCell alloc];
        cell.tag=indexPath.row;
        
        cell=[cell initWithBubbleType:type
    bubbleStyle:bubbleStyle
    avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone
    mediaType:mediaType
    hasTimestamp:hasTimestamp
    hasName:hasName
                  reuseIdentifier:CellID];
    }
    
    
    if(hasTimestamp)
        [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
    if(hasName)
        [cell setName:[self.dataSource nameForRowAtIndexPath:indexPath]];
    
    if(hasAvatar) {
        switch (type) {
            case JSBubbleMessageTypeIncoming:
//                [cell setAvatarImage:[self.dataSource avatarImageForIncomingMessage]];
                [cell setAvatarImageName:[self.dataSource avatarImageNameForIncomingMessage]];
                [cell setAvatarImageTarget:self.dataSource action:[self.dataSource avatarImageForIncomingMessageAction]];
                break;
                
            case JSBubbleMessageTypeOutgoing:
//                [cell setAvatarImage:[self.dataSource avatarImageForOutgoingMessage]];
                [cell setAvatarImageName:[self.dataSource avatarImageNameForOutgoingMessage]];
                [cell setAvatarImageTarget:self.dataSource action:[self.dataSource avatarImageForOutgoingMessageAction]];
                break;
        }
    }
    
	[cell setMedia:nil];
    [cell setMessage:@""];
    
    switch (mediaType) {
        case JSBubbleMediaTypeImage:
        {
            if (kAllowsMedia)
            {
                dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_async(queue, ^{
                    NSString* obejct = [self.dataSource dataForRowAtIndexPath:indexPath];
                    [cell setMedia:obejct];
                });
            }
        }
            break;
        case JSBubbleMediaTypeText:
        {
            [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
        }
            break;
    }
    [cell setBackgroundColor:tableView.backgroundColor];
    
//    cell.isSelected = [self.selectedMarks containsObject:CellID] ? YES : NO;
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
//    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
//    
//    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
//    BOOL hasName = [self shouldHaveNameForRowAtIndexPath:indexPath];
//    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
//    
//    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasName, hasAvatar];
//    
////    if ([self.selectedMarks containsObject:CellID])// Is selected?
////        [self.selectedMarks removeObject:CellID];
////    else
////        [self.selectedMarks addObject:CellID];
//    
//    //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if(![self.delegate messageMediaTypeForRowAtIndexPath:indexPath]){
        height = [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
                                                        timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                             name:[self shouldHaveNameForRowAtIndexPath:indexPath]
                                                           avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }else{
        height = [JSBubbleMessageCell neededHeightForImage:[self.dataSource dataForRowAtIndexPath:indexPath]
                                               timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                    name:[self shouldHaveNameForRowAtIndexPath:indexPath]
                                                  avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }
    return height;
}

#pragma mark - XHEmotionManagerView Delegate

- (void)didSelecteEmotion:(CDEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath {
    if (emotion.emotionPath) {
        DLog(@"select emotion : %@", emotion);

        PYInputViewStyle style = [JSMessageInputBar inputViewStyle];
        switch (style) {
            case PYInputViewStyleTextView:
                {
                    UITextView *textView=self.inputToolBarView.textView;
                    NSRange range=[textView selectedRange];
                    NSMutableString* str=[[NSMutableString alloc] initWithString:textView.text];
                    [str deleteCharactersInRange:range];
                    [str insertString:emotion.emotionPath atIndex:range.location];
                    [textView setText:[CDEmotionUtils convertWithText:str toEmoji:YES]];
                    textView.selectedRange=NSMakeRange(range.location+emotion.emotionPath.length, 0);
                    self.inputToolBarView.sendButton.enabled = YES;
                    if(emotion.emotionPath.length>0)
                        [self layoutAndAnimateMessageInputTextView:textView];
                }
                break;
            default:
                {
                    UITextField* textField = self.inputToolBarView.textField;
                    NSMutableString* str=[[NSMutableString alloc] initWithString:textField.text];
                    [str insertString:emotion.emotionPath atIndex:str.length];
                    [textField setText:[CDEmotionUtils convertWithText:str toEmoji:YES]];
                    if(emotion.emotionPath.length>0)
                        [self layoutAndAnimateMessageInputTextField:textField];
                }
                break;
        }
    }
}

-(void)didSendEmotionButton:(id)button
{
    [self sendPressed:button];
}

#pragma mark XHEmotionManagerViewDataSource
/**
 *  通过数据源获取统一管理一类表情的回调方法
 *
 *  @param column 列数
 *
 *  @return 返回统一管理表情的Model对象
 */
- (CDEmotionManager *)emotionManagerForColumn:(NSInteger)column
{
    return nil;
}

/**
 *  通过数据源获取一系列的统一管理表情的Model数组
 *
 *  @return 返回包含统一管理表情Model元素的数组
 */
- (NSArray *)emotionManagersAtManager
{
    return @[];
}

/**
 *  通过数据源获取总共有多少类gif表情
 *
 *  @return 返回总数
 */
- (NSInteger)numberOfEmotionManagers
{
    return 0;
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy]) {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}

- (BOOL)shouldHaveNameForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(hasNameForRowAtIndexPath:)])
        return [self.delegate hasNameForRowAtIndexPath:indexPath];
    return NO;
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy]) {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

- (void)finishSend
{
    PYInputViewStyle style = [JSMessageInputBar inputViewStyle];
    switch (style) {
        case PYInputViewStyleTextView:
            self.inputToolBarView.textView.text = @"";
            [self textViewDidChange:self.inputToolBarView.textView];
            break;
        default:
            self.inputToolBarView.textField.text = @"";
            break;
    }
    [self.tableView reloadData];
    [self layoutOtherMenuViewHiden:YES];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated
{
	[self.tableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = CGRectGetHeight(textField.frame)-1;
    [self scrollToBottomAnimated:YES];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    return [textField.text trimWhitespace].length > 0;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendPressed:nil];
    return YES;
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height-1;
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputBar maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];

    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        //        if(!isShrinking)
        //            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }

    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    self.inputToolBarView.faceSendButton.selected = NO;
    self.textViewInputViewType = XHInputViewTypeText;
    [self keyboardWillShowHide:notification];
    [self scrollToBottomAnimated:YES];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
//    [self keyboardWillShowHide:notification];
    if (!self.inputToolBarView.faceSendButton.selected) {
        CGRect inputViewFrame = self.inputToolBarView.frame;
        inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
        self.inputToolBarView.frame = inputViewFrame;

        [self scrollToBottomAnimated:YES];
    }
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = self.originalTableViewContentInset;
                         
                         insets.bottom = self.tableView.frame.size.height - inputViewFrameY;
                         self.tableView.scrollIndicatorInsets = insets;
                         insets.bottom += TABLE_INPUT_DIS;
                         self.tableView.contentInset = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Key-value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.inputToolBarView.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - Layout Message Input View Helper Method

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    if(!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = textView.contentSize.height-1;

    CGFloat maxHeight = [JSMessageInputBar maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.tableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)layoutAndAnimateMessageInputTextField:(UITextField *)textField {
    if(!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = textField.frame.size.height-1;

    CGFloat maxHeight = [JSMessageInputBar maxHeight];

    CGFloat contentH = [self getTextFieldContentH:textField];

    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;

    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textField.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }

    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.tableView.contentInset.bottom + changeInHeight];

                             [self scrollToBottomAnimated:NO];

                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }

                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];

        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }

    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
//                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textField.bounds.size.height);
//                           [textField setContentOffset:bottomOffset animated:YES];
//                           textField
                       });
    }
}

#pragma mark - UITextView Helper Method

- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - UITextField Helper Method

- (CGFloat)getTextFieldContentH:(UITextField *)textField {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textField sizeThatFits:textField.frame.size].height);
    } else {
        return textField.frame.size.height;
    }
}

#pragma mark - Dismissive text view delegate

- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

@end