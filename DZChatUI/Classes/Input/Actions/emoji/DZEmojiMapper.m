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
int const ConstEmoji[] =
{0x1f600, 0x1f601, 0x1f602, 0x1f603, 0x1f604, 0x1f605, 0x1f606,
    0x1f607, 0x1f608, 0x1f609, 0x1f60a, 0x1f60b, 0x1f60c, 0x1f60d,
    0x1f60e, 0x1f60f, 0x1f610, 0x1f611, 0x1f612, 0x1f613, 0x1f614,
    0x1f615, 0x1f616, 0x1f617, 0x1f618, 0x1f619, 0x1f61a, 0x1f61b,
    0x1f61c, 0x1f61d, 0x1f61e, 0x1f61f, 0x1f620, 0x1f621, 0x1f622};

@interface DZEmojiMapper  ()
{
    NSMutableDictionary* _mapper;
}
@end
@implementation DZEmojiMapper
+ (DZEmojiMapper*)mapper
{
    static DZEmojiMapper* mapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapper = [DZEmojiMapper new];
    });
    return mapper;
}

- (NSDictionary*) eomjiMapper
{
    return [_mapper copy];
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _mapper = [NSMutableDictionary new];
    for (int i = 0 ; i < sizeof(ConstEmoji)/sizeof(int); i++) {
        NSString* key = [NSString stringWithFormat:@"emoji_%d%d%d",(i/100)%10,(i/10)%10,i%10];
        NSString *originEmoji = [[NSString alloc] initWithBytes:&ConstEmoji[i] length:4 encoding:NSUTF32LittleEndianStringEncoding];
        UIImage* image = LoadPodImageWithStringName(key);
        if (image) {
            _mapper[originEmoji] = image;
        }
    }
    YYTextSimpleEmoticonParser* emojiParser = [[YYTextSimpleEmoticonParser alloc] init];
    emojiParser.emoticonMapper = [_mapper copy];
    _textEmojiParser = emojiParser;
    return self;
}

@end
