//
//  DZAIOTableElement.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <ElementKit/ElementKit.h>
#import "DZInputToolbar.h"
@interface DZAIOTableElement : EKAdjustTableElement
- (void) handleLoadOldMessage;
- (void) inputImage:(UIImage*)image;
- (void) inputVoice:(NSURL*)url;
- (void) inputText:(NSString*)text;
@end
