//
//  DZAlphaView.m
//  Pods
//
//  Created by stonedong on 16/5/31.
//
//

#import "DZAlphaView.h"

@implementation DZAlphaView
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

@end
