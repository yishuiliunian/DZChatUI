//
//  DZInputContentView.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZInputContentView.h"

@implementation DZInputContentView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect topR;
    CGRect tbR;
    CGRectDivide(self.bounds, &tbR, &topR, _toolBar.adjustHeight, CGRectMaxYEdge);
    _contentView.frame = topR;
    _toolBar.frame=tbR;
}


- (void) handleAdjustFrame
{
    [UIView animateWithDuration:0.23 animations:^{
        [self layoutSubviews];
    }];
}
@end
