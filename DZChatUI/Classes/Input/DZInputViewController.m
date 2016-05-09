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
@interface DZInputViewController () <DZInputToolBarUIDelegate>
{
    DZInputContentView* _inputContentView;
    UISwipeGestureRecognizer* _swipeDown;
    UIView* _maskView;
}
@property (nonatomic, strong) DZAIOViewController* rootViewController;
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
    return self;
}


- (void) loadContentView
{
    [_rootViewController willMoveToParentViewController:self];
    [self addChildViewController:_rootViewController];
    [_rootViewController didMoveToParentViewController:self];
    _inputContentView = [DZInputContentView new];
    [self.view addSubview:_inputContentView];
    //
    _inputContentView.toolBar= [DZInputToolbar new];
    _inputContentView.contentView = self.rootViewController.view;
    [_inputContentView addSubview:_inputContentView.toolBar];
    [_inputContentView addSubview:_rootViewController.view];
    //
    self.contentView = _inputContentView;
    _inputContentView.toolBar.delegate = _rootViewController.tableElement;
    _inputContentView.toolBar.uiDelegate = self;
    //
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
    
    UISwipeGestureRecognizer* panG = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pullDownHanle:)];
    panG.direction = UISwipeGestureRecognizerDirectionDown;
    
    
    [self.contentView addGestureRecognizer:panG];
    _swipeDown = panG;
    _swipeDown.delegate = self;
    _maskView.userInteractionEnabled = YES;
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


- (void) pullDownHanle:(UIPanGestureRecognizer*)pan
{
    if (pan.state == UIGestureRecognizerStateRecognized) {
            [_inputContentView.toolBar endInputing];
    }
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
}

- (void) inputToolbarEndShowAddtions:(DZInputToolbar *)toolbar
{
    _swipeDown.enabled = NO;
    [self scroolToEnd];
}

- (void) inputToolbarBeginShowAddtions:(DZInputToolbar *)toolbar
{
    [self scroolToEnd];
    _swipeDown.enabled = YES;
}

@end
