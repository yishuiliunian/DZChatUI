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

@interface DZVoiceInputView () <K12AudioRecorderDelegate>
{
    UILabel* _textLabel;
    DZVoiceIndicatorView* _voiceIndicatorView;
    K12AudioRecorder* _audioRecorder;
    double _recordBeginTime;

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
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(_voiceIndicatorView.frame, point)) {
        _voiceIndicatorView.contentView.textLabel.text = @"手指上划，取消录音";
    } else {
        _voiceIndicatorView.contentView.textLabel.text = @"松开手指，取消录音";
    }
}
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self stopRecord];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self stopRecord];
}

- (void) k12AudioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}

- (void) k12AudioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if ([self.delegate respondsToSelector:@selector(voiceInputView:didFinishRecord:)]) {
        [self.delegate voiceInputView:self didFinishRecord:_audioRecorder];
    }
}
@end
