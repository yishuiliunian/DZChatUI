//
//  DZInputActionElement.h
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import <ElementKit/ElementKit.h>

@class DZInputActionElement;
@class EKElement;
@protocol DZInputActionElementDelegate <NSObject>
- (void) actionElement:(DZInputActionElement*)element didSelectAction:(EKElement*)itemElement;
@end
@interface DZInputActionElement : EKCollectionElement
@property (nonatomic, assign, readonly) CGFloat preferHeight;
@property (nonatomic, weak) NSObject<DZInputActionElementDelegate>* delegate;
@end
