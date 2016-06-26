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
#import "DZEmojiMapper.h"

@implementation DZTextInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    
//    YYTextDebugOption *debugOptions = [YYTextDebugOption new];
//    debugOptions.baselineColor = [UIColor redColor];
//    debugOptions.CTFrameBorderColor = [UIColor redColor];
//    debugOptions.CTLineFillColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:0.180];
//    debugOptions.CGGlyphBorderColor = [UIColor colorWithRed:1.000 green:0.524 blue:0.000 alpha:0.200];
//    [YYTextDebugOption setSharedDebugOption:debugOptions];
//    
    
    INIT_SELF_SUBVIEW(YYTextView, _textView);
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
    _textView.font = [UIFont systemFontOfSize:15];

    _textView.scrollEnabled = NO;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.textParser = [DZEmojiMapper mapper].textEmojiParser;
    _textView.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    return self;
}

- (CGFloat) aimHeight
{
    CGSize constrainedSize = CGSizeMake(CGRectGetWidth(self.bounds) - 10, CGFLOAT_MAX);
    CGSize size = [_textView sizeThatFits:constrainedSize];
    return  MAX(35, size.height);
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    _textView.frame = self.bounds;
}
@end
