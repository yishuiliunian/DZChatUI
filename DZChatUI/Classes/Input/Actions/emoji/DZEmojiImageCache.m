//
//  DZEmojiImageCache.m
//  Pods
//
//  Created by baidu on 2017/1/12.
//
//

#import "DZEmojiImageCache.h"
#import "DZChatTools.h"
#import "DZImageCache.h"
@interface DZEmojiImageCache ()
{
    NSCache* _cache;
}
@end

@implementation DZEmojiImageCache
+ (DZEmojiImageCache*) shareCache
{
    static DZEmojiImageCache * shareCace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCace = [DZEmojiImageCache new];
    });
    return shareCace;
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _cache =[[NSCache alloc] init];
    return self;
}

- (UIImage*) emojiImageWithFileName:(NSString*)key
{
    if (!key) {
        return nil;
    }
    UIImage* image = [_cache objectForKey:key];
    if (image) {
        return image;
    }
    image = LoadPodImageWithStringName(key);
    if (image) {
        [_cache setObject:image forKey:key];
        return image;
    }
    image  = DZCachedImageByName(@"emoji_fallback");
    if (image) {
        [_cache setObject:image forKey:key];
        return image;
    }
    return nil;
}
@end
