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

@interface DZAIOActionItemCell ()
{
    UIImageView* _boardImageView;
}
@end

@implementation DZAIOActionItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UIImageView(self.contentView, _boardImageView);
    INIT_SUBVIEW_UILabel(self.contentView, _textLabel);
    INIT_SUBVIEW_UIImageView(self.contentView, _imageView);
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _boardImageView.layer.cornerRadius = 8;
    _boardImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _boardImageView.layer.borderWidth = 1;
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = {30, 3/4.0*30};
    CGRect contentRect = self.contentView.bounds;
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(10, 10));
    
    CGFloat labelHeight = 35;
    CGRect imageRect;
    CGRect labelRect;
    CGRectDivide(contentRect, &labelRect , &imageRect, labelHeight, CGRectMaxYEdge);
    
    _boardImageView.frame = CGRectCenter(imageRect, CGSizeMake(CGRectGetHeight(imageRect), CGRectGetHeight(imageRect)));
    _textLabel.frame = labelRect;
    _imageView.frame = CGRectCenter(imageRect, imageSize);
}


@end