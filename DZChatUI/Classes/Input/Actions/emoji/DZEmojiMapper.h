//
//  YHEmojiMapper.h
//  YaoHe
//
//  Created by stonedong on 16/6/26.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYTextSimpleEmoticonParser;
@interface DZEmojiMapper : NSObject
@property (nonatomic, strong, readonly) NSDictionary* eomjiMapper;
@property (nonatomic, strong, readonly) YYTextSimpleEmoticonParser* textEmojiParser;
@property (nonatomic, strong, readonly) NSArray* allEmoji;
@property (nonatomic, strong, readonly) NSDictionary* indexMap;
+ (DZEmojiMapper*)mapper;
@end
