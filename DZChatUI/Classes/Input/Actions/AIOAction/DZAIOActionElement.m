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

int const kDZPerRowCount = 4;


@interface DZAIOActionElement () <DZAIOImageActionEvents, DZAIOMapActionEvents>
{
    DZAIOImageActionElement* _imageItem;
    DZAIOImageActionElement* _camertaItem;
    DZAIOMapActionElement* _mapitem;
    CGSize _itemSize;
    NSArray* _actionItems;
}
@end
@implementation DZAIOActionElement


- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    width = (width - 11*5.f)/kDZPerRowCount;
    CGFloat height = width* 5.0f/kDZPerRowCount;
    _itemSize = CGSizeMake(width, height);
    
    
    _imageItem = [[DZAIOImageActionElement alloc] initWithTitleImage:LoadPodImage(actiion_image) title:@"照片"];
    _camertaItem = [[DZAIOImageActionElement alloc] initWithTitleImage:LoadPodImage(actiion_camera) title:@"相机"];
    _camertaItem.sourceType = UIImagePickerControllerSourceTypeCamera;
    _mapitem  = [[DZAIOMapActionElement alloc] initWithTitleImage:LoadPodImage(action_map) title:@"位置"];
    NSMutableArray* items = [NSMutableArray new];
    [items addObject:_imageItem];
    [items addObject:_camertaItem];
    [items addObject:_mapitem];
    _actionItems = items;
    
    return self;
}

- (CGFloat) preferHeight
{
    int row = (_actionItems.count)/kDZPerRowCount + 1;
    return _itemSize.height * row + _actionItems.count/kDZPerRowCount*10.0f;
}

- (void) reloadData
{
    [_dataController replaceObjects:_actionItems atSection:0];
    [super reloadData];
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DZAIOActionItemElement* ele = [_dataController objectAtIndexPath:EKIndexPathFromNS(indexPath)];
    [ele handleActionInViewController:self.uiEventPool];
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize;
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
