//
//  JSMessageInputView.m
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

#import "JSMessageInputBar.h"
#import "JSBubbleView.h"
#import "NSString+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"
#import "UIColor+JSMessagesView.h"
#import "UIColor+Extensions.h"
#import "JSMessagesViewController.h"

#define SEND_BUTTON_WIDTH 78.0f


typedef NS_ENUM(NSInteger, XHMessageInputViewStyle) {
    // 分两种,一种是iOS6样式的，一种是iOS7样式的
    XHMessageInputViewStyleQuasiphysical,
    XHMessageInputViewStyleFlat
};

static id<UITextViewDelegate, UITextFieldDelegate, JSMessageInputViewDelegate> __delegate;

@interface JSMessageInputBar ()

- (void)setup;
- (void)setupTextInputView;

@end



@implementation JSMessageInputBar

@synthesize sendButton;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame delegate:(id<UITextViewDelegate, UITextFieldDelegate, JSDismissiveTextViewDelegate , JSMessageInputViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self) {
        __delegate = delegate;
        self.delegate = delegate;
        [self setup];
        self.allowsSendFace = YES;
        self.allowsSendMultiMedia = YES;
        if(self.textView)
        {
            self.textView.layer.borderColor=[UIColor colorWithHexString:@"CBCBCB"].CGColor;
            self.textView.layer.cornerRadius=2;
            //    CGRect txtFrame=CGRectMake(10, (INPUT_HEIGHT-29.0f)/2, size.width-28-50-10, 29.0f);
            //    self.textView.frame=txtFrame;

            // TODO: refactor
            //        self.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
            self.textView.keyboardDelegate = delegate;
            self.textView.placeHolder = @"输入文字....";

        }
    }
    return self;
}

+ (JSInputBarStyle)inputBarStyle
{
    if ([__delegate respondsToSelector:@selector(inputBarStyle)])
        return [__delegate inputBarStyle];
    
    return JSInputBarStyleDefault;
}
+ (PYInputViewStyle)inputViewStyle
{
    if ([__delegate respondsToSelector:@selector(inputViewStyle)])
        return [__delegate inputViewStyle];

    return PYInputViewStyleDefault;
}

- (void)dealloc
{
    self.textView = nil;
    self.sendButton = nil;
}

- (BOOL)resignFirstResponder
{
    if (self.textView)
    {
        [self.textView resignFirstResponder];
    }

    if (self.textField)
    {
        [self.textField resignFirstResponder];
    }
    return [super resignFirstResponder];
}

- (void)setupMessageInputViewBarWithStyle:(XHMessageInputViewStyle)style {
    // 配置输入工具条的样式和布局

    // 需要显示按钮的总宽度，包括间隔在内
    CGFloat allButtonWidth = 0.0;

    // 水平间隔
    CGFloat horizontalPadding = 8;

    // 垂直间隔
    CGFloat verticalPadding = 4;

    // 输入框
    CGFloat textViewLeftMargin = ((style == XHMessageInputViewStyleFlat) ? 6.0 : 4.0);

    // 每个按钮统一使用的frame变量
    CGRect buttonFrame;

    // 按钮对象消息
    UIButton *button;
    
    if (self.allowsSendMultiMedia) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"chat_add_normal"] HLImage:[UIImage imageNamed:@"chat_add_pressed"]];
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2;
        buttonFrame = button.frame;
        buttonFrame.origin=CGPointMake(horizontalPadding, verticalPadding);
        allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 1.5;
        button.frame = buttonFrame;
        [self addSubview:button];
        textViewLeftMargin+=CGRectGetWidth(buttonFrame);
    }
    
    // 允许发送表情
    if (self.allowsSendFace) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"face"] HLImage:[UIImage imageNamed:@"face_HL"]];
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        buttonFrame = button.frame;
        buttonFrame.origin=CGPointMake(horizontalPadding + CGRectGetWidth(buttonFrame), verticalPadding);
        allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 1.5;
        button.frame = buttonFrame;
        [self addSubview:button];
        textViewLeftMargin+=CGRectGetWidth(buttonFrame);
        
        self.faceSendButton = button;
    }
    
    
    PYInputViewStyle inputViewStyle = [JSMessageInputBar inputViewStyle];

    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));
    CGFloat height = [JSMessageInputBar textViewLineHeight];
    textViewLeftMargin += 5.0f;
    switch (inputViewStyle) {
        case PYInputViewStyleTextView:
            {
                width -= 72.0f;
                // 初始化输入框
                JSMessageTextView *textView = [[JSMessageTextView  alloc] initWithFrame:CGRectZero];

                // 这个是仿微信的一个细节体验
                //    textView.returnKeyType = UIReturnKeySend;
                textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用

                textView.placeHolder = @"发送新消息";
                textView.delegate = __delegate;

                [self addSubview:textView];
                _textView = textView;

                // 配置不同iOS SDK版本的样式
                switch (style) {
                    case XHMessageInputViewStyleQuasiphysical: {
                        _textView.frame = CGRectMake(textViewLeftMargin, 3.0f, width, height);
                        _textView.backgroundColor = [UIColor whiteColor];

                        self.image = [[UIImage imageNamed:@"input-bar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)
                                                                                                  resizingMode:UIImageResizingModeStretch];

                        UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(_textView.frame.origin.x - 1.0f,
                                                                                                    0.0f,
                                                                                                    _textView.frame.size.width + 2.0f,
                                                                                                    self.frame.size.height)];
                        inputFieldBack.image = [[UIImage imageNamed:@"input-field-cover"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f)];
                        inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
                        inputFieldBack.backgroundColor = [UIColor clearColor];
                        [self addSubview:inputFieldBack];
                        break;
                    }
                    case XHMessageInputViewStyleFlat: {
                        _textView.frame = CGRectMake(textViewLeftMargin, 4.5f, width, height);
                        _textView.backgroundColor = [UIColor clearColor];
                        _textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
                        _textView.layer.borderWidth = 0.65f;
                        _textView.layer.cornerRadius = 6.0f;
                        self.backgroundColor = [UIColor whiteColor];
                        self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)
                                                                                            resizingMode:UIImageResizingModeTile];
                        break;
                    }
                    default:
                        break;
                }
                sendButton = [self sendButton];
                sendButton.enabled = NO;
                sendButton.frame = CGRectMake(self.frame.size.width -70.0f,(self.frame.size.height-35.0f)/2, 62.0f, 35.0f);

                sendButton.layer.cornerRadius=2;
                sendButton.layer.borderWidth=1.0f;
                sendButton.layer.borderColor=[UIColor colorWithHexString:@"CBCBCB"].CGColor;
                sendButton.tintColor=[UIColor colorWithHexString:@"09bb07"];
                [sendButton addTarget:_delegate
                               action:@selector(sendPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
                [self setSendButton:sendButton];
            }
            break;
        default:
            {
                width -= 16.0f;
                UITextField* textField = [[UITextField alloc] initWithFrame:CGRectZero];
                textField.returnKeyType = UIReturnKeySend;
                textField.placeholder = @"发送新消息";
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.delegate = __delegate;
                [self addSubview:textField];
                _textField = textField;
                //XHMessageInputViewStyleFlat
                _textField.frame = CGRectMake(textViewLeftMargin, 4.0f, width, height);
//                _textField.backgroundColor = [UIColor clearColor];
//                _textField.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
//                _textField.layer.borderWidth = 0.65f;
//                _textField.layer.cornerRadius = 6.0f;
//                self.backgroundColor = [UIColor whiteColor];
//                self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)
//                                                                                    resizingMode:UIImageResizingModeTile];
            }
            break;
    }
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (UIButton *)createButtonWithImage:(UIImage *)image HLImage:(UIImage *)hlImage {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [JSMessageInputBar textViewLineHeight], [JSMessageInputBar textViewLineHeight])];
    if (image)
        [button setBackgroundImage:image forState:UIControlStateNormal];
    if (hlImage)
        [button setBackgroundImage:hlImage forState:UIControlStateHighlighted];

    return button;
}

- (void)messageStyleButtonClicked:(UIButton *)sender {
    NSInteger index = sender.tag;
    switch (index) {
        case 0:
        {
//            sender.selected = !sender.selected;
//            if (sender.selected) {
//                self.inputedText = self.textView.text;
//                self.textView.text = @"";
//                [self.textView resignFirstResponder];
//            } else {
//                self.textView.text = self.inputedText;
//                self.inputedText = nil;
//                [self.textView becomeFirstResponder];
//            }
//
//            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                self.holdDownButton.alpha = sender.selected;
//                self.textView.alpha = !sender.selected;
//            } completion:^(BOOL finished) {
//
//            }];
//
//            if ([self.delegate respondsToSelector:@selector(didChangeSendVoiceAction:)]) {
//                [self.delegate didChangeSendVoiceAction:sender.selected];
//            }
//            break;
        }
        case 1:
        {
            sender.selected = !sender.selected;
//            self.voiceChangeButton.selected = !sender.selected;

            if (!sender.selected)
            {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.holdDownButton.alpha = sender.selected;
                    self.textView.alpha = !sender.selected;
                } completion:^(BOOL finished) {
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.holdDownButton.alpha = !sender.selected;
                    self.textView.alpha = sender.selected;
                } completion:^(BOOL finished) {
                }];
            }

            if ([self.delegate respondsToSelector:@selector(didSendFaceAction:)])
            {
                [self.delegate didSendFaceAction:sender.selected];
            }
            break;
        }
        case 2:
        {
            self.faceSendButton.selected = NO;
            if ([__delegate respondsToSelector:@selector(didSelectedMultipleMediaAction)]) {
                [__delegate didSelectedMultipleMediaAction];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Setup
- (void)setup
{
    self.image = [UIImage inputBar];
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    _allowsSendFace = YES;
    _allowsSendMultiMedia = YES;

    [self setupTextInputView];
}

- (void)setupTextInputView
{
    [self setupMessageInputViewBarWithStyle:XHMessageInputViewStyleFlat];
}

#pragma mark - Setters
- (void)setSendButton:(UIButton *)btn
{
    if(sendButton)
        [sendButton removeFromSuperview];
    
    sendButton = btn;
    [self addSubview:self.sendButton];
}

#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.textView.frame;
    
    int numLines = MAX([self.textView numberOfLinesOfText],
                       [self.textView.text numberOfLines]);

    NSLog(@"number line == %d",numLines);
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    
    self.textView.scrollEnabled = (numLines >= 4);
    
    if(numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 2, 1)];
    }
}

+ (CGFloat)textViewLineHeight
{
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return 4.0f;
}

+ (CGFloat)maxHeight
{
    return ([JSMessageInputBar maxLines] + 1.0f) * [JSMessageInputBar textViewLineHeight];
}

@end