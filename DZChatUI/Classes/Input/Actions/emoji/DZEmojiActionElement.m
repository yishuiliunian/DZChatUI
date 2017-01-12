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
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 5;
    return layout;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40.0f, 35.0f);
}

- (void) reloadData
{
    [_dataController clean];
    NSDictionary* indexMapper = [DZEmojiMapper mapper].eomjiMapper;
    NSString* allKeys = [indexMapper keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];

    }];
    for (NSString* key in allKeys) {
        
        DZEmojiItemElement* item = [[DZEmojiItemElement alloc] initWithEmoji:key fileName:indexMapper[key]];
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
