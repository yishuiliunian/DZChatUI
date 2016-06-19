//
//  DZChatTools.h
//  Pods
//
//  Created by stonedong on 16/6/18.
//
//

#import <Foundation/Foundation.h>
#define LoadPodImage(name)   [UIImage imageNamed:@"DZChatUI.bundle/"#name inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]

#define LoadPodImageWithStringName(name)   [UIImage imageNamed:[NSString stringWithFormat:@"DZChatUI.bundle/%@",name] inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]
