//
//  DZInputToolbar.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZInputToolbar.h"
#import "DZProgramDefines.h"
#import "DZImageCache.h"
#import "DZLayout.h"


CGFloat const kSTMinHeight = 44;

@implementation DZInputToolbar

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW(DZGrowTextView, _textView);
    INIT_SELF_SUBVIEW(UIButton, _sendButton);
    self.backgroundColor = [UIColor colorWithPatternImage:DZCachedImageByName(@"ChatBackgroundThumb")];
    _textView.delegate = self;
    self.adjustHeight = kSTMinHeight;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.layer.cornerRadius = 4;
    
    DZMarginLayout* mL = [[DZMarginLayout alloc] initWithXMargin:10 yMargin:10];
    DZ2PartLayout* partLayout = [[DZ2PartLayout alloc] initWithFix:80 edge:CGRectMaxXEdge];
    partLayout.part1 = _textView;
    partLayout.part2 = _sendButton;
    
    mL.contentLayout = partLayout;
    self.layout = mL;
    
    return self;
}
- (void) handleAdjustFrame
{
    self.adjustHeight = self.textView.adjustHeight + 20;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.layout.frame = self.bounds;
    [self.layout layoutContent];
}

- (BOOL) resignFirstResponder
{
    [_textView resignFirstResponder];
    return [super resignFirstResponder];
}

- (void) textViewDidChange:(UITextView *)textView
{
    [_textView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    CGSize size = [_textView sizeThatFits:textView.frame.size];
    self.adjustHeight = size.height + 20;
}

@end
