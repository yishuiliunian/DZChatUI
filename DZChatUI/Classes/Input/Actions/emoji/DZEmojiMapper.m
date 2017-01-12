//
//  YHEmojiMapper.m
//  YaoHe
//
//  Created by stonedong on 16/6/26.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "DZEmojiMapper.h"
#import "DZImageCache.h"
#import "YYText.h"
#import "DZChatTools.h"

extern NSDictionary* DZGlobalEmojiMapper();

@implementation DZEmojiMapper
@synthesize eomjiMapper = _eomjiMapper;
+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self mapper];
    });
}
+ (DZEmojiMapper*)mapper
{
    static DZEmojiMapper* mapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapper = [DZEmojiMapper new];
    });
    return mapper;
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();

    _eomjiMapper = DZGlobalEmojiMapper();
    
    DZTextSimpleEmoticonParser* emojiParser = [[DZTextSimpleEmoticonParser alloc] init];
    emojiParser.emoticonMapper = [_eomjiMapper copy];
    _textEmojiParser = emojiParser;
    NSLog(@"Cost %f", CFAbsoluteTimeGetCurrent() - start);
    return self;
}


@end
