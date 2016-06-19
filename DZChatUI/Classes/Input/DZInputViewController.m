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
#import <DZLogger/DZLogger.h>
#import <DZAudio/DZAudio.h>
#import "DZAlphaView.h"
#import "DZAIOImageActionElement.h"

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



@interface DZInputViewController () <DZKeyboardChangedProtocol, UITextViewDelegate, DZVoiceInputViewDelegate, DZInputActionElementDelegate>
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
    DZInputActionViewController* _emojiViewController;
    DZInputActionViewController* _actionViewController;
    BOOL _isShowAddtions;
    //
    TKStateMachine* _stateMachine;
    //
    CGFloat _currentAddtionHeight;
    //
    DZAlphaView* _pullDownView;
}
@property (nonatomic, strong) DZAIOViewController* rootViewController;
@property (nonatomic, strong, readonly) DZAIOTableElement* aioElement;
@property (nonatomic, strong) DZInputToolbar* toolbar;
@property (nonatomic, strong) DZInputActionViewController* emojiViewController;
@property (nonatomic, strong) DZInputActionViewController* actionViewController;
@property (nonatomic, assign) BOOL isShowAddtions;
@property (nonatomic, strong) UISwipeGestureRecognizer* swipeDown;
@property (nonatomic, strong)    DZAlphaView* pullDownView;
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
        wSelf.pullDownView.userInteractionEnabled= NO;
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
         wSelf.pullDownView.userInteractionEnabled = YES;
        [wSelf.emojiViewController.collectionView reloadData];
        
    }];
    [emojiState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar emojiButtonShowNormal:YES];
        [wSelf emojiButtonToggleKeyboard];
        wSelf.isShowAddtions  = NO;
        
    }];
    
    
    [actionState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar actionButtonShowNormal:NO];
        [wSelf actionButtonToggleAction];
        [self layoutWithShowAddtion];
        [wSelf.view bringSubviewToFront:wSelf.actionViewController.view];
        wSelf.isShowAddtions = YES;
         wSelf.pullDownView.userInteractionEnabled = YES;

    }];
    
    [actionState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar actionButtonShowNormal:YES];
        [wSelf actionButtonToggleKeyboard];
        wSelf.isShowAddtions = NO;
    }];
    
    
    [textState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [wSelf.toolbar.textInputView.textView becomeFirstResponder];
        wSelf.pullDownView.userInteractionEnabled = YES;

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
        wSelf.pullDownView.userInteractionEnabled = NO;
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
    _toolbar.voiceInputView.delegate = self;
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
    //
    _pullDownView = [DZAlphaView new];
    [self.view addSubview:_pullDownView];

    _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownGestrue:)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    _swipeDown.numberOfTouchesRequired = 1;
    [_pullDownView addGestureRecognizer:_swipeDown];
    _swipeDown.delegate = self;
    _pullDownView.userInteractionEnabled = NO;
}

- (void) handleSwipeDownGestrue:(UISwipeGestureRecognizer*)gs
{
    if (gs.state == UIGestureRecognizerStateRecognized) {
        [_stateMachine fireEvent:kEventNone userInfo:nil error:nil];
    }
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

- (DZAIOTableElement*) aioElement
{
    return (DZAIOTableElement*)self.rootViewController.tableElement;
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
        [self layoutWithHiddenAdditon];
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
    [self.view bringSubviewToFront:_pullDownView];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_element didRegsinHandleResponser:self];
    [DZKeyboardShareManager removeObserver:self];
}


- (void) layoutWithAddtionHeight:(CGFloat)height
{
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
    _pullDownView.frame = contentRect;
}


- (void) keyboardChanged:(DZKeyboardTransition)transition
{
    kDZAdditionHeight = MAX(CGRectGetHeight(transition.endFrame), kDZAdditionHeight);
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
    NSLog(@"%f",_toolbar.textInputView.aimHeight);
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutWithAddtionHeight:_currentAddtionHeight];
    }];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendText:textView.text];
        textView.text = @"";
        [self adjustToolbarHeight];
        return NO;
    } else {
        return YES;
    }
}

- (void) sendText:(NSString*)text
{
    [self.aioElement inputText:text];
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
    [self.rootViewController.tableElement scrollToEnd];
}

- (void) layoutWithHiddenAdditon
{
    [self layoutWithAddtionHeight:0];
}


#pragma Audio Recorder

- (void) voiceInputView:(DZVoiceInputView *)inputView didFinishRecord:(K12AudioRecorder *)recorder
{
    [self.aioElement inputVoice:recorder.recorder.url];
}

#pragma Actions
- (void) actionElement:(DZInputActionElement *)element didSelectAction:(EKElement *)itemElement
{
    if ([itemElement isKindOfClass:[DZAIOImageActionElement class]]) {
        DZAIOImageActionElement* imageAction = (DZAIOImageActionElement*)itemElement;
        [self.aioElement inputImage:imageAction.image];
    } else {
        if ([itemElement isKindOfClass:[DZEmojiItemElement class]]) {
            DZEmojiItemElement* emoji = (DZEmojiItemElement*)itemElement;
            NSString* text = _toolbar.textInputView.textView.text;
            text = text ? text :@"";
            _toolbar.textInputView.textView.text = [text stringByAppendingString:emoji.emoji];
            [self adjustToolbarHeight];
      
        }
    }
}
@end
