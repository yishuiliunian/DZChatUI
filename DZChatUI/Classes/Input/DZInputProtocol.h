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
@optional
@property (nonatomic, weak) DZInputViewController* inputViewController;
@optional
@property (nonatomic, assign)DZAIOToolbarType  AIOToolbarType;
@optional
- (void) inputImage:(UIImage*)image;
@optional

- (void) inputVoice:(NSURL*)url;
@optional

- (void) inputText:(NSString*)text;
@optional

- (void) inputLocation:(YHLocation*)location;
@end
