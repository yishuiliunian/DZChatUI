//
//  DZAIOImageActionElement.h
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import "DZAIOActionItemElement.h"

@class DZAIOImageActionElement;
@protocol DZAIOImageActionEvents <NSObject>

- (void) imageElement:(DZAIOImageActionElement*)ele getImage:(UIImage*)image;

@end
@interface DZAIOImageActionElement : DZAIOActionItemElement
@property (nonatomic, strong, readonly) UIImage* image;
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
@end
