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
#import "DZChatTools.h"


#define SetButtonImages(btn ,normal, hl) \
[btn setImage:LoadPodImage(normal) forState:UIControlStateNormal]; \
[btn setImage:LoadPodImage(hl) forState:UIControlStateHighlighted]; \
[btn setImage:LoadPodImage(hl) forState:UIControlStateSelected];


CGFloat const kSTMinHeight = 44;
CGSize const kButtonSize = {35, 35};
CGFloat const kActionHeight = 271;

@interface DZInputToolbar () <UITextViewDelegate,  K12AudioRecorderDelegate>
{
    DZVoiceInputView* _voiceInputView;
    CFTimeInterval _recordBeginTime;
    DZInputMiddleView* _inputMiddleView;
}

@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, assign) BOOL showingBottomFunctions;
@property (nonatomic, assign) BOOL showEmoji;
@property (nonatomic, assign) BOOL showText;
@property (nonatomic, assign) BOOL showAudio;
@property (nonatomic, assign) BOOL showActions;
@end


@implementation DZInputToolbar

- (instancetype) initShowType:(int)type
{
    self = [self init];
    if (!self) {
        return self;
    }
    _showEmoji = type &  DZInputToolbarShowTypeEmoji;
    _showText = type & DZInputToolbarShowTypeText;
    _showAudio = type & DZInputToolbarShowTypeAudio;
    _showActions = type & DZInputToolbarShowTypeActions;
    return self;
}
- (void) audioButtonShowNormal:(BOOL)normal
{
    if (normal) {
        SetButtonImages(_audioButton, voice_button, voice_button_click);
        [self changeToTextInput];
    } else {
        SetButtonImages(_audioButton, keyboard_button, keyboard_button_click);
        [self changeToVoiceInput];
    }
}

- (void) emojiButtonShowNormal:(BOOL)normal
{
    if (normal) {
         SetButtonImages(_emojiButton, emoji_button, emoji_button_click);
    } else {
         SetButtonImages(_emojiButton, keyboard_button, keyboard_button_click);
    }
}

- (void) actionButtonShowNormal:(BOOL)normal
{
    if (normal) {
           SetButtonImages(_actionButton, action_button, action_button_click);
    } else {
           SetButtonImages(_actionButton, keyboard_button, keyboard_button_click);
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
    
    [self emojiButtonShowNormal:YES];
    [self actionButtonShowNormal:YES];
    [self audioButtonShowNormal:YES];
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
    
    CGSize emojiBtnSize = {0,0};
    if (_showEmoji) {
        emojiBtnSize = kButtonSize;
    }
    
    CGSize audioBtnSize = {0,0};
    if (_showAudio) {
        audioBtnSize = kButtonSize;
    }
    
    CGSize actionBtnSize = {0,0};
    if (_showActions) {
        actionBtnSize = kButtonSize;
    }
    

    CGFloat space = 2;
    CGRect contentRect = self.bounds;
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(10, 10));
    CGRect voiceRect;
    CGRect textRect;
    CGRect emojiRect;
    CGRect actionRect;
    CGFloat inputHeight = _inputMiddleView.aimHeight;

    CGRect inputsRect = contentRect;
    CGRectDivide(inputsRect, &voiceRect, &inputsRect, audioBtnSize.width, CGRectMinXEdge);
    voiceRect = CGRectCenter(voiceRect, audioBtnSize);
    
    
    inputsRect = CGRectShrink(inputsRect, space, CGRectMinXEdge);
    CGRectDivide(inputsRect, &actionRect, &inputsRect, actionBtnSize.width, CGRectMaxXEdge);
    inputsRect = CGRectShrink(inputsRect, space, CGRectMaxXEdge);
    
    CGRectDivide(inputsRect, &emojiRect, &inputsRect, emojiBtnSize.width, CGRectMaxXEdge);
    inputsRect = CGRectShrink(inputsRect, space, CGRectMaxXEdge);

    emojiRect = CGRectCenter(emojiRect, emojiBtnSize);
    actionRect = CGRectCenter(actionRect, actionBtnSize);
    
    
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
