//
//  DZAIOViewController.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZAIOViewController.h"

@implementation DZAIOViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
}
@end
