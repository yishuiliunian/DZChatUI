//
//  DZAIOTableElement.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <ElementKit/ElementKit.h>
#import "DZInputToolbar.h"
@class YHLocation;

typedef  NS_ENUM(NSInteger, DZAIOToolbarType)
{
    DZAIOToolbarTypeNormal,
    DZAIOToolbarTypeNone
};

@interface DZAIOTableElement : EKAdjustTableElement
@property (nonatomic, assign)DZAIOToolbarType  AIOToolbarType;
- (void) handleLoadOldMessage;
- (void) inputImage:(UIImage*)image;
- (void) inputVoice:(NSURL*)url;
- (void) inputText:(NSString*)text;
- (void) inputLocation:(YHLocation*)location;
@end
