//
//  DZEmojiCollectionViewCell.m
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import "DZEmojiCollectionViewCell.h"
#import "DZProgrameDefines.h"
#import <DZGeometryTools.h>
@implementation DZEmojiCollectionViewCell
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW_UIImageView(_emojiImageView);
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGSize imageSize = {25,25};
    _emojiImageView.frame = CGRectCenter(self.contentView.bounds, imageSize);
}
@end
