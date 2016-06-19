//
//  DZEmojiActionElement.m
//  Pods
//
//  Created by baidu on 16/5/6.
//
//

#import "DZEmojiActionElement.h"
#import "DZEmojiItemElement.h"

 int const ConstEmoji[] =
    {0x1f600, 0x1f601, 0x1f602, 0x1f603, 0x1f604, 0x1f605, 0x1f606,
    0x1f607, 0x1f608, 0x1f609, 0x1f60a, 0x1f60b, 0x1f60c, 0x1f60d,
    0x1f60e, 0x1f60f, 0x1f610, 0x1f611, 0x1f612, 0x1f613, 0x1f614,
    0x1f615, 0x1f616, 0x1f617, 0x1f618, 0x1f619, 0x1f61a, 0x1f61b,
     0x1f61c, 0x1f61d, 0x1f61e, 0x1f61f, 0x1f620, 0x1f621, 0x1f622};
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
    for (int i = 0 ; i < sizeof(ConstEmoji)/sizeof(int); i++) {
        NSString *s = [[NSString alloc] initWithBytes:&ConstEmoji[i] length:4 encoding:NSUTF32LittleEndianStringEncoding];
        [_dataController addObject:[[DZEmojiItemElement alloc] initWithEmoji:s]];
    }
    self.collectionView.pagingEnabled = YES;
    [super reloadData];
}
@end
