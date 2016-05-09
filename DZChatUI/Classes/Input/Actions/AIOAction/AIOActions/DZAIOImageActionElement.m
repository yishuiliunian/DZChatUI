//
//  DZAIOImageActionElement.m
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import "DZAIOImageActionElement.h"

@interface UIResponder (FindNavigation)
@property (nonatomic, strong, readonly) UINavigationController* hostNavigationController;
@end

@implementation UIResponder (FindNavigation)

- (UINavigationController*) hostNavigationController
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        return self;
    } else if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController* vc = (UIViewController*)self;
        UINavigationController* nav = [vc navigationController];
        if (nav) {
            return nav;
        } else
        {
            if (vc.parentViewController) {
                if (vc.parentViewController.navigationController) {
                    return vc.parentViewController.navigationController;
                } else {
                    return vc.parentViewController.hostNavigationController;
                }
            } else {
                return vc.view.superview.hostNavigationController;
            }
        }
    } else if ([self isKindOfClass:[UIView class]]) {
        if ([self.nextResponder isKindOfClass:[UIViewController class]]) {
            return [self.nextResponder hostNavigationController];
        } else if ([self.nextResponder isKindOfClass:[UIView class]]) {
            return [self.nextResponder.nextResponder hostNavigationController];
        }
    } else {
        return nil;
    }
}

@end

@interface DZAIOImageActionElement()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImage* _image;
}
@end

@implementation DZAIOImageActionElement

- (void) handleActionInViewController:(UIViewController *)vc
{
    UIImagePickerController* pickerVC = [[UIImagePickerController alloc]init];
    pickerVC.delegate = self;
    pickerVC.sourceType = self.sourceType;
    [self.hostViewController.hostNavigationController presentViewController:pickerVC animated:YES completion:^{
    }];
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    _image = image;
    [self.eventBus performSelector:@selector(imageElement:getImage:) withObject:self withObject:image];
}
@end
