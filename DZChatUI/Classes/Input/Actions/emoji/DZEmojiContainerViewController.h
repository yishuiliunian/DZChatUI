//
//  DZEmojiContainerViewController.h
//  Pods
//
//  Created by stonedong on 16/6/19.
//
//

#import <UIKit/UIKit.h>
#import "DZEmojiActionElement.h"
#import "DZInputActionViewController.h"
#import "DZEmojiToolbar.h"
FOUNDATION_EXTERN NSString* const kDZEmojiSendKey;
@interface DZEmojiContainerViewController : UIViewController
@property (nonatomic, strong, readonly) DZInputActionViewController* emojiViewController;
@property (nonatomic, strong, readonly) DZEmojiActionElement* emojiElement;
@end
