//
//  DZInputNoticeView.h
//  Pods
//
//  Created by stonedong on 16/8/13.
//
//

#import <UIKit/UIKit.h>

typedef void(^DZInputNoticeAction)(void);
@interface DZInputNoticeView : UIView
@property (nonatomic, assign ,readonly) CGSize contentSize;
@property (nonatomic, strong) DZInputNoticeAction action;
@end
