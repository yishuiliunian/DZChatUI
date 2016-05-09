//
//  DZChatMessageBaseCell.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//
#import <UIKit/UIKit.h>
#import <ElementKit/ElementKit.h>
#import "DZProgrameDefines.h"
@interface DZChatMessageBaseCell : EKAdjustTableViewCell
@property (nonatomic,strong) UILabel* nickLabel;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UIImageView* bubleImageView;
@end
