//
//  DZAIOMapActionElement.h
//  Pods
//
//  Created by stonedong on 16/6/18.
//
//

#import <DZChatUI/DZChatUI.h>
#import "DZAIOActionItemElement.h"

@class DZAIOMapActionElement;
@protocol DZAIOMapActionEvents <NSObject>
- (void) mapElementLocationReady:(DZAIOMapActionElement*)ele;
@end
@class YHLocation;
@interface DZAIOMapActionElement : DZAIOActionItemElement
@property (nonatomic, strong, readonly) YHLocation* location;
@end
