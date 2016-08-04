//
//  DZInputActionElement.m
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import "DZInputActionElement.h"

@implementation DZInputActionElement


- (UICollectionViewLayout*) createCollectionLayout
{
    UICollectionViewFlowLayout* layout =  [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EKElement* ele = [_dataController objectAtIndexPath:EKIndexPathFromNS(indexPath)];
    if ([self.delegate respondsToSelector:@selector(actionElement:didSelectAction:)]) {
        [self.delegate actionElement:self didSelectAction:ele];
    }
}


@end
