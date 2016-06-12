//
//  DZTextInputView.m
//  Pods
//
//  Created by stonedong on 16/6/9.
//
//

#import "DZTextInputView.h"
#import "DZProgrameDefines.h"
#import "HexColors.h"

@implementation DZTextInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW(DZGrowTextView, _textView);
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.layer.cornerRadius = 4;
    _textView.delegate = self;
    //
    _textView.enablesReturnKeyAutomatically = YES;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.borderColor = [UIColor hx_colorWithHexString:@"c3c3c4"].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    return self;
}

- (CGFloat) aimHeight
{
    CGSize size = [_textView.text sizeWithFont:_textView.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)];
    return  MAX([super aimHeight], size.height);
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    _textView.frame = self.bounds;
}
@end
