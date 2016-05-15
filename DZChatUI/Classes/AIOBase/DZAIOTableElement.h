//
//  DZAIOTableElement.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <ElementKit/ElementKit.h>
#import "DZInputToolbar.h"
@interface DZAIOTableElement : EKAdjustTableElement <DZInputToolbarDelegate>

- (void) handleLoadOldMessage;
- (void) scrollToEnd;
@end
