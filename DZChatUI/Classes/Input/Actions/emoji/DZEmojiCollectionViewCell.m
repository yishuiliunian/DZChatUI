//
//  DZEmojiCollectionViewCell.m
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import "DZEmojiCollectionViewCell.h"

@implementation DZEmojiCollectionViewCell
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    _textLabel = [UILabel new];
    [self.contentView addSubview:_textLabel];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:30];
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.contentView.bounds;
}
@end
