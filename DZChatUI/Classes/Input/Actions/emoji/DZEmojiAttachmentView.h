//
//  DZEmojiAttachmentView.h
//  Pods
//
//  Created by baidu on 2017/1/12.
//
//

#import <UIKit/UIKit.h>

@interface DZEmojiAttachmentView : UIImageView
@property (nonatomic, strong, readonly) NSString* attachmentImageName;
- (instancetype) initWithName:(NSString*)attachmentImageName;
@end
