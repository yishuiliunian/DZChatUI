//
//  DZEmojiItemElement.h
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import <ElementKit/ElementKit.h>

@interface DZEmojiItemElement : EKCollectionCellElement
@property (nonatomic, strong, readonly) NSString* emoji;
- (instancetype) initWithEmoji:(NSString*)emoji;
@end
