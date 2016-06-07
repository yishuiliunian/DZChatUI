//
//  DZInputViewController.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZInputViewController.h"
#import "DZInputContentView.h"
#import "DZAIOViewController.h"
#import "DZEmojiItemElement.h"
#import "DZEmojiActionElement.h"
#import "EKCollectionViewController.h"
#import "DZAIOTableElement.h"
#import "DZInputToolbar.h"
#import "DZInputBeginFooter.h"
#import <DZKeyboardManager/DZKeyboardManager.h>
#import "DZEmojiActionElement.h"
#import "DZInputActionViewController.h"
#import "DZEmojiItemElement.h"
#import "DZAIOActionElement.h"
#import "DZAIOImageActionElement.h"


static CGFloat kDZAdditionHeight = 271;


@interface DZInputViewController () <DZInputToolBarUIDelegate, DZKeyboardChangedProtocol>
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
}
@property (nonatomic, strong) DZAIOViewController* rootViewController;
@property (nonatomic, strong) DZInputBeginFooter* beginFooter;
@end

@implementation DZInputViewController

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
    _toolbar.delegate = _rootViewController.tableElement;
    _toolbar.uiDelegate = self;
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

- (void) wllResponseToKeyboardChanged:(DZKeyboardTransition)transition
{
    [self scroolToEnd];
    if (transition.type == DZKeyboardTransitionShow) {
        
    }
}
- (void) didResponseToKeyboardChanged:(DZKeyboardTransition)transition
{
    [self scroolToEnd];
}

- (BOOL) transiztionUseAnimation
{
    return NO;
}
//- (void) actionElement:(DZInputActionElement *)element didSelectAction:(EKElement *)itemElement
//{
//    if ([itemElement isKindOfClass:[DZEmojiItemElement class]] ) {
//        DZEmojiItemElement* emojiElement = (DZEmojiItemElement*)itemElement;
//        NSString* text = _textView.text;
//        text = text?text:@"";
//        text = [text stringByAppendingString:emojiElement.emoji];
//        _textView.text=text;
//    } else if ([itemElement isKindOfClass:[DZAIOImageActionElement class]]) {
//        DZAIOImageActionElement* item =(DZAIOImageActionElement*)itemElement;
//        if ([self.delegate respondsToSelector:@selector(inputToolbar:sendImage:)]) {
//            [self.delegate inputToolbar:self sendImage:item.image];
//        }
//        _actionShowed = NO;
//        [self handleAdjustFrame];
//    }
//}

#
- (void) inputToolbarHideEmoji:(DZInputToolbar *)toolbar
{
    _isShowAddtions = NO;
    [self hideAddtions];
}

- (void) showAddtions
{
    [self layoutWithAddtionHeight:kDZAdditionHeight];
}

- (void) hideAddtions
{
    [self layoutWithAddtionHeight:0];
}

- (void) inputToolbarShowEmoji:(DZInputToolbar *)toolbar
{
    
    _isShowAddtions = YES;
    [self.view bringSubviewToFront:_emojiViewController.view];
    [self showAddtions];
}

- (void) inputToolbarHideActions:(DZInputToolbar *)toolbar
{
    _isShowAddtions = NO;
    [self hideAddtions];
}

- (void) inputToolbarShowActions:(DZInputToolbar *)toolbar
{
    _isShowAddtions = YES;
    [self layoutWithAddtionHeight:kDZAdditionHeight];
    [self.view bringSubviewToFront:_actionViewController.view];
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
    [self wllResponseToKeyboardChanged:transition];
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
        [self didResponseToKeyboardChanged:transition];
    };
    if ([self transiztionUseAnimation]) {
        [UIView animateWithDuration:transition.animationDuration animations:AnimationBlock completion:FinishBlock];
    } else {
        AnimationBlock();
        FinishBlock(YES);
    }
}
@end
