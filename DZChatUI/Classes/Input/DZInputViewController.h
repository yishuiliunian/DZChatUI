//
//  DZInputViewController.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <DZKeyboardAdjust/DZKeyboardAdjust.h>
#import <ElementKit/ElementKit.h>
#import "DZInputContentView.h"
@class DZAIOViewController;
@interface DZInputViewController : UIViewController
{
    @protected
    EKElement* _element;
}
- (instancetype) initWithElement:(EKElement*)ele contentViewController:(DZAIOViewController*)viewController;
@end



