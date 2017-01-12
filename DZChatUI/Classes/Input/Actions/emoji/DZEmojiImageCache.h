//
//  DZEmojiImageCache.h
//  Pods
//
//  Created by baidu on 2017/1/12.
//
//

#import <Foundation/Foundation.h>

@interface DZEmojiImageCache : NSObject
+ (DZEmojiImageCache*) shareCache;
- (UIImage*) emojiImageWithFileName:(NSString*)key;
@end
