//
//  NTESNavigationAnimator.h
//  NIM
//
//  Created by chris on 16/1/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NTESNavigationAnimationType) {
    NTESNavigationAnimationTypeNormal,
    NTESNavigationAnimationTypeCross,
};

@interface NTESNavigationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,weak)   UINavigationController *navigationController;

@property (nonatomic,assign) UINavigationControllerOperation currentOpearation;

@property (nonatomic,assign) NTESNavigationAnimationType animationType;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
