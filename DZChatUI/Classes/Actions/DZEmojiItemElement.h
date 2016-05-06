//
//  DZEmojiItemElement.h
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import <ElementKit/ElementKit.h>

@interface DZEmojiItemElement : EKCollectionCellElement
@property (nonatomic, strong, readonly) UIImage* image;
- (instancetype) initWithImage:(UIImage*)image;
@end
