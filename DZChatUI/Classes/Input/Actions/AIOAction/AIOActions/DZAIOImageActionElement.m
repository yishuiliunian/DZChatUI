//
//  DZAIOImageActionElement.m
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import "DZAIOImageActionElement.h"
#import <MobileCoreServices/MobileCoreServices.h>

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
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    _image = [self fixOrientation:image];
    [self.eventBus performSelector:@selector(imageElement:getImage:) withObject:self withObject:_image];
}
@end
