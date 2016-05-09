//
//  DZAIOActionItemElement.h
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import <ElementKit/ElementKit.h>


@interface DZAIOActionItemElement : EKCollectionCellElement
- (instancetype) initWithTitleImage:(UIImage*)image title:(NSString*)title;
- (void) handleActionInViewController:(UIViewController*)vc;
@end
