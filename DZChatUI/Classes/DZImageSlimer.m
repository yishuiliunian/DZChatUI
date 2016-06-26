//
//  DZImageSlimer.m
//  Pods
//
//  Created by stonedong on 16/6/23.
//
//

#import "DZImageSlimer.h"

@implementation DZImageSlimer


+ (UIImage*) slimImage:(UIImage*)image  aimDataLength:(int) aimLength
{
    CGFloat compressingQuality = 1.0;
    CGFloat compressDecreaseStep = 0.1;
    CGFloat lastLength = 0;
    CGSize size = image.size;
    BOOL willContinue = YES;
    
    CGFloat sizeSetp = 1.0;
    while (willContinue) {
        @autoreleasepool {

            CGFloat currentLength;
            @autoreleasepool {
                 NSData* data   = UIImageJPEGRepresentation(image, compressingQuality);
                currentLength = data.length;
                image = [UIImage imageWithData:data];
                currentLength = data.length;
            }
            if (ABS(currentLength - aimLength) > 100*1024) {
                if (ABS(floor(lastLength) - floor(currentLength)) < 100*1024) {
                    @autoreleasepool {
                        UIImage* resizeImage=nil;
                        sizeSetp -= 0.1;
                        CGSize aimSize = {size.width*sizeSetp, size.height* sizeSetp};
                        int slimDataLength = 0;
                        @autoreleasepool {
                            UIGraphicsBeginImageContext(aimSize);
                            [resizeImage drawInRect:CGRectMake(0,0,aimSize.width,aimSize.height)];
                            resizeImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            NSData* data = UIImageJPEGRepresentation(resizeImage, compressingQuality);
                            slimDataLength = data.length;
                        }
               
                        if (slimDataLength - aimLength < -50*1024) {
                            image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
                            break;
                        } else {
                            image = resizeImage;
                            lastLength = slimDataLength;
                        }
                    }
                }
                compressingQuality -= compressDecreaseStep;
                lastLength = currentLength;
            } else {
                image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
                break;
            }

        }
    }
    return image;
}
@end
