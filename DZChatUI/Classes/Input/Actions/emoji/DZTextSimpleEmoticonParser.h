//
//  DZTextSimpleEmoticonParser.h
//  Pods
//
//  Created by baidu on 2017/1/12.
//
//

#import <Foundation/Foundation.h>
#import <YYText/YYText.h>
@interface DZTextSimpleEmoticonParser : NSObject<YYTextParser>

/**
 The custom emoticon mapper.
 The key is a specified plain string, such as @":smile:".
 The value is a UIImage which will replace the specified plain string in text.
 */
@property (nullable, copy) NSDictionary<NSString *, __kindof NSString *> *emoticonMapper;

@end
