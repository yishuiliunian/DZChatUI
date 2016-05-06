//
//  DZEmojiItemElement.m
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import "DZEmojiItemElement.h"

@implementation DZEmojiItemElement
- (instancetype) initWithImage:(UIImage*)image
{
    self = [super init];
    if (!self) {
        return self;
    }
    _image = image;
    return self;
}
@end
