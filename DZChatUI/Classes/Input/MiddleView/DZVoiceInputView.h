//
//  DZVoiceInputView.h
//  Pods
//
//  Created by stonedong on 16/6/9.
//
//

#import "DZInputMiddleView.h"


#define kDZVoiceMaxLength 60

@class DZVoiceInputView;
@class K12AudioRecorder;
@protocol DZVoiceInputViewDelegate <NSObject>
- (void) voiceInputView:(DZVoiceInputView*)inputView didFinishRecord:(K12AudioRecorder*)recorder;
@end

@interface DZVoiceInputView : DZInputMiddleView
@property (nonatomic, weak) id<DZVoiceInputViewDelegate> delegate;
@end
