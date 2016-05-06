//
//  DZInputToolbar.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <UIKit/UIKit.h>
#import <DZAdjustFrame/DZAdjustFrame.h>


@class DZInputToolbar;
@protocol DZInputToolbarDelegate 

- (void) inputToolbar:(DZInputToolbar*)toolbar sendText:(NSString*)text;

@end

@interface DZInputToolbar : UIView
@property (nonatomic, weak) NSObject<DZInputToolbarDelegate>* delegate;
@property (nonatomic, strong, readonly) DZGrowTextView* textView;
@property (nonatomic, strong, readonly) UIButton* emojiButton;
@property (nonatomic, strong, readonly) UIButton* keyboardButton;
@property (nonatomic, strong, readonly) UIButton* actionButton;
@end
