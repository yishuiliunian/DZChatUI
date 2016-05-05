//
//  DZInputViewController.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZInputViewController.h"
#import "DZInputContentView.h"
@interface DZInputViewController ()
{
    DZInputContentView* _inputContentView;
}
@property (nonatomic, strong) UIViewController* rootViewController;
@end

@implementation DZInputViewController

- (instancetype) initWithElement:(EKElement *)ele contentViewController:(UIViewController *)viewController
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
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

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

@end
