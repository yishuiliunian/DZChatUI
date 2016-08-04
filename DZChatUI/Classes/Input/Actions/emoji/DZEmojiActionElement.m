//
//  DZEmojiActionElement.m
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import "DZEmojiActionElement.h"
#import "DZEmojiItemElement.h"
#import "DZEmojiMapper.h"

@implementation DZEmojiActionElement
- (UICollectionViewLayout*) createCollectionLayout
{
    UICollectionViewFlowLayout* layout =  [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(35, 35);
}
- (void) reloadData
{
    [_dataController clean];
    NSDictionary* mapper =[DZEmojiMapper mapper].eomjiMapper;
    NSDictionary* indexMapper = [DZEmojiMapper mapper].indexMap;
    NSArray* allKeys = [DZEmojiMapper mapper].indexMap.allKeys;
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];

    for (NSString* key in allKeys) {
        NSString* emoji = indexMapper[key];
        DZEmojiItemElement* item = [[DZEmojiItemElement alloc] initWithEmoji:emoji image:mapper[emoji]];
        [_dataController addObject:item];
    }
    self.collectionView.pagingEnabled = YES;
    [super reloadData];
}

- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
    [self reloadData];
}
@end
