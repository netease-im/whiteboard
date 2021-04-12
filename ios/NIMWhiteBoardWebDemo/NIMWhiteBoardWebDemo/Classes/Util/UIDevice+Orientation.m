//
//  UIDevice+Orientation.m
//  NIMWhiteBoardWebDemo
//
//  Created by taojinliang on 2020/12/30.
//

#import "UIDevice+Orientation.h"

@implementation UIDevice (Orientation)

+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:(int)interfaceOrientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

@end
