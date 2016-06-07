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
#import <TransitionKit/TransitionKit.h>
#import "HexColors.h"
#import "DZInputActionViewController.h"
#import "DZEmojiActionElement.h"
#import "DZAIOActionElement.h"

#define LoadPodImage(name)   [UIImage imageNamed:@"DZChatUI.bundle/"#name inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]

static NSString* const kEventText = @"intext";
static NSString* const kEventMore = @"inmore";
static NSString* const kEventAudio = @"inaudio";
static NSString* const kEventEmoji = @"inemoji";
static NSString* const kEventNone = @"innone";


#define ADDSelector(btn, sel, rmsel) \
[btn removeTarget:self action:rmsel forControlEvents:UIControlEventTouchUpInside]; \
[btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];

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
    TKStateMachine* _stateMachine;
    DZInputActionViewController* _emojiViewController;
    DZInputActionViewController* _actionViewController;
}
@property (nonatomic, strong, readonly) TKStateMachine* stateMachine;
@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, assign) BOOL showingBottomFunctions;
@end


@implementation DZInputToolbar




#pragma Doing thing when event occurs
- (void) showAudioExe
{
    ADDSelector(_audioButton, @selector(hidenAutioAction), @selector(showAudioAction));
    SetButtonImages(_audioButton, ToolViewKeyboard, ToolViewKeyboardHL);
    _voiceInputLabel.hidden = NO;
    _textView.hidden = YES;
    [self bringSubviewToFront:_voiceInputLabel];
    [self handleAdjustFrame];
}
- (void) showAudioAction
{
    [_stateMachine fireEvent:kEventAudio userInfo:nil error:nil];
}

- (void) hiddenAudioExe
{
    ADDSelector(_audioButton, @selector(showAudioAction), @selector(hidenAutioAction));
    SetButtonImages(_audioButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    _voiceInputLabel.hidden = YES;
    _textView.hidden = NO;
    [self handleAdjustFrame];
}
- (void) hidenAutioAction
{
    [_stateMachine fireEvent:kEventText userInfo:nil error:nil];
}

- (void) showMoreExe
{

    
}
- (void) showMoreAction
{
    ADDSelector(_actionButton, @selector(hidenMoreAction), @selector(showMoreAction));
    SetButtonImages(_actionButton, ToolViewKeyboard, ToolViewKeyboardHL);
    if ([self.uiDelegate respondsToSelector:@selector(inputToolbarShowActions:)]) {
        [self.uiDelegate inputToolbarShowActions:self];
    }
    [_stateMachine fireEvent:kEventMore userInfo:nil error:nil];
}

- (void) hiddenMoreExe
{
    ADDSelector(_actionButton, @selector(showMoreAction), @selector(hiddenMoreExe));
    SetButtonImages(_actionButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    if ([self.uiDelegate respondsToSelector:@selector(inputToolbarHideActions:)]) {
        [self.uiDelegate inputToolbarHideActions:self];
    }
}

- (void) hidenMoreAction
{
    [_stateMachine fireEvent:kEventText userInfo:nil error:nil];
}

- (void) showEmojiExe
{

    
}
- (void) showEmojiAction
{
    ADDSelector(_emojiButton, @selector(hidenEmojiAction), @selector(showEmojiAction));
    SetButtonImages(_emojiButton, ToolViewKeyboard, ToolViewKeyboardHL);
    if ([self.uiDelegate respondsToSelector:@selector(inputToolbarShowEmoji:)]) {
        [self.uiDelegate inputToolbarShowEmoji:self];
    }
    [_stateMachine fireEvent:kEventEmoji userInfo:nil error:nil];
    
}

- (void) hiddenEmojiExe
{
    ADDSelector(_emojiButton, @selector(showEmojiAction), @selector(hiddenEmojiExe));
    SetButtonImages(_emojiButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    if ([self.uiDelegate respondsToSelector:@selector(inputToolbarHideEmoji:)]) {
        [self.uiDelegate inputToolbarHideEmoji:self];
    }
}
- (void) hidenEmojiAction
{
    [_stateMachine fireEvent:kEventText userInfo:nil error:nil];
}

- (void) showTextActionExe
{
    [_textView becomeFirstResponder];
    self.showingBottomFunctions = YES;
}

- (void) showTextAction
{
    [_stateMachine fireEvent:kEventText userInfo:nil error:nil];
}

- (void) hiddenTextActionExe
{
    [_textView resignFirstResponder];
    self.showingBottomFunctions = NO;
}

- (void) hiddenTextAction
{
    [_stateMachine fireEvent:kEventNone userInfo:nil error:nil];
}

- (void) initMechine
{
    __weak typeof(self) wSelf = self;
    _stateMachine = [TKStateMachine new];
    TKState* inputText = [TKState stateWithName:@"text"];
    
    [inputText setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf showTextActionExe];
    }];
    
    [inputText setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf hiddenTextActionExe];
    }];
    
    TKState* inputAudio = [TKState stateWithName:@"audio"];
    [inputAudio setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf  hiddenAudioExe];
    }];
    
    [inputAudio setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf showAudioExe];
    }];
    
    
    TKState* more = [TKState stateWithName:@"more"];
    
    [more setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf hiddenMoreExe];
    }];
    [more setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf showMoreExe];
    }];
    
    
    TKState* emoji = [TKState stateWithName:@"inputing emoji"];
    
    [emoji setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf showEmojiExe];
    }];
    
    [emoji setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf hiddenEmojiExe];
    }];
    
    TKState* none = [TKState stateWithName:@"none"];
    
    [none setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf endShowAdditon];
    }];
    
    [none setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf beginShowAddition];
    }];
    
    
    TKEvent* textEvent = [TKEvent eventWithName:kEventText transitioningFromStates:@[inputAudio, more, none, emoji] toState:inputText];
    
    TKEvent* noneEvent= [TKEvent eventWithName:kEventNone transitioningFromStates:@[inputAudio, more,emoji, inputText] toState:none];
    TKEvent* emojiEvent = [TKEvent eventWithName:kEventEmoji transitioningFromStates:@[inputAudio, more, inputText, none ] toState:emoji];
    
    TKEvent* autioEvent = [TKEvent eventWithName:kEventAudio transitioningFromStates:@[inputText, more, none, emoji] toState:inputAudio];
    
    TKEvent* moreEvent = [TKEvent eventWithName:kEventMore transitioningFromStates:@[inputText, none, emoji, inputAudio] toState:more];
    
    [_stateMachine addStates:@[inputText, none, emoji, inputAudio, more]];
    [_stateMachine addEvents:@[autioEvent, noneEvent, emojiEvent, textEvent, moreEvent]];
    [_stateMachine setInitialState:none];
}



- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW_UIImageView(_backgroundImageView);
    INIT_SELF_SUBVIEW(DZGrowTextView, _textView);
    INIT_SELF_SUBVIEW(UIButton, _emojiButton);
    INIT_SUBVIEW_UIButton(self, _actionButton);
    INIT_SUBVIEW_UIButton(self, _audioButton);
    INIT_SELF_SUBVIEW_UILabel(_voiceInputLabel);
    _voiceInputLabel.text = @"按住 说话";
    _voiceInputLabel.textAlignment = NSTextAlignmentCenter;
    _textView.delegate = self;
    self.adjustHeight = kSTMinHeight;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.layer.cornerRadius = 4;
    _textView.delegate = self;
    //
    _textView.enablesReturnKeyAutomatically = YES;
    _textView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor lightTextColor];
    
    SetButtonImages(_audioButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    [_audioButton addTarget:self action:@selector(showAudioAction) forControlEvents:UIControlEventTouchUpInside];
    SetButtonImages(_actionButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    [_actionButton addTarget:self action:@selector(showMoreAction) forControlEvents:UIControlEventTouchUpInside];
    SetButtonImages(_emojiButton, ToolViewInputVoice, ToolViewInputVoiceHL);
    [_emojiButton addTarget:self action:@selector(showEmojiAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self initMechine];
    //
    _backgroundImageView.image = [LoadPodImage(InputToolBar) imageWithAlignmentRectInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    //
    _textView.layer.borderColor = [UIColor hx_colorWithHexString:@"c3c3c4"].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    
    self.backgroundColor = [UIColor whiteColor];
    _showingBottomFunctions = NO;
    return self;
}

- (void) handleAdjustFrame
{
    CGFloat height = MAX(self.textView.adjustHeight, 44) + 10;
    self.adjustHeight = height;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _backgroundImageView.frame=self.bounds;
    CGFloat space = 10;
    CGRect contentRect = self.bounds;
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(10, 10));
    CGRect keyboardRect;
    CGRect textRect;
    CGRect emojiRect;
    CGRect actionRect;
    CGFloat inputHeight = MAX(self.textView.adjustHeight, 44) + 10;

    
    CGRect inputsRect;
    CGRectDivide(contentRect, &inputsRect, &contentRect, inputHeight, CGRectMinYEdge);
    CGRectDivide(inputsRect, &keyboardRect, &inputsRect, kButtonSize.width, CGRectMinXEdge);
    keyboardRect = CGRectCenter(keyboardRect, kButtonSize);
    
    inputsRect = CGRectShrink(inputsRect, space, CGRectMinXEdge);
    CGRectDivide(inputsRect, &actionRect, &inputsRect, kButtonSize.width, CGRectMaxXEdge);
    inputsRect = CGRectShrink(inputsRect, space, CGRectMaxXEdge);
    
    CGRectDivide(inputsRect, &emojiRect, &inputsRect, kButtonSize.width, CGRectMaxXEdge);
    inputsRect = CGRectShrink(inputsRect, space, CGRectMaxXEdge);
    
    CGRect backgroundRect = inputsRect;
    backgroundRect.origin.x = 0;
    backgroundRect.origin.y = 0;
    backgroundRect.size.height = CGRectGetHeight(inputsRect);
    backgroundRect.size.width = CGRectGetWidth(self.bounds);
    emojiRect = CGRectCenter(emojiRect, kButtonSize);
    actionRect = CGRectCenter(actionRect, kButtonSize);
    
    _emojiButton.frame  = emojiRect;
    _actionButton.frame = actionRect;
    _audioButton.frame = keyboardRect;
    
    if ([_stateMachine.currentState.name isEqualToString:@"audio"]) {
        _voiceInputLabel.frame = inputsRect;
        [self bringSubviewToFront:_voiceInputLabel];
    } else {
        _textView.frame = inputsRect;
        [self bringSubviewToFront:_textView];
    }
}

- (BOOL) resignFirstResponder
{
    [_textView resignFirstResponder];
    return [super resignFirstResponder];
}

- (void) textViewDidChange:(UITextView *)textView
{
    [_textView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    CGSize size = [_textView sizeThatFits:textView.frame.size];
    self.adjustHeight = size.height + 20;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    textView.returnKeyType = UIReturnKeyDone;
    if ([text isEqualToString:@"\n"]) {
        [self sendText];
        return NO;
    }
    return YES;
}

- (void) sendText
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(inputToolbar:sendText:)]) {
            [self.delegate inputToolbar:self sendText:_textView.text];
        }
        _textView.text = nil;
    });
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    textView.returnKeyType = UIReturnKeySend;
    [self showTextAction];
    return YES;
}


- (void) beginShowAddition
{
}

- (void) endShowAdditon
{
}

- (void) endInputing
{
    [_stateMachine fireEvent:kEventNone userInfo:nil error:nil];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self startRecord];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(_voiceInputLabel.frame, point)) {
        _voiceInputView.contentView.textLabel.text = @"手指上划，取消录音";
    } else {
        _voiceInputView.contentView.textLabel.text = @"松开手指，取消录音";
    }
}
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self stopRecord];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self stopRecord];
}

- (void) startRecord
{
    if (!_voiceInputView) {
        _voiceInputView = [DZVoiceInputView new];
    }
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_voiceInputView];
    _voiceInputView.frame = window.bounds;
    _voiceInputView.contentView.textLabel.text = @"手指上划，取消录音";
    //
    if (!_audioRecorder) {
        _audioRecorder = [[K12AudioRecorder alloc] init];
    }
    _audioRecorder.delegate = self;
    NSError* error;
    [_audioRecorder record:&error];
    _recordBeginTime = CFAbsoluteTimeGetCurrent();
}

- (void) stopRecord
{
    [_audioRecorder stop];
    [_voiceInputView removeFromSuperview];
}

- (void) k12AudioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}

- (void) k12AudioRecorder:(AVAudioRecorder *)recorder recordingWithMeters:(double)meters
{
    CFTimeInterval current= CFAbsoluteTimeGetCurrent();
    if (current - _recordBeginTime > 30) {
        [self stopRecord];
    }
}

- (void) k12AudioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (flag) {
        if ([self.delegate respondsToSelector:@selector(inputToolbar:sendVoice:)]) {
            [self.delegate inputToolbar:self sendVoice:recorder];
        }
    }
}
@end
