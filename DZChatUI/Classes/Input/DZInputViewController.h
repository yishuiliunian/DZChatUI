//
//  DZInputViewController.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <DZKeyboardAdjust/DZKeyboardAdjust.h>
#import <ElementKit/ElementKit.h>
#import "DZInputProtocol.h"
#import "DZInputToolbar.h"

@class DZAIOViewController;
@class DZInputNoticeView;
@interface DZInputViewController : UIViewController
{
    @protected
    EKElement* _element;
}
@property (nonatomic, strong) DZInputNoticeView * inputNoticeView;
@property (nonatomic, strong, readonly) DZInputToolbar* toolbar;
@property (nonatomic, strong, readonly) UIImageView* backgroundImageView;
/**
 *  0 向下  1向上
 */
@property (nonatomic, assign) int scrollDirection;
- (instancetype) initWithElement:(EKElement*)ele contentViewController:(EKTableViewController*)viewController;

- (void) showTextInputWithPlaceholder:(NSString*)placeholder;

- (void) showNoticeView:(DZInputNoticeView*)inputNoticeView;
@end



