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
/**
 *  下面两个属性方法不用去实现，核心机制会保证这个方法存在
 */
@property (nonatomic, weak) DZInputViewController* inputViewController;
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


@interface DZInputProtocolExtendPropertyLogic : NSObject
@property (nonatomic, weak) DZInputViewController* inputViewController;
@property (nonatomic, assign)DZAIOToolbarType  AIOToolbarType;
@end