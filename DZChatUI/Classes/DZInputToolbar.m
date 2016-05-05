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
#import "DZGeometryTools.h"
#define LoadPodImage(name)   [UIImage imageNamed:@"DZChatUI.bundle/"#name inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]


CGFloat const kSTMinHeight = 44;
CGSize const kButtonSize = {35, 35};

@interface DZInputToolbar () <UITextViewDelegate>

@end


@implementation DZInputToolbar

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW(DZGrowTextView, _textView);
    INIT_SELF_SUBVIEW(UIButton, _emojiButton);
    INIT_SUBVIEW_UIButton(self, _actionButton);
    INIT_SUBVIEW_UIButton(self, _keyboardButton);
    _textView.delegate = self;
    self.adjustHeight = kSTMinHeight;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.layer.cornerRadius = 4;
    _textView.delegate = self;
    [self showKeyboardButtonImages];
    [_keyboardButton addTarget:self action:@selector(showVoiceInput) forControlEvents:UIControlEventTouchUpInside];
    _keyboardButton.backgroundColor = [UIColor redColor];
    
    //
    [_emojiButton addTarget:self action:@selector(showEmoji) forControlEvents:UIControlEventTouchUpInside];
    [_emojiButton setImage:LoadPodImage(ToolViewEmotion) forState:UIControlStateNormal];
    [_emojiButton setImage:LoadPodImage(ToolViewEmotionHL) forState:UIControlStateNormal];
    //
    _textView.enablesReturnKeyAutomatically = YES;
    
    return self;
}
- (void) showEmoji
{
    
}


- (void) showVoiceInput
{
    [_textView resignFirstResponder];
    [self showKeyboardButtonImages];
    [_keyboardButton removeTarget:self action:@selector(showVoiceInput) forControlEvents:UIControlEventTouchUpInside];
    [_keyboardButton addTarget:self action:@selector(showTextInput) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showTextInput
{
    [_textView becomeFirstResponder];
    [self showKeyboardButtonImages];
    [_keyboardButton removeTarget:self action:@selector(showTextInput) forControlEvents:UIControlEventTouchUpInside];
    [_keyboardButton addTarget:self action:@selector(showVoiceInput) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showKeyboardButtonImages
{
    if (!_textView.isFirstResponder) {
        [_keyboardButton setImage:LoadPodImage(ToolViewKeyboard) forState:UIControlStateNormal];
        [_keyboardButton setImage:LoadPodImage(ToolViewKeyboardHL) forState:UIControlStateHighlighted];
    } else {
        [_keyboardButton setImage:LoadPodImage(ToolViewInputVoice) forState:UIControlStateNormal];
        [_keyboardButton setImage:LoadPodImage(ToolViewInputVoiceHL) forState:UIControlStateHighlighted];
    }

}
- (void) handleAdjustFrame
{
    self.adjustHeight = MAX(self.textView.adjustHeight, 44) + 10;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGFloat space = 10;
    CGRect contentRect = self.bounds;
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(10, 10));
    CGRect keyboardRect;
    CGRect textRect;
    CGRect emojiRect;
    CGRect actionRect;
    
    CGRectDivide(contentRect, &keyboardRect, &contentRect, kButtonSize.width, CGRectMinXEdge);
    keyboardRect = CGRectCenter(keyboardRect, kButtonSize);
    
    contentRect = CGRectShrink(contentRect, space, CGRectMinXEdge);
    CGRectDivide(contentRect, &actionRect, &contentRect, kButtonSize.width, CGRectMaxXEdge);
    contentRect = CGRectShrink(contentRect, space, CGRectMaxXEdge);
    
    CGRectDivide(contentRect, &emojiRect, &contentRect, kButtonSize.width, CGRectMaxXEdge);
    contentRect = CGRectShrink(contentRect, space, CGRectMaxXEdge);
    
    emojiRect = CGRectCenter(emojiRect, kButtonSize);
    actionRect = CGRectCenter(actionRect, kButtonSize);
    
    _emojiButton.frame  = emojiRect;
    _actionButton.frame = actionRect;
    _keyboardButton.frame = keyboardRect;
    _textView.frame = contentRect;
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

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _textView.returnKeyType = UIReturnKeyDone;
    return YES;
}



@end
