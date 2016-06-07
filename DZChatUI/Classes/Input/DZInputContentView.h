//
//  DZInputContentView.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <UIKit/UIKit.h>
#import "DZInputToolbar.h"
@interface DZInputContentView : UIView
@property (nonatomic, strong, readonly) DZInputToolbar* toolBar;
@property (nonatomic, strong, readonly) UIView* contentView;
@property (nonatomic, strong, readonly) UIView* functionView;
- (instancetype) initWithToolbar:(DZInputToolbar*)toolbar contentView:(UIView*)contentView;
@end
