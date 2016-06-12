//
//  DZVoiceInputContentView.m
//  Pods
//
//  Created by stonedong on 16/5/9.
//
//

#import "DZVoiceIndicatorContentView.h"
#import "DZGeometryTools.h"
#import "DZProgrameDefines.h"
#import <DZAdjustFrame/DZAdjustFrame.h>
@implementation DZVoiceIndicatorContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW_UIImageView(_backgroundView);
    INIT_SELF_SUBVIEW_UILabel(_textLabel);
    INIT_SELF_SUBVIEW_UIImageView(_indicatorImageView);
    _backgroundView.alpha = 0.3;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.layer.cornerRadius = 4;
    _textLabel.textColor = [UIColor whiteColor];
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGSize imageSize = {100, 100};
    CGRect contentRect = CGRectCenterSubSize(self.bounds, CGSizeMake(20, 20));
    CGRect textRect;
    CGRect imageRect;
    
    CGRectDivide(contentRect, &textRect, &imageRect, 30, CGRectMaxYEdge);
    imageRect = CGRectCenter(imageRect, imageSize);
    
    _indicatorImageView.frame = imageRect;
    _textLabel.frame = textRect;
    
    _backgroundView.frame = self.bounds;
    
}

- (void) sizeToFit
{
    self.adjustHeight = 120;
}

@end
