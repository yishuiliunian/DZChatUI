//
//  DZInputViewController.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZInputViewController.h"
#import "DZAIOViewController.h"
#import "DZEmojiItemElement.h"
#import "DZEmojiActionElement.h"
#import "EKCollectionViewController.h"
#import "DZAIOTableElement.h"
#import "DZInputToolbar.h"
#import <DZKeyboardManager/DZKeyboardManager.h>
#import "DZEmojiActionElement.h"
#import "DZInputActionViewController.h"
#import "DZEmojiItemElement.h"
#import "DZAIOActionElement.h"
#import "DZAIOImageActionElement.h"
#import <TransitionKit/TransitionKit.h>

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



@interface DZInputViewController () <DZKeyboardChangedProtocol, UITextViewDelegate>
{
    UISwipeGestureRecognizer* _swipeDown;
    UIView* _maskView;
    //
    UIView* _contentView;
    DZInputToolbar* _toolbar;
    
    CGFloat _toolbarHeight;
    CGFloat _actionHeight;
    //
    BOOL _isFirstLayout;
    //
    DZInputActionViewController* _emojiViewController;
    DZInputActionViewController* _actionViewController;
    BOOL _isShowAddtions;
    //
    TKStateMachine* _stateMachine;
}
@property (nonatomic, strong) DZAIOViewController* rootViewController;
@property (nonatomic, strong) DZInputToolbar* toolbar;
@property (nonatomic, strong) DZInputActionViewController* emojiViewController;
@property (nonatomic, strong) DZInputActionViewController* actionViewController;
@property (nonatomic, assign) BOOL isShowAddtions;
@end


@implementation DZInputViewController
#pragma Doing thing when event occurs


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
        [wSelf layoutWithAddtionHeight:0];
    }];
    [voiceState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar audioButtonShowNormal:YES];
        [wSelf voiceButtonToggleKeyboard];
    }];
    
    [emojiState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar emojiButtonShowNormal:NO];
        [wSelf emojiButtonToggleEmoji];
        [wSelf layoutWithAddtionHeight:kDZAdditionHeight];
        [wSelf.view bringSubviewToFront:wSelf.emojiViewController.view];
        wSelf.isShowAddtions = YES;
    }];
    [emojiState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar emojiButtonShowNormal:YES];
        [wSelf emojiButtonToggleKeyboard];
        wSelf.isShowAddtions  = NO;
    }];
    
    
    [actionState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar actionButtonShowNormal:NO];
        [wSelf actionButtonToggleAction];
        [wSelf layoutWithAddtionHeight:kDZAdditionHeight];
        [wSelf.view bringSubviewToFront:wSelf.actionViewController.view];
        wSelf.isShowAddtions = YES;
    }];
    
    [actionState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar actionButtonShowNormal:YES];
        [wSelf actionButtonToggleKeyboard];
        wSelf.isShowAddtions = NO;
    }];
    
    
    [textState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar.textInputView.textView becomeFirstResponder];
    }];
    
    [textState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        if ([transition.destinationState.name isEqualToString:kStateEmoji] ||
            [transition.destinationState.name isEqualToString:kStateAction]) {
            wSelf.isShowAddtions = YES;
        }
        [wSelf.toolbar.textInputView.textView resignFirstResponder];
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
- (instancetype) initWithElement:(EKElement *)ele contentViewController:(DZAIOViewController *)viewController
{
    self = [self initWithNibName:nil bundle:nil];
    if (!self) {
        return self;
    }
    _rootViewController = viewController;
    _element = ele;
    _isFirstLayout = YES;
    _isShowAddtions = NO;

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
    _toolbar = [DZInputToolbar new];
    [self.view addSubview:_toolbar];
    //
    _contentView = _rootViewController.view;
    [self.view addSubview:_contentView];
    //
    
    DZEmojiActionElement* emojiEle = [DZEmojiActionElement new];
    emojiEle.delegate = self;
    _emojiViewController = [[DZInputActionViewController alloc] initWithElement:emojiEle];
    DZAIOActionElement* actionsEle = [DZAIOActionElement new];
    actionsEle.delegate = self;
    _actionViewController = [[DZInputActionViewController alloc] initWithElement:actionsEle];

    [self appendChildViewController:_emojiViewController];
    [self appenChildVC:_actionViewController];
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
    _swipeDown.enabled = NO;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


- (void) scroolToEnd
{
    [(DZAIOTableElement*)_rootViewController.tableElement scrollToEnd];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (_isFirstLayout) {
        _isFirstLayout =!_isFirstLayout;
        [self layoutWithAddtionHeight:0];
    }
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
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_element willBeginHandleResponser:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_element didRegsinHandleResponser:self];
    [DZKeyboardShareManager removeObserver:self];
}


- (void) layoutWithAddtionHeight:(CGFloat)height
{
    CGRect addtionRect;
    CGRect toolbarRect;
    CGRect contentRect;
    
    CGRectDivide(self.view.bounds, &addtionRect, &contentRect, height, CGRectMaxYEdge);
    CGRectDivide(contentRect, &toolbarRect, &contentRect, _toolbar.adjustHeight, CGRectMaxYEdge);
    _toolbar.frame = toolbarRect;
    _contentView.frame = contentRect;
    _emojiViewController.view.frame = addtionRect;
    _actionViewController.view.frame = addtionRect;
}


- (void) keyboardChanged:(DZKeyboardTransition)transition
{
    kDZAdditionHeight = CGRectGetHeight(transition.endFrame);
    void(^AnimationBlock)(void) = ^(void) {
        if (transition.type == DZKeyboardTransitionShow) {
            [self layoutWithAddtionHeight:transition.endFrame.size.height];
        } else {
            if (!_isShowAddtions) {
                [self layoutWithAddtionHeight:0];
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
@end
