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
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(44, 44);
    layout.minimumInteritemSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    return layout;
}
- (void) reloadData
{
    [_dataController clean];
    NSDictionary* mapper =[DZEmojiMapper mapper].eomjiMapper;
    for (NSString* key in mapper.allKeys) {
        DZEmojiItemElement* item = [[DZEmojiItemElement alloc] initWithEmoji:key image:mapper[key]];
        [_dataController addObject:item];
    }
    self.collectionView.pagingEnabled = YES;
    [super reloadData];
}
@end
