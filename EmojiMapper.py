# encoding:utf-8
import os
import json
import struct
import codecs
ConstEmoji = [0x1f60a, 0x1f60c, 0x1f61a, 0x1f613, 0x1f630, 0x1f61d, 0x1f601, 0x1f61c, 0x263a,0x1f609,
    0x1f60d, 0x1f614,0x1f604,0x1f60f, 0x1f612, 0x1f633, 0x1f618, 0x1f62d, 0x1f631,0x1f602,
    0x1f4aa, 0x1f44a, 0x1f44d, 0x261d, 0x1f44f, 0x270c, 0x1f44e, 0x1f64f, 0x1f44c,0x1f448,
    0x1f449,0x1f446, 0x1f447, 0x1f440, 0x1f443, 0x1f444, 0x1f442, 0x1f35a, 0x1f35d, 0x1f35c,
    0x1f359, 0x1f367, 0x1f363, 0x1f382, 0x1f35e,0x1f354, 0x1f373, 0x1f35f, 0x1f37a, 0x1f37b,
    0x1f378, 0x2615, 0x1f34e, 0x1f34a, 0x1f353, 0x1f349, 0x1f48a, 0x1f6ac, 0x1f384, 0x1f339,
    0x1f389,0x1f334, 0x1f49d, 0x1f380, 0x1f388, 0x1f41a, 0x1f48d, 0x1f4a3, 0x1f451, 0x1f514,
    0x2b50, 0x2728, 0x1f4a8, 0x1f4a6, 0x1f525, 0x1f3c6, 0x1f4b0,0x1f4a4, 0x26a1, 0x1f463,
    0x1f4a9, 0x1f489, 0x2668, 0x1f4eb, 0x1f511, 0x1f512, 0x2708, 0x1f684, 0x1f697, 0x1f6a4,
    0x1f6b2, 0x1f40e, 0x1f680,0x1f68c, 0x26f5, 0x1f469, 0x1f468, 0x1f467, 0x1f466, 0x1f435,
    0x1f419, 0x1f437, 0x1f480, 0x1f424, 0x1f428, 0x1f42e, 0x1f414, 0x1f438, 0x1f47b,0x1f41b,
    0x1f420, 0x1f436, 0x1f42f, 0x1f47c, 0x1f427, 0x1f433, 0x1f42d, 0x1f452, 0x1f457, 0x1f484,
    0x1f460, 0x1f462, 0x1f302, 0x1f45c, 0x1f459,0x1f455, 0x1f45f, 0x2601, 0x2600, 0x2614,
    0x1f319, 0x26c4, 0x2b55, 0x274c, 0x2754, 0x2755, 0x260e, 0x1f4f7, 0x1f4f1, 0x1f4e0,
    0x1f4bb, 0x1f3a5,0x1f3a4, 0x1f52b, 0x1f4bf, 0x1f493, 0x2663, 0x1f004, 0x303d, 0x1f3b0,
    0x1f6a5, 0x1f6a7, 0x1f3b8, 0x1f488, 0x1f6c0, 0x1f6bd, 0x1f3e0, 0x26ea,0x1f3e6, 0x1f3e5,
    0x1f3e8, 0x1f3e7, 0x1f3ea, 0x1f6b9, 0x1f6ba, 0xa9, 0xae, 0x2122, 0x26a0,
    0x26bd, 0x26c5, 0x26fa, 0x2705, 0x270a, 0x270b,0x2744, 0x3297, 0x1f197, 0x1f33c,
    0x1f340, 0x1f344, 0x1f347, 0x1f34c, 0x1f34d, 0x1f350, 0x1f366, 0x1f36d, 0x1f37c, 0x1f3ae,
    0x1f3b3, 0x1f3b5,0x1f3b9, 0x1f3bb, 0x1f3be, 0x1f3c0, 0x1f3ca, 0x1f409, 0x1f40d, 0x1f42c,
    0x1f47e,0x1f47f, 0x1f494, 0x1f4a2, 0x1f4af, 0x1f628, 0x1f4c9, 0x1f4cd,0x1f4de, 0x1f600,
    0x1f621, 0x1f603, 0x1f605, 0x1f606, 0x1f607, 0x1f608, 0x1f60b,
    0x1f60e, 0x1f610, 0x1f611, 0x1f615, 0x1f617, 0x1f619, 0x1f61b, 0x1f61e, 0x1f61f,
    0x1f620, 0x1f623, 0x1f624, 0x1f626, 0x1f627, 0x1f629, 0x1f62a, 0x1f62b, 0x1f62c, 0x1f62e,
    0x1f62f, 0x1f632, 0x1f635, 0x1f636, 0x1f637,0x1f616]
OutMapper = {}
IndexMapper = {}
emojiIndex = 0
totalMaxEmojiCount = 258
for index in range(0, len(ConstEmoji)):
    key = ConstEmoji[index]
    value = None
    while emojiIndex<= totalMaxEmojiCount:
        imageName = 'emoji_%d%d%d' % (emojiIndex/100%10, emojiIndex/10%10, emojiIndex %10)
        filePath = './DZChatUI/Assets/Emoji/%s.png' % (imageName)
        if os.path.exists(filePath):
            print '%s exists' % (imageName)
            emojiIndex += 1
            value = imageName
            break;
        emojiIndex += 1
    if imageName != None:
        OutMapper[key] = value


fo = codecs.open("./DZChatUI/Classes/Input/Actions/emoji/EmojisConst/EmojiConst.m", "wb+","utf-8")
out = "#import <Foundation/Foundation.h> \n"
out += " \n\
NSString* DZIntToEmoji(int32_t t) \n\
{\n\
    return [[NSString alloc] initWithBytes:&t length:4 encoding:NSUTF32LittleEndianStringEncoding];\n\
} \n\
\n\
NSDictionary* DZGlobalEmojiMapper() { \n\
    static NSString* mapper = nil; \n\
    static dispatch_once_t onceToken; \n\
    dispatch_once(&onceToken, ^{ "

out += "mapper = @{ \n"
for (k,v) in OutMapper.items():
    out += "\t\t DZIntToEmoji(%s):@\"%s\", \n" % (k, v)

out += "\t\t }; \n\
    }); \n\
    return mapper;\n\
}"

fo.write(out)
fo.close()
