//
//  DZInputProtocol.h
//  Pods
//
//  Created by stonedong on 7/21/16.
//
//

#import <Foundation/Foundation.h>
typedef  NS_ENUM(NSInteger, DZAIOToolbarType)
{
    DZAIOToolbarTypeNormal,
    DZAIOToolbarTypeNone,
    DZAIOToolbarTypeEmoji,
};
@class DZInputViewController;
@class YHLocation;
@protocol DZInputProtocol <NSObject>
@property (nonatomic, weak) DZInputViewController* inputViewController;
@property (nonatomic, assign)DZAIOToolbarType  AIOToolbarType;
- (void) inputImage:(UIImage*)image;
- (void) inputVoice:(NSURL*)url;
- (void) inputText:(NSString*)text;
- (void) inputLocation:(YHLocation*)location;
@end
