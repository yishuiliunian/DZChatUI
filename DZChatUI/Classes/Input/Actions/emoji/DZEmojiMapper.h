//
//  YHEmojiMapper.h
//  YaoHe
//
//  Created by stonedong on 16/6/26.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZTextSimpleEmoticonParser.h"
@interface DZEmojiMapper : NSObject
@property (nonatomic, strong, readonly) NSDictionary* eomjiMapper;
@property (nonatomic, strong, readonly) DZTextSimpleEmoticonParser* textEmojiParser;
+ (DZEmojiMapper*)mapper;
@end
