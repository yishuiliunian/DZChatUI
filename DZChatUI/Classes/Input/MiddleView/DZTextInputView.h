//
//  DZTextInputView.h
//  Pods
//
//  Created by stonedong on 16/6/9.
//
//

#import "DZInputMiddleView.h"
#import <DZAdjustFrame/DZAdjustFrame.h>
#import "DZAlignTextView.h"
#import "YYText.h"
@interface DZTextInputView : DZInputMiddleView
@property (nonatomic, strong, readonly) YYTextView* textView;
@end
