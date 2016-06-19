//
//  DZVoiceIndicatorContentView
//  Pods
//
//  Created by stonedong on 16/5/9.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DZVoiceIndicatorType) {
   DZVoiceIndicatorTypeNormal,
    DZVoiceIndicatorTypeLastTime,
};;


@interface DZVoiceIndicatorContentView : UIView
@property (nonatomic, strong, readonly) UILabel* textLabel;
@property (nonatomic, strong, readonly) UIImageView* indicatorImageView;
@property (nonatomic, strong, readonly) UIImageView* backgroundView;
@property (nonatomic, strong, readonly) UILabel* lastTimeLabel;
@property (nonatomic, assign) CGFloat voicePower;
@property (nonatomic, assign) CGFloat maxPower;
@property (nonatomic, assign) CGFloat minPower;
@property (nonatomic, assign) DZVoiceIndicatorType type;

@end
