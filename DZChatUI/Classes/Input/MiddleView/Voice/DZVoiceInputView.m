//
//  DZVoiceInputView.m
//  Pods
//
//  Created by stonedong on 16/6/9.
//
//

#import "DZVoiceInputView.h"
#import "DZProgrameDefines.h"
#import "DZVoiceIndicatorView.h"
#import "DZVoiceIndicatorContentView.h"
#import <DZAudio/DZAudio.h>
#import <DZAlertPool/DZAlertPool.h>

@interface DZVoiceInputView () <K12AudioRecorderDelegate>
{
    UILabel* _textLabel;
    DZVoiceIndicatorView* _voiceIndicatorView;
    K12AudioRecorder* _audioRecorder;
    double _recordBeginTime;
    BOOL _isCanceled;
    CGFloat _duration;

}
@end

@implementation DZVoiceInputView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW_UILabel(_textLabel);
    _textLabel.text = @"按住 说话";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _isCanceled = NO;
    _textLabel.layer.cornerRadius = 8;
    _textLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textLabel.layer.borderWidth = 1;
    _textLabel.layer.masksToBounds = YES;
    _maxRecordTime = 60;
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}


- (void) startRecord
{
    if (!_voiceIndicatorView) {
        _voiceIndicatorView = [DZVoiceIndicatorView new];
        _voiceIndicatorView.contentView.maxPower = -20;
        _voiceIndicatorView.contentView.minPower = -60;
        
    }
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_voiceIndicatorView];
    _voiceIndicatorView.frame = window.bounds;
    _voiceIndicatorView.contentView.textLabel.text = @"手指上划，取消录音";
    //
    if (!_audioRecorder) {
        _audioRecorder = [[K12AudioRecorder alloc] init];
    }
    _audioRecorder.delegate = self;
    NSError* error;
    [_audioRecorder record:&error];
    _recordBeginTime = CFAbsoluteTimeGetCurrent();
    _voiceIndicatorView.contentView.type = DZVoiceIndicatorTypeNormal;
}

- (void) stopRecord
{
    [_audioRecorder stop];
    [_voiceIndicatorView removeFromSuperview];
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self startRecord];
    _isCanceled = NO;
    _textLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(_voiceIndicatorView.frame, point)) {
        _voiceIndicatorView.contentView.textLabel.text = @"手指上划，取消录音";
        _isCanceled = NO;
    } else {
        _voiceIndicatorView.contentView.textLabel.text = @"松开手指，取消录音";
        _isCanceled = YES;
    }
}
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self stopRecord];
    _textLabel.backgroundColor = [UIColor clearColor];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self stopRecord];
    _textLabel.backgroundColor = [UIColor clearColor];

}

- (void) k12AudioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}

- (void) k12AudioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (_duration < 2) {
        DZAlertHUDShowStatus(@"录音时间过短，不足2秒");
        return;
    }
    if (_isCanceled) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(voiceInputView:didFinishRecord:)]) {
        [self.delegate voiceInputView:self didFinishRecord:_audioRecorder];
    }
}
- (void) k12AudioRecorder:(AVAudioRecorder *)recorder recordingWithMeters:(double)meters
{
    _voiceIndicatorView.contentView.voicePower = meters;
    _duration = CFAbsoluteTimeGetCurrent() - _recordBeginTime;
    if (_duration > self.maxRecordTime) {
        [self stopRecord];
    } else {
        _voiceIndicatorView.contentView.lastTimeLabel.text = [NSString stringWithFormat:@"%d", self.maxRecordTime - (int)ceil(_duration)];
    }
    if (_duration > self.maxRecordTime - 10) {
        _voiceIndicatorView.contentView.type = DZVoiceIndicatorTypeLastTime;
    } else {
        _voiceIndicatorView.contentView.type = DZVoiceIndicatorTypeNormal;
    }
}
@end
