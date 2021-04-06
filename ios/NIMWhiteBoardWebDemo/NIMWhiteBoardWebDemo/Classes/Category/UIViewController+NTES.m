//
//  UIViewController+NTES.m
//  NIM
//
//  Created by chris on 15/12/17.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "UIViewController+NTES.h"

@implementation UIViewController (NTES)

- (void)useDefaultNavigationBar
{
    [self setNavigationBarBackgroundImage:nil];
}

- (void)setNavigationBarBackgroundImage:(UIImage *)image
{
    SEL sel = NSSelectorFromString(@"swizzling_changeNavigationBarBackgroundImage:");
    if ([self respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:image]);
    }
}

@end
