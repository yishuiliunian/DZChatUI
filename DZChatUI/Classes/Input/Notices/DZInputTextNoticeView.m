//
//  DZInputTextNoticeView.m
//  Pods
//
//  Created by stonedong on 16/8/13.
//
//

#import "DZInputTextNoticeView.h"
#import <DZProgrameDefines.h>
#import <DZGeometryTools.h>
@interface DZInputTextNoticeView ()
{
    UILabel* _textLabel;
    UIImageView* _backgroundView;
}
@end

@implementation DZInputTextNoticeView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW_UIImageView(_backgroundView);
    _backgroundView.backgroundColor = [UIColor whiteColor];
    _backgroundView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _backgroundView.layer.shadowOffset = CGSizeMake(4, 5);
    _backgroundView.layer.shadowRadius = 3;
    _backgroundView.layer.shadowOpacity = 0.5;
    
    INIT_SELF_SUBVIEW_UILabel(_textLabel);
    _textLabel.textColor = [UIColor greenColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    
    return self;
}

- (void) setText:(NSString *)text
{
    _textLabel.text = text;
}

- (NSString*) text
{
    return _textLabel.text;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    _backgroundView.frame = self.bounds;
    _backgroundView.layer.cornerRadius = CGRectGetHeight(_backgroundView.frame)/2;
    _textLabel.frame = self.bounds;
}

- (CGSize) contentSize
{
    CGSize size = [_textLabel sizeThatFits:CGSizeMake(100, CGFLOAT_MAX)];
    size.height += 10;
    size.width += 20;
    return size;
}

@end
