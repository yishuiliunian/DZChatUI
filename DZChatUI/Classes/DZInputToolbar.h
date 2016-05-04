//
//  DZInputToolbar.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <UIKit/UIKit.h>
#import <DZAdjustFrame/DZAdjustFrame.h>
@interface DZInputToolbar : UIView
@property (nonatomic, strong, readonly) DZGrowTextView* textView;
@property (nonatomic, strong, readonly) UIButton* sendButton;
@end
