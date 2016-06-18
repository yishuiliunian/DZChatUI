//
//  DZInputToolbar.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZInputToolbar.h"
#import "DZProgrameDefines.h"
#import "DZImageCache.h"
#import "DZGeometryTools.h"
#import "DZVoiceInputView.h"
#import <DZAudio/DZAudio.h>

#import "HexColors.h"
#import "DZInputActionViewController.h"
#import "DZEmojiActionElement.h"
#import "DZAIOActionElement.h"


#define LoadPodImage(name)   [UIImage imageNamed:@"DZChatUI.bundle/"#name inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]
#define SetButtonImages(btn ,normal, hl) \
[btn setImage:LoadPodImage(normal) forState:UIControlStateNormal]; \
[btn setImage:LoadPodImage(hl) forState:UIControlStateHighlighted];


CGFloat const kSTMinHeight = 44;
CGSize const kButtonSize = {35, 35};
CGFloat const kActionHeight = 271;

@interface DZInputToolbar () <UITextViewDelegate,  K12AudioRecorderDelegate>
{
    DZVoiceInputView* _voiceInputView;
    K12AudioRecorder* _audioRecorder;
    CFTimeInterval _recordBeginTime;
    DZInputMiddleView* _inputMiddleView;
}

@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, assign) BOOL showingBottomFunctions;
@end


@implementation DZInputToolbar


- (void) audioButtonShowNormal:(BOOL)normal
{
    if (normal) {
        SetButtonImages(_audioButton, ToolViewInputVoice, ToolViewInputVoiceHL);
        [self changeToTextInput];
    } else {
        SetButtonImages(_audioButton, ToolViewKeyboard, ToolViewKeyboardHL);
        [self changeToVoiceInput];
    }
}

- (void) emojiButtonShowNormal:(BOOL)normal
{
    if (normal) {
         SetButtonImages(_emojiButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    } else {
         SetButtonImages(_emojiButton, ToolViewKeyboard, ToolViewKeyboardHL);
    }
}

- (void) actionButtonShowNormal:(BOOL)normal
{
    if (normal) {
           SetButtonImages(_actionButton, ToolViewInputVoice, ToolViewInputVoiceHL); 
    } else {
           SetButtonImages(_actionButton, ToolViewKeyboard, ToolViewKeyboardHL); 
    }
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW_UIImageView(_backgroundImageView);
    INIT_SUBVIEW(self, DZTextInputView, _textInputView);
    INIT_SUBVIEW(self, DZVoiceInputView, _voiceInputView);
    INIT_SELF_SUBVIEW(UIButton, _emojiButton);
    INIT_SUBVIEW_UIButton(self, _actionButton);
    INIT_SUBVIEW_UIButton(self, _audioButton);
    self.adjustHeight = kSTMinHeight;
    self.backgroundColor = [UIColor lightTextColor];
    
    SetButtonImages(_audioButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    SetButtonImages(_actionButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    SetButtonImages(_emojiButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    //
    _backgroundImageView.image = [LoadPodImage(InputToolBar) imageWithAlignmentRectInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    //
    
    self.backgroundColor = [UIColor whiteColor];
    [self changeToTextInput];
    return self;
}

- (void) changeToTextInput
{
    _inputMiddleView = _textInputView;
    _textInputView.hidden = NO;
    _voiceInputView.hidden = YES;
    [self layoutSubviews];
}

- (void) changeToVoiceInput
{
    _inputMiddleView = _voiceInputView;
    _textInputView.hidden = YES;
    _voiceInputView.hidden = NO;
    [self layoutSubviews];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _backgroundImageView.frame=self.bounds;
    

    CGFloat space = 10;
    CGRect contentRect = self.bounds;
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(10, 10));
    CGRect voiceRect;
    CGRect textRect;
    CGRect emojiRect;
    CGRect actionRect;
    CGFloat inputHeight = _inputMiddleView.aimHeight;

    
    CGRect inputsRect = contentRect;
    CGRectDivide(inputsRect, &voiceRect, &inputsRect, kButtonSize.width, CGRectMinXEdge);
    voiceRect = CGRectCenter(voiceRect, kButtonSize);
    
    
    inputsRect = CGRectShrink(inputsRect, space, CGRectMinXEdge);
    CGRectDivide(inputsRect, &actionRect, &inputsRect, kButtonSize.width, CGRectMaxXEdge);
    inputsRect = CGRectShrink(inputsRect, space, CGRectMaxXEdge);
    
    CGRectDivide(inputsRect, &emojiRect, &inputsRect, kButtonSize.width, CGRectMaxXEdge);
    inputsRect = CGRectShrink(inputsRect, space, CGRectMaxXEdge);

    emojiRect = CGRectCenter(emojiRect, kButtonSize);
    actionRect = CGRectCenter(actionRect, kButtonSize);
    
    
    CGRect(^AlignToBottom)(CGRect) = ^(CGRect rect) {
        rect.origin.y  = CGRectGetHeight(self.bounds) - 6.5- CGRectGetHeight(rect);
        return rect;
    };
    _emojiButton.frame  = AlignToBottom(emojiRect);
    _actionButton.frame = AlignToBottom(actionRect);
    _audioButton.frame = AlignToBottom(voiceRect);
    _inputMiddleView.frame = inputsRect;
}


- (CGFloat) adjustHeight
{
    return _inputMiddleView.aimHeight + 10;
}



@end
