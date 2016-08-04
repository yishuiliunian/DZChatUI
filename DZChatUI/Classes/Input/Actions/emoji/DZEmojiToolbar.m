//
//  DZEmojiToolbar.m
//  Pods
//
//  Created by stonedong on 16/6/19.
//
//

#import "DZEmojiToolbar.h"
#import "DZProgrameDefines.h"
#import "DZEmojiGroupItemCell.h"
#import "DZGeometryTools.h"
#import "DZChatTools.h"
@interface DZEmojiToolbar () <UICollectionViewDataSource>
{
    UICollectionView* _collectionView;
    UIImageView* _backgroundImageView;
}
@end

@implementation DZEmojiToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW_UIImageView(_backgroundImageView);
    _backgroundImageView.image = LoadPodImage(InputToolBar);
    INIT_SUBVIEW_UIButton(self, _rightButton);
    UICollectionViewFlowLayout* flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(44, 44);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    _collectionView  = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    [_collectionView registerClass:[DZEmojiGroupItemCell class] forCellWithReuseIdentifier:@"DZEmojiGroupItemCell"];
    [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if (CGRectIsEmpty(self.bounds)) {
        _rightButton.frame = CGRectZero;
        _backgroundImageView.frame = CGRectZero;
        _collectionView.frame = CGRectZero;
        return;
    }
    CGRect contentRect = CGRectCenterSubSize(self.bounds, CGSizeMake(20, 10));
    CGSize buttonSize = {50,CGRectGetHeight(self.bounds) - 10};
    
    CGRect btnRect;
    CGRect collectionRect;
    CGRectDivide(contentRect, &btnRect, &collectionRect, buttonSize.width, CGRectMaxXEdge);
    
    btnRect = CGRectCenter(btnRect, buttonSize);
    
    _rightButton.frame = btnRect;
    _collectionView.frame = collectionRect;
    _backgroundImageView.frame = self.bounds;
    
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DZEmojiGroupItemCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DZEmojiGroupItemCell" forIndexPath:indexPath];
    return cell;
}



@end
