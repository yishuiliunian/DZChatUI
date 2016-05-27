//
//  DZInputBeginFooter.m
//  Pods
//
//  Created by stonedong on 16/5/27.
//
//

#import "DZInputBeginFooter.h"

@implementation DZInputBeginFooter
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _enable = YES;
        self.automaticallyRefresh = NO;
    }
    return self;
}
- (void) prepare
{
    [super prepare];
    self.mj_h = 10;
    self.backgroundColor = [UIColor redColor];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    if (!_enable) {
        return;
    }
    CGPoint old = [change[@"old"] CGPointValue];
    CGPoint new = [change[@"new"] CGPointValue];
    if (old.y > new.y) {
        [self beginRefreshing];
    }

}

@end
