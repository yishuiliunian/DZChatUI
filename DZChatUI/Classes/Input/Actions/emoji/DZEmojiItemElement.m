//
//  DZEmojiItemElement.m
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import "DZEmojiItemElement.h"
#import "DZEmojiCollectionViewCell.h"
@implementation DZEmojiItemElement
- (instancetype) initWithEmoji:(NSString *)emoji image:(UIImage *)image
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [DZEmojiCollectionViewCell class];
    _emoji = emoji;
    _image = image;
    return self;
}

- (void) willBeginHandleResponser:(DZEmojiCollectionViewCell *)responser
{
    [super willBeginHandleResponser:responser];
    responser.emojiImageView.image = _image;
}
@end
