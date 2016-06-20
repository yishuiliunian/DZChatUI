//
//  DZAIOMapActionElement.m
//  Pods
//
//  Created by stonedong on 16/6/18.
//
//

#import "DZAIOMapActionElement.h"
#import <YHMapLocation/YHSelectAddressElement.h>
#import <YHMapLocation/YHSelectAddressViewController.h>

@interface DZAIOMapActionElement () <YHSelectAddressDelegate>

@end

@implementation DZAIOMapActionElement
@synthesize location = _location;

- (void) handleActionInViewController:(UIViewController *)vc
{
    YHSelectAddressElement* ele = [YHSelectAddressElement new];
    ele.delegate = self;
    YHSelectAddressViewController* selectVC = [[YHSelectAddressViewController alloc] initWithElement:ele];
    [vc.navigationController pushViewController:selectVC animated:YES];
}


- (void) selectAddressElement:(YHSelectAddressElement *)ele didSelected:(YHLocation *)location
{
    if (location) {
        _location = location;
        [self.eventBus performSelector:@selector(mapElementLocationReady:) withObject:self];
    }
}

@end
