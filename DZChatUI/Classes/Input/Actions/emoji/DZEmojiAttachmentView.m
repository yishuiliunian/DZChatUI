//
//  DZEmojiAttachmentView.m
//  Pods
//
//  Created by baidu on 2017/1/12.
//
//

#import "DZEmojiAttachmentView.h"
#import "DZImageCache.h"
#import "DZChatTools.h"
#import "DZEmojiImageCache.h"
@implementation DZEmojiAttachmentView

- (instancetype) initWithName:(NSString *)attachmentImageName
{
    self = [super init];
    if (!self) {
        return self;
    }
    _attachmentImageName = attachmentImageName;
    self.backgroundColor = [UIColor redColor];
    return self;
}

- (void) didMoveToSuperview
{
    [super didMoveToSuperview];
    if (_attachmentImageName == nil) {
        return;
    }
    self.image = [[DZEmojiImageCache shareCache] emojiImageWithFileName:_attachmentImageName];
}

@end
