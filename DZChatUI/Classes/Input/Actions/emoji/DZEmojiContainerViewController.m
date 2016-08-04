//
//  DZEmojiContainerViewController.m
//  Pods
//
//  Created by stonedong on 16/6/19.
//
//

#import "DZEmojiContainerViewController.h"

#import <DZGeometryTools.h>
#import "DZEmojiItemElement.h"

NSString* const kDZEmojiSendKey = @"发送Emoji";
@interface DZEmojiContainerViewController()

@property (nonatomic, strong, readonly) DZEmojiToolbar* toolbar;
@end

@implementation DZEmojiContainerViewController
@synthesize emojiViewController = _emojiViewController;
@synthesize toolbar  = _toolbar;
@synthesize emojiElement = _emojiElement;

- (DZEmojiActionElement*) emojiElement
{
    if (!_emojiElement) {
        _emojiElement = [DZEmojiActionElement new];
    }
    return _emojiElement;
}
- (DZInputActionViewController*) emojiViewController
{
    if (!_emojiViewController) {
        _emojiViewController = [[DZInputActionViewController alloc] initWithElement:self.emojiElement];
    }
    return _emojiViewController;
}
- (DZEmojiToolbar*) toolbar
{
    if (!_toolbar) {
        _toolbar = [DZEmojiToolbar new];
    }
    return _toolbar;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.emojiViewController willMoveToParentViewController:self];
    [self addChildViewController:self.emojiViewController];
    [self.view addSubview:self.emojiViewController.view];
    [self.emojiViewController didMoveToParentViewController:self];
    [self.view addSubview:self.toolbar];
    [self.toolbar.rightButton addTarget:self action:@selector(onHanldeSendEmoji) forControlEvents:UIControlEventTouchUpInside];
}

- (void) onHanldeSendEmoji
{
    DZEmojiItemElement* item =[[DZEmojiItemElement alloc]initWithEmoji:kDZEmojiSendKey image:nil];
    if ([self.emojiElement.delegate respondsToSelector:@selector(actionElement:didSelectAction:)]) {
        [self.emojiElement.delegate actionElement:self.emojiElement didSelectAction:item];
    }
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect emojiR;
    CGRect toolbarR;
    CGRectDivide(self.view.bounds, &toolbarR, &emojiR, 40, CGRectMaxYEdge);
    self.emojiViewController.view.frame = emojiR;
    self.toolbar.frame = toolbarR;
}


@end
