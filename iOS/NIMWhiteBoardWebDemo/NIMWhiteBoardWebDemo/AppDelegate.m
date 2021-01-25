//
//  AppDelegate.m
//  NIMWhiteBoardWebDemo
//
//  Created by taojinliang on 2020/12/28.
//

#import "AppDelegate.h"
#import "NTESDemoConfig.h"
#import "NTESLoginManager.h"
#import "NTESPageContext.h"
#import "NTESLogManager.h"
#import "NTESService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *appKey = [[NTESDemoConfig sharedConfig] appKey];
    NSString *cerName= [[NTESDemoConfig sharedConfig] apnsCername];
    [[NIMSDK sharedSDK] registerWithAppID:appKey
                                  cerName:cerName];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [[NTESLogManager sharedManager] start];
    
    DDLogInfo(@"SDK Info: %@", [NIMSDKConfig sharedConfig]);
    
    [self setupMainViewController];
    
    return YES;
}


- (void)setupMainViewController
{
    NTESLoginData *data = [[NTESLoginManager sharedManager] currentNTESLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    if ([account length] && [token length])
    {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account
                                               token:token];
        [[NTESServiceManager sharedManager] start];
    }
    [[NTESPageContext sharedInstance] setupMainViewController];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape;
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
    }
}
@end
