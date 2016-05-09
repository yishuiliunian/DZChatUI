//
//  DZVoiceInputView.m
//  Pods
//
//  Created by stonedong on 16/5/9.
//
//

#import "DZVoiceInputView.h"
#import "DZGeometryTools.h"
#import "DZProgrameDefines.h"
#import <DZAdjustFrame/DZAdjustFrame.h>
@implementation DZVoiceInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW(DZVoiceInputContentView, _contentView);
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGSize contentSize = {180, 180};
    _contentView.frame = CGRectCenter(self.bounds, contentSize);
}

@end
