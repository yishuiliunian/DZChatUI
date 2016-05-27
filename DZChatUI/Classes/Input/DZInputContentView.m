//
//  DZInputContentView.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZInputContentView.h"

@interface DZAlphaView : UIView

@end

@implementation DZAlphaView

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

@end

@interface DZInputContentView () <UIGestureRecognizerDelegate>
{
    DZAlphaView* _maskView;
}
@end
@implementation DZInputContentView

- (void) dealloc
{
    [_toolBar removeObserver:self forKeyPath:@"showingBottomFunctions"];
}
- (instancetype) initWithToolbar:(DZInputToolbar *)toolbar contentView:(UIView *)contentView
{
    self = [super init];
    if (!self) {
        return self;
    }
    _toolBar = toolbar;
    [self addSubview:toolbar];
    _contentView = contentView;
    [self addSubview:_contentView];
    _maskView = [DZAlphaView new];
    [self addSubview:_maskView];
    _maskView.userInteractionEnabled =  NO;
    [_toolBar addObserver:self forKeyPath:@"showingBottomFunctions" options:NSKeyValueObservingOptionNew context:nil];
    //
    UISwipeGestureRecognizer* swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipGesture:)];
    swipG.direction  = UISwipeGestureRecognizerDirectionDown;
    swipG.delegate = self;
    [_maskView addGestureRecognizer:swipG];
    return self;
}
- (BOOL)  gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) handleSwipGesture:(UISwipeGestureRecognizer*)swipG
{
    if (swipG.state == UIGestureRecognizerStateRecognized) {
        [_toolBar endInputing];
    }
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"showingBottomFunctions"]) {
        _maskView.userInteractionEnabled = _toolBar.showingBottomFunctions;
    }
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect topR;
    CGRect tbR;
    CGRectDivide(self.bounds, &tbR, &topR, _toolBar.adjustHeight, CGRectMaxYEdge);
    _contentView.frame = topR;
    _toolBar.frame=tbR;
    _maskView.frame = _contentView.frame;
    [self bringSubviewToFront:_maskView];
}


- (void) handleAdjustFrame
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.23 animations:^{
            [self layoutSubviews];
        } completion:^(BOOL finished) {
            
        }];
    });

}
@end
