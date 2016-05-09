//
//  DZEmojiActionElement.m
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import "DZEmojiActionElement.h"
#import "DZEmojiItemElement.h"
@implementation DZEmojiActionElement

- (void) reloadData
{
    [_dataController addObject:[[DZEmojiItemElement alloc] initWithEmoji:@"x"]];
    [super reloadData];
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(44, 44);
}
@end
