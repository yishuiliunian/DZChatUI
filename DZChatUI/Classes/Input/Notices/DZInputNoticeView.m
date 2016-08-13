//
//  DZInputNoticeView.m
//  Pods
//
//  Created by stonedong on 16/8/13.
//
//

#import "DZInputNoticeView.h"

@implementation DZInputNoticeView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    return self;
}

- (void) handleAction:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (self.action) {
            self.action();
        }
        [self removeFromSuperview];
    }
}

- (CGSize) contentSize
{
    return (CGSize){0,0};
}

@end
