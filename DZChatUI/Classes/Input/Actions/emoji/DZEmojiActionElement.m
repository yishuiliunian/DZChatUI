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

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(35, 35);
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
