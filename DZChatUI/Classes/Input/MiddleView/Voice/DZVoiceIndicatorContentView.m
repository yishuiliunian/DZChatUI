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
#import "DZChatTools.h"

@interface DZVoiceIndicatorContentView ()
DEFINE_PROPERTY_STRONG_UIImageView(powerImageView);
@end

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
    INIT_SELF_SUBVIEW_UIImageView(_powerImageView);
    INIT_SELF_SUBVIEW_UILabel(_lastTimeLabel);
    _backgroundView.alpha = 0.3;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.layer.cornerRadius = 4;
    _textLabel.textColor = [UIColor whiteColor];
    _indicatorImageView.image = LoadPodImage(voice_indicator);
    [self setVoicePower:0];
    //
    _lastTimeLabel.textAlignment = NSTextAlignmentCenter;
    _lastTimeLabel.textColor = [UIColor whiteColor];
    _lastTimeLabel.font = [UIFont boldSystemFontOfSize:60];
    [self setType:DZVoiceIndicatorTypeNormal];
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGSize imageSize = {62*2, 84};
    CGRect contentRect = CGRectCenterSubSize(self.bounds, CGSizeMake(20, 20));
    CGRect textRect;
    CGRect imageRect;
    
    CGRectDivide(contentRect, &textRect, &imageRect, 30, CGRectMaxYEdge);
    imageRect = CGRectCenter(imageRect, imageSize);
    
    CGRect imgRs[2];
    CGRectHorizontalSplit(imageRect, imgRs, 2, 0);
    _indicatorImageView.frame = imgRs[0];
    _powerImageView.frame = imgRs[1];
    _textLabel.frame = textRect;
    _backgroundView.frame = self.bounds;
    _lastTimeLabel.frame = imageRect;
}

- (void) setType:(DZVoiceIndicatorType)type
{
    switch (type) {
        case DZVoiceIndicatorTypeNormal:
        {
            _lastTimeLabel.hidden = YES;
            _indicatorImageView.hidden = NO;
            _powerImageView.hidden = NO;
        }
            break;
        case DZVoiceIndicatorTypeLastTime:
        {
            _lastTimeLabel.hidden = NO;
            _indicatorImageView.hidden = YES;
            _powerImageView.hidden = YES;
        }
            
        default:
            break;
    }
}

- (void) setVoicePower:(CGFloat)voicePower
{
    _voicePower = voicePower;
    __block NSString* powerName = nil;
    void (^SetPowerImageName)(int) = ^(int count) {
        powerName  = [NSString stringWithFormat:@"voice_power_%d",count];
    };
    if (self.maxPower - self.minPower > 0) {
        int imageCount = 6;
        double powerAverage = (self.maxPower - self.minPower) /imageCount ;
        if (_voicePower < self.minPower ) {
            SetPowerImageName(0);
        } else {
            for (int i = 0; i < imageCount; i++) {
                double currentP = self.minPower + i*powerAverage;
                
                if (i< imageCount - 1) {
                    double nextP = self.minPower + (i+1)*powerAverage;
                    if (voicePower > self.minPower && voicePower < nextP) {
                        SetPowerImageName(i);
                        break;
                    }
                } else {
                    SetPowerImageName(i);
                }
            }
        }
  
    } else {
        SetPowerImageName(0);
    }
    _powerImageView.image = LoadPodImageWithStringName(powerName);
    
}


- (void) sizeToFit
{
    self.adjustHeight = 120;
}

@end
