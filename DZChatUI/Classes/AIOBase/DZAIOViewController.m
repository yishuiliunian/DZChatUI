//
//  DZAIOViewController.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZAIOViewController.h"
#import "MJRefresh.h"
#import "DZAIOTableElement.h"

@interface DZAIOViewController ()

@end
@implementation DZAIOViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    __weak typeof(self) wSelf=self;
    MJRefreshNormalHeader* header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([wSelf.tableElement respondsToSelector:@selector(handleLoadOldMessage)]) {
            [wSelf.tableElement performSelector:@selector(handleLoadOldMessage)];
        }
    }];
    [self.tableView setMj_header:header];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
}
@end
