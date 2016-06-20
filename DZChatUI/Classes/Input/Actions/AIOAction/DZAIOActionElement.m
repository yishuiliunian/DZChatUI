//
//  DZAIOActionElement.m
//  Pods
//
//  Created by stonedong on 16/5/8.
//
//

#import "DZAIOActionElement.h"
#import "DZAIOActionItemElement.h"
#import "DZAIOImageActionElement.h"
#import "DZChatTools.h"
#import "DZAIOMapActionElement.h"
#define LoadPodImage(name)   [UIImage imageNamed:@"DZChatUI.bundle/"#name inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]


@interface DZAIOActionElement () <DZAIOImageActionEvents, DZAIOMapActionEvents>
{
    DZAIOImageActionElement* _imageItem;
    DZAIOImageActionElement* _camertaItem;
    DZAIOMapActionElement* _mapitem;
}
@end
@implementation DZAIOActionElement

- (void) reloadData
{
    _imageItem = [[DZAIOImageActionElement alloc] initWithTitleImage:LoadPodImage(actiion_image) title:@"照片"];
    _camertaItem = [[DZAIOImageActionElement alloc] initWithTitleImage:LoadPodImage(actiion_camera) title:@"相机"];
    _mapitem  = [[DZAIOMapActionElement alloc] initWithTitleImage:LoadPodImage(action_map) title:@"位置"];
    _camertaItem.sourceType = UIImagePickerControllerSourceTypeCamera;
    [_dataController clean];
    [_dataController addObject:_imageItem];
    [_dataController addObject:_camertaItem];
    [_dataController addObject:_mapitem];
    
    [super reloadData];
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DZAIOActionItemElement* ele = [_dataController objectAtIndexPath:EKIndexPathFromNS(indexPath)];
    [ele handleActionInViewController:self.uiEventPool];
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 100);
}


- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
    [self.eventBus addHandler:self priority:1.0 port:@selector(imageElement:getImage:)];
    [self.eventBus addHandler:self priority:1.0 port:@selector(mapElementLocationReady:)];
}

- (void) imageElement:(DZAIOImageActionElement *)ele getImage:(UIImage *)image
{
    if ([self.delegate respondsToSelector:@selector(actionElement:didSelectAction:)]) {
        [self.delegate actionElement:self didSelectAction:ele];
    }
}

- (void) mapElementLocationReady:(DZAIOMapActionElement *)ele
{
    if ([self.delegate respondsToSelector:@selector(actionElement:didSelectAction:)]) {
        [self.delegate actionElement:self didSelectAction:ele];
    }
}

- (void) didRegsinHandleResponser:(UIResponder *)responser
{
    [super didRegsinHandleResponser:responser];
}
@end
