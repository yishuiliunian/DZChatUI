//
//  DZAIOActionItemElement.m
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import <Foundation/Foundation.h>
#import "DZAIOActionItemElement.h"
#import "DZAIOActionItemCell.h"

@interface DZAIOActionItemElement ()
{
    UIImage* _titleImage;
    NSString* _title;
}
@end

@implementation DZAIOActionItemElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [DZAIOActionItemCell class];
    return self;
}

- (instancetype) initWithTitleImage:(UIImage *)image title:(NSString *)title
{
    self =[self init];
    if (!self) {
        return self;
    }
    _titleImage = image;
    _title = title;
    return self;
}

- (void) handleActionInViewController:(UIViewController*)vc
{
    
}
- (void) willBeginHandleResponser:(DZAIOActionItemCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.imageView.image = _titleImage;
    cell.textLabel.text = _title;
}

- (void) didBeginHandleResponser:(DZAIOActionItemCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(DZAIOActionItemCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(DZAIOActionItemCell *)cell
{
    [super didRegsinHandleResponser:cell];
}
@end