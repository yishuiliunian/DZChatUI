//
//  DZInputViewController.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZInputViewController.h"
#import "DZEmojiItemElement.h"
#import "DZEmojiActionElement.h"
#import "EKCollectionViewController.h"
#import "DZInputToolbar.h"
#import <DZKeyboardManager/DZKeyboardManager.h>
#import "DZEmojiActionElement.h"
#import "DZInputActionViewController.h"
#import "DZEmojiItemElement.h"
#import "DZAIOActionElement.h"
#import "DZAIOImageActionElement.h"
#import <TransitionKit/TransitionKit.h>
#import <DZLogger/DZLogger.h>
#import <DZAudio/DZAudio.h>
#import "DZAlphaView.h"
#import "DZAIOImageActionElement.h"
#import "DZAIOMapActionElement.h"
#import "DZProgrameDefines.h"
#import "DZEmojiContainerViewController.h"
#import "DZInputNoticeView.h"
#import <objc/runtime.h>
#import "EKWeakContanier.h"
#import <MRLogicInjection/MRLogicInjection.h>
#import <DZGeometryTools/DZGeometryTools.h>
static CGFloat kDZAdditionHeight = 271;


static NSString* const kStateText = @"text";
static NSString* const kStateAction = @"action";
static NSString* const kStateVoice = @"voice";
static NSString* const kStateEmoji = @"emoji";
static NSString* const kStateNone = @"none";

static NSString* const kEventText = @"intext";
static NSString* const kEventMore = @"inmore";
static NSString* const kEventAudio = @"inaudio";
static NSString* const kEventEmoji = @"inemoji";
static NSString* const kEventNone = @"innone";


#define ADDSelector(btn,addsel, rmsel) \
[btn removeTarget:self action:rmsel forControlEvents:UIControlEventTouchUpInside]; \
[btn addTarget:self action:addsel forControlEvents:UIControlEventTouchUpInside];



@interface DZInputViewController () <DZKeyboardChangedProtocol, UITextViewDelegate, DZVoiceInputViewDelegate, DZInputActionElementDelegate, UIGestureRecognizerDelegate>
{
    UISwipeGestureRecognizer* _swipeDown;
    //
    UIView* _contentView;
    DZInputToolbar* _toolbar;
    
    CGFloat _toolbarHeight;
    CGFloat _actionHeight;
    //
    BOOL _isFirstLayout;
    //
    DZEmojiContainerViewController* _emojiViewController;
    DZInputActionViewController* _actionViewController;
    BOOL _isShowAddtions;
    //
    TKStateMachine* _stateMachine;
    //
    CGFloat _currentAddtionHeight;
    BOOL _inputFirestAppear;
    //
    DZAIOActionElement* _actionsEle;
#ifdef DEBUG
    NSTimer* _timer;
#endif
}
@property (nonatomic, strong) EKTableViewController* rootViewController;
@property (nonatomic, strong, readonly) EKTableElement<DZInputProtocol>* aioElement;

@property (nonatomic, strong) DZEmojiContainerViewController* emojiViewController;
@property (nonatomic, strong) DZInputActionViewController* actionViewController;
@property (nonatomic, assign) BOOL isShowAddtions;
@property (nonatomic, strong) UISwipeGestureRecognizer* swipeDown;
@property (nonatomic, strong) UITapGestureRecognizer* tapDown;

@end



@implementation DZInputViewController
#pragma Doing thing when event occurs

- (void) setIsShowAddtions:(BOOL)isShowAddtions
{
    _isShowAddtions = isShowAddtions;
}

- (void) sendTextEvent
{
    [_stateMachine fireEvent:kEventText userInfo:nil error:nil];

}

- (void) sendVoiceEvent
{
    [_stateMachine fireEvent:kEventAudio userInfo:nil error:nil];
 
}

- (void) sendActionEvent
{
    [_stateMachine fireEvent:kEventMore userInfo:nil error:nil];
 
}

- (void) sendEmojiEvent
{
    [_stateMachine fireEvent:kEventEmoji userInfo:nil error:nil];
 
}

- (void) voiceButtonToggleVoice
{
    ADDSelector(_toolbar.audioButton, @selector(sendTextEvent),  @selector(sendVoiceEvent));
}

- (void) voiceButtonToggleKeyboard
{
    ADDSelector(_toolbar.audioButton, @selector(sendVoiceEvent), @selector(sendTextEvent));
}

- (void) actionButtonToggleAction
{
    ADDSelector(_toolbar.actionButton, @selector(sendTextEvent), @selector(sendActionEvent));
}

- (void) actionButtonToggleKeyboard
{
    ADDSelector(_toolbar.actionButton, @selector(sendActionEvent), @selector(sendTextEvent));
}

- (void) emojiButtonToggleEmoji
{
    ADDSelector(_toolbar.emojiButton, @selector(sendTextEvent), @selector(sendEmojiEvent));
}

- (void) emojiButtonToggleKeyboard
{
    ADDSelector(_toolbar.emojiButton, @selector(sendEmojiEvent), @selector(sendTextEvent));
}

- (void) setupToolbarButton
{
    [self voiceButtonToggleKeyboard];
    [self emojiButtonToggleKeyboard];
    [self actionButtonToggleKeyboard];
}

- (void) enablePullDown
{
   _swipeDown.enabled = YES;
    _tapDown.enabled = YES;
 
}

- (void) disablePullDown
{
//    self.pullDownView.userInteractionEnabled= NO;
    _swipeDown.enabled = NO;
    _tapDown.enabled = NO;
 
}
- (void) setupMechine
{
    __weak typeof(self) wSelf = self;
    _stateMachine = [TKStateMachine new];
    TKState* textState   = [TKState stateWithName:kStateText];
    TKState* voiceState  = [TKState stateWithName:kStateVoice];
    TKState* actionState = [TKState stateWithName:kStateAction];
    TKState* emojiState  = [TKState stateWithName:kStateEmoji];
    TKState* noneState   = [TKState stateWithName:kStateNone];
    
    
    [voiceState setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar audioButtonShowNormal:NO];
        [wSelf voiceButtonToggleVoice];
        [wSelf layoutWithHiddenAdditon];
        [wSelf disablePullDown];
    }];
    
    [voiceState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar audioButtonShowNormal:YES];
        [wSelf voiceButtonToggleKeyboard];
    }];
    
    [emojiState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar emojiButtonShowNormal:NO];
        [wSelf emojiButtonToggleEmoji];
        [wSelf layoutWithShowAddtion];
        [wSelf.view bringSubviewToFront:wSelf.emojiViewController.view];
        wSelf.isShowAddtions = YES;
        [wSelf enablePullDown];
        
    }];
    [emojiState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar emojiButtonShowNormal:YES];
        [wSelf emojiButtonToggleKeyboard];
        wSelf.isShowAddtions  = NO;
    }];
    
    
    [actionState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar actionButtonShowNormal:NO];
        [wSelf actionButtonToggleAction];
        [wSelf layoutWithActionShow];
        [wSelf.view bringSubviewToFront:wSelf.actionViewController.view];
        wSelf.isShowAddtions = YES;
        [wSelf enablePullDown];

    }];
    
    [actionState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar actionButtonShowNormal:YES];
        [wSelf actionButtonToggleKeyboard];
        wSelf.isShowAddtions = NO;
    }];
    
    
    [textState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar.textInputView.textView becomeFirstResponder];
        [wSelf enablePullDown];
    }];
    
    [textState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        if ([transition.destinationState.name isEqualToString:kStateEmoji] ||
            [transition.destinationState.name isEqualToString:kStateAction]) {
            wSelf.isShowAddtions = YES;
        }
        [wSelf.toolbar.textInputView.textView resignFirstResponder];
    }];
    
    [noneState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        wSelf.isShowAddtions = NO;
        [wSelf disablePullDown];
        [wSelf layoutWithHiddenAdditon];
    }];
    [noneState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {

    }];
    
    [_stateMachine addStates:@[textState, noneState, emojiState, voiceState, actionState]];
    
    TKEvent* textEvent = [TKEvent eventWithName:kEventText transitioningFromStates:@[noneState, voiceState, actionState, emojiState] toState:textState];
    TKEvent* voiceEvent = [TKEvent eventWithName:kEventAudio transitioningFromStates:@[noneState, textState, actionState, emojiState] toState:voiceState];
    TKEvent* actionEvent = [TKEvent eventWithName:kEventMore transitioningFromStates:@[noneState, textState, voiceState, emojiState] toState:actionState];
    TKEvent* emojiEvent = [TKEvent eventWithName:kEventEmoji transitioningFromStates:@[noneState, textState, voiceState, actionState] toState:emojiState];
    TKEvent* noneEvent = [TKEvent eventWithName:kEventNone transitioningFromStates:@[emojiState, textState, voiceState, actionState] toState:noneState];
    [_stateMachine addEvents:@[textEvent, voiceEvent, actionEvent, emojiEvent, noneEvent]];
    [_stateMachine setInitialState:noneState];
}
- (instancetype) initWithElement:(EKElement *)ele contentViewController:(EKTableViewController *)viewController
{
    self = [self initWithNibName:nil bundle:nil];
    if (!self) {
        return self;
    }
    _rootViewController = viewController;
    _element = ele;
    _isFirstLayout = YES;
    _isShowAddtions = NO;
    self.aioElement.inputViewController  = self;
    self.hidesBottomBarWhenPushed = YES;
    _inputFirestAppear = YES;
    _currentAddtionHeight = CGFLOAT_MAX;
    return self;
}

- (void) appendChildViewController:(UIViewController*)vc
{
    [vc willMoveToParentViewController:self];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    [self.view addSubview:vc.view];
}

- (void) loadContentView
{
    
    [self appendChildViewController:_rootViewController];
    INIT_SUBVIEW_UIImageView(self.view, _backgroundImageView);
    if (self.aioElement.AIOToolbarType == DZAIOToolbarTypeNone) {
    } else if (self.aioElement.AIOToolbarType == DZAIOToolbarTypeEmoji) {
        _toolbar = [[DZInputToolbar alloc] initShowType:
                    DZInputToolbarShowTypeText |
                    DZInputToolbarShowTypeEmoji
                    ];
    }
    else {
        _toolbar = [[DZInputToolbar alloc] initShowType:
                    DZInputToolbarShowTypeText |
                    DZInputToolbarShowTypeAudio |
                    DZInputToolbarShowTypeEmoji |
                    DZInputToolbarShowTypeActions];
    }
    _toolbar.voiceInputView.delegate = self;
    [self.view addSubview:_toolbar];
    //
    _contentView = _rootViewController.view;
    [self.view addSubview:_contentView];
    //
    
    _emojiViewController = [DZEmojiContainerViewController new];
    _emojiViewController.emojiElement.delegate = self;
    _actionsEle = [DZAIOActionElement new];
    _actionsEle.delegate = self;
    _actionViewController = [[DZInputActionViewController alloc] initWithElement:_actionsEle];

    [self appendChildViewController:_emojiViewController];
    [self appenChildVC:_actionViewController];
    //

    _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownGestrue:)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    _swipeDown.numberOfTouchesRequired = 1;
    _swipeDown.delaysTouchesBegan = YES;
    _swipeDown.delegate = self;
    [self.view addGestureRecognizer:_swipeDown];
    
    _tapDown = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownGestrue:)];
    _tapDown.numberOfTapsRequired = 1;
    _tapDown.numberOfTouchesRequired = 1;
    _tapDown.delaysTouchesBegan = YES;
    _tapDown.delegate = self;
    [self.view addGestureRecognizer:_tapDown];
    
    [self disablePullDown];
}

- (void) handleSwipeDownGestrue:(UIGestureRecognizer*)gs
{
    if (gs.state == UIGestureRecognizerStateRecognized) {
        [_stateMachine fireEvent:kEventNone userInfo:nil error:nil];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == _tapDown || gestureRecognizer == _swipeDown) {
        CGPoint point = [touch locationInView:self.view];
        if (CGRectContainsPoint(self.rootViewController.view.frame, point)) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void) setupTextView
{
    _toolbar.textInputView.textView.delegate = self;
}

- (void) appenChildVC:(UIViewController*)vc
{
    if (vc.view.superview == self.view) {
        return;
    }
    [vc willMoveToParentViewController:self];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContentView];
    [self setupToolbarButton];
    [self setupMechine];
    [self setupTextView];
    self.edgesForExtendedLayout  = UIRectEdgeNone;
}

- (EKTableElement<DZInputProtocol>*) aioElement
{
    return (EKTableElement<DZInputProtocol>*)self.rootViewController.tableElement;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (_isFirstLayout) {
        _isFirstLayout =!_isFirstLayout;
        [self layoutWithHiddenAdditon];
    } else {
        [self layoutWithAddtionHeight:_currentAddtionHeight];
    }
    _backgroundImageView.frame =self.view.bounds;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_element willBeginHandleResponser:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_element didBeginHandleResponser:self];
    [DZKeyboardShareManager addObserver:self];
#ifdef DEBUG
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendTextDebug) userInfo:nil repeats:YES];
#endif
    if (ABS(_currentAddtionHeight - 0) < 1 ) {
        [self layoutWithAddtionHeight:_currentAddtionHeight];
    }
}

- (void) sendTextDebug
{
    [self sendText:@"xxx"];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_element willBeginHandleResponser:self];
    [DZKeyboardShareManager removeObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_element didRegsinHandleResponser:self];
    [_stateMachine fireEvent:kEventNone userInfo:nil error:nil];
}


- (void) layoutWithAddtionHeight:(CGFloat)height
{
    if (ABS(_currentAddtionHeight-height) < 1) {
        if ((ABS(CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_contentView.bounds)) - height) < 1) {
            return;
        }
    }

    _currentAddtionHeight = height;
    CGRect addtionRect;
    CGRect toolbarRect;
    CGRect contentRect;
    
    CGRectDivide(self.view.bounds, &addtionRect, &contentRect, height, CGRectMaxYEdge);
    
    CGFloat const kMaxToolHeight = 100;
    CGFloat toolbarHeigth = MIN(_toolbar.adjustHeight, kMaxToolHeight);
    CGRectDivide(contentRect, &toolbarRect, &contentRect, toolbarHeigth, CGRectMaxYEdge);
    if (_toolbar.adjustHeight > kMaxToolHeight) {
        _toolbar.textInputView.textView.scrollEnabled = YES;
    } else {
        _toolbar.textInputView.textView.scrollEnabled = NO;
    }
    _toolbar.frame = toolbarRect;
    _contentView.frame = contentRect;
    _emojiViewController.view.frame = addtionRect;
    _actionViewController.view.frame = addtionRect;
    if (_inputNoticeView) {
        CGSize size = _inputNoticeView.contentSize;
        CGRect rect = CGRectZero;
        rect.origin.y = CGRectGetMinY(_toolbar.frame) - size.height - 20;
        rect.origin.x = CGRectGetMaxX(_toolbar.frame) - size.width - 10;
        rect.size = size;
        _inputNoticeView.frame= rect;
        [self.view bringSubviewToFront:_inputNoticeView];
    }
}


- (void) keyboardChanged:(DZKeyboardTransition)transition
{
    kDZAdditionHeight = CGRectGetHeight(transition.endFrame);
    void(^AnimationBlock)(void) = ^(void) {
        if (transition.type == DZKeyboardTransitionShow) {
            [self layoutWithShowAddtion];
        } else {
            if (!_isShowAddtions) {
                [self layoutWithHiddenAdditon];
            }
        }
    };
    void(^FinishBlock)(BOOL) = ^(BOOL finish) {
    };
    [UIView animateWithDuration:transition.animationDuration animations:AnimationBlock completion:FinishBlock];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    [self sendTextEvent];
    return YES;
}
- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView
{
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutWithAddtionHeight:_currentAddtionHeight];
    }];
}

- (void) actualSendText
{
    UITextView* textView = _toolbar.textInputView.textView;
    NSString* text = textView.text;
    if (text.length == 0) {
        return;
    }
    [self sendText:textView.text];
    textView.text = @"";
    [self adjustToolbarHeight];
}
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self actualSendText];
        return NO;
    } else {
        return YES;
    }
}

- (void) sendText:(NSString*)text
{
    if ([self.aioElement respondsToSelector:@selector(inputText:)]) {
        [self.aioElement inputText:text];
    }
    self.toolbar.textInputView.textView.placeholderText = nil;

}
- (void) adjustToolbarHeight
{
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutWithAddtionHeight:_currentAddtionHeight];
    }];
}
#pragma Layouts
- (void) layoutWithShowAddtion
{
    [self layoutWithAddtionHeight:kDZAdditionHeight];
    if (self.scrollDirection == 0) {
        [self.rootViewController.tableElement scrollToEnd];
    } else {
        [self.rootViewController.tableView scrollsToTop];
    }
}

- (void) layoutWithActionShow
{
    [self layoutWithAddtionHeight:_actionsEle.preferHeight];
    if (self.scrollDirection == 0) {
        [self.rootViewController.tableElement scrollToEnd];
    } else {
        [self.rootViewController.tableView scrollsToTop];
    }
}

- (void) layoutWithHiddenAdditon
{
    [self layoutWithAddtionHeight:0];
}


#pragma Audio Recorder

- (void) voiceInputView:(DZVoiceInputView *)inputView didFinishRecord:(K12AudioRecorder *)recorder
{
    if ([self.aioElement respondsToSelector:@selector(inputVoice:)]) {
        [self.aioElement inputVoice:recorder.recorder.url];
    }
    self.toolbar.textInputView.textView.placeholderText = nil;

}

#pragma Actions
- (void) actionElement:(DZInputActionElement *)element didSelectAction:(EKElement *)itemElement
{
    if ([itemElement isKindOfClass:[DZAIOImageActionElement class]]) {
        DZAIOImageActionElement* imageAction = (DZAIOImageActionElement*)itemElement;
        if ([self.aioElement respondsToSelector:@selector(inputImage:)]) {
            [self.aioElement inputImage:imageAction.image];
        }
        self.toolbar.textInputView.textView.placeholderText = nil;

    } else if ([itemElement isKindOfClass:[DZEmojiItemElement class]]) {
        DZEmojiItemElement* emoji = (DZEmojiItemElement*)itemElement;
        NSString* text = _toolbar.textInputView.textView.text;
        text = text ? text :@"";
        if ([emoji.emoji isEqualToString:kDZEmojiSendKey]) {
            [self actualSendText];
        } else {
            _toolbar.textInputView.textView.text = [text stringByAppendingString:emoji.emoji];
            [self adjustToolbarHeight];
        }
        
        
    } else if ([itemElement isKindOfClass:[DZAIOMapActionElement class]]) {
        DZAIOMapActionElement* mapEle = (DZAIOMapActionElement*)itemElement;
        if ([self.aioElement respondsToSelector:@selector(inputLocation:)]) {
            [self.aioElement inputLocation:mapEle.location];
        }
        self.toolbar.textInputView.textView.placeholderText = nil;
    }
    else {
        DDLogError(@"Get Data, but can not decode it");
    }
}
- (void) showTextInputWithPlaceholder:(NSString *)placeholder
{
    self.toolbar.textInputView.textView.placeholderText = placeholder;
    [self sendTextEvent];
}


#pragma Input Notice

- (void) setInputNoticeView:(DZInputNoticeView *)inputNoticeView
{
    if (_inputNoticeView != inputNoticeView) {
        [_inputNoticeView removeFromSuperview];
        _inputNoticeView = inputNoticeView;
        [self.view addSubview:_inputNoticeView];
    }
}

- (void) showNoticeView:(DZInputNoticeView*)inputNoticeView{

    self.inputNoticeView =  inputNoticeView;
    [self layoutWithAddtionHeight:_currentAddtionHeight];
}
@end
