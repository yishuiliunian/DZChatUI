//
//  DZChatMessageBaseCell.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <Foundation/Foundation.h>
#import "DZChatMessageBaseCell.h"
#import "DZGeometryTools.h"

@implementation DZChatMessageBaseCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UIImageView(self.contentView, _avatarImageView);
    INIT_SUBVIEW_UIImageView(self.contentView, _bubleImageView);
    INIT_SUBVIEW_UILabel(self.contentView, _nickLabel);
    
#ifdef DEBUG
    _avatarImageView.backgroundColor = [UIColor redColor];
    _nickLabel.backgroundColor = [UIColor blueColor];
#endif
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}


@end