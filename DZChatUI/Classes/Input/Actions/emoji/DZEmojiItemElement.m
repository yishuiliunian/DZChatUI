//
//  DZEmojiItemElement.m
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import "DZEmojiItemElement.h"
#import "DZEmojiCollectionViewCell.h"
#import "DZEmojiImageCache.h"
@implementation DZEmojiItemElement
- (instancetype) initWithEmoji:(NSString *)emoji fileName:(NSString *)fileName
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [DZEmojiCollectionViewCell class];
    _emoji = emoji;
    _fileName = fileName;
    return self;
}

- (void) willBeginHandleResponser:(DZEmojiCollectionViewCell *)responser
{
    [super willBeginHandleResponser:responser];
    responser.emojiImageView.image = [[DZEmojiImageCache shareCache] emojiImageWithFileName:_fileName];
}
@end
