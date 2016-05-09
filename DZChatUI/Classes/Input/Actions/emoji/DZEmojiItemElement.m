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
- (instancetype) initWithEmoji:(NSString *)emoji
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [DZEmojiCollectionViewCell class];
    _emoji = emoji;
    return self;
}

- (void) willBeginHandleResponser:(DZEmojiCollectionViewCell *)responser
{
    [super willBeginHandleResponser:responser];
    responser.textLabel.text = _emoji;
}
@end
