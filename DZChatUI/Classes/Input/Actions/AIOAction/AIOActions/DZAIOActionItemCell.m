//
//  DZAIOActionItemCell.m
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import <Foundation/Foundation.h>
#import "DZAIOActionItemCell.h"
#import "DZGeometryTools.h"
#import "DZProgrameDefines.h"
@implementation DZAIOActionItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UIImageView(self.contentView, _imageView);
    INIT_SUBVIEW_UILabel(self.contentView, _textLabel);
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(10, 10));
    
    CGFloat labelHeight = 35;
    CGRect imageRect;
    CGRect labelRect;
    CGRectDivide(contentRect, &labelRect , &imageRect, labelHeight, CGRectMinYEdge);
    
    _textLabel.frame = labelRect;
    _imageView.frame = imageRect;
}


@end