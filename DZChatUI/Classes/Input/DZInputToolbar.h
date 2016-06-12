//
//  DZInputToolbar.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <UIKit/UIKit.h>

#import "DZTextInputView.h"
#import "DZVoiceInputView.h"



@interface DZInputToolbar : UIView
@property (nonatomic, strong, readonly) UIButton* emojiButton;
@property (nonatomic, strong, readonly) UIButton* audioButton;
@property (nonatomic, strong, readonly) UIButton* actionButton;
@property (nonatomic, assign, readonly) BOOL showingBottomFunctions;
@property (nonatomic, strong, readonly) DZTextInputView* textInputView;
@property (nonatomic, strong, readonly) DZVoiceInputView* voiceInputView;

- (void) audioButtonShowNormal:(BOOL)normal;
- (void) emojiButtonShowNormal:(BOOL)normal;
- (void) actionButtonShowNormal:(BOOL)normal;

- (void) changeToTextInput;
- (void) changeToVoiceInput;
@end
