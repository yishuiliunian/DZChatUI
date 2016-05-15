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
@class AVAudioRecorder;
@protocol DZInputToolbarDelegate 

- (void) inputToolbar:(DZInputToolbar*)toolbar sendText:(NSString*)text;

- (void) inputToolbar:(DZInputToolbar *)toolbar sendImage:(UIImage*)image;

- (void) inputToolbar:(DZInputToolbar *)toolbar sendVoice:(AVAudioRecorder*)recorder;
@end

@protocol DZInputToolBarUIDelegate <NSObject>


- (void) inputToolbarBeginShowAddtions:(DZInputToolbar *)toolbar;
- (void) inputToolbarEndShowAddtions:(DZInputToolbar*)toolbar;
@end

@interface DZInputToolbar : UIView
@property (nonatomic, weak) NSObject<DZInputToolbarDelegate>* delegate;
@property (nonatomic, weak) id<DZInputToolBarUIDelegate> uiDelegate;
@property (nonatomic, strong, readonly) DZGrowTextView* textView;
@property (nonatomic, strong, readonly) UIButton* emojiButton;
@property (nonatomic, strong, readonly) UIButton* audioButton;
@property (nonatomic, strong, readonly) UIButton* actionButton;

- (void) endInputing;
@end
