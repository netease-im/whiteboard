//
//  NTESPageContex.m
//  NIMEducationDemo
//
//  Created by chris on 16/3/12.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESPageContext.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "NTESEnterRoomViewController.h"
#import "NTESLoginViewController.h"
#import "NTESNavigationHandler.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESRegisterLoginService.h"

@interface NTESPageContext()<NIMLoginManagerDelegate,NIMChatroomManagerDelegate>

@property (nonatomic,strong) NTESNavigationHandler *handler;

@end

@implementation NTESPageContext

+ (instancetype)sharedInstance
{
    static NTESPageContext *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESPageContext alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

- (void)setupMainViewController
{
    NTESLoginData *data = [[NTESLoginManager sharedManager] currentNTESLoginData];
    NSString *account = [data account];
    NSString *token   = [data token];
    UIViewController *vc;
    if ([account length] && [token length])
    {
        vc = [[NTESEnterRoomViewController alloc] initWithNibName:nil bundle:nil];
    }
    else
    {
        vc = [[NTESEnterRoomViewController alloc] initWithNibName:nil bundle:nil];
        
        [[NTESRegisterLoginService sharedService] registerLoginCompletion:^(NSError * _Nonnull error, NSString * _Nonnull errorMsg) {
            if (error == nil) {
                UIViewController *vc = [[NTESEnterRoomViewController alloc] initWithNibName:nil bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                self.handler = [[NTESNavigationHandler alloc] initWithNavigationController:nav];
//                nav.delegate = self.handler;
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            }else{
                NSLog(@"注册登录失败！！！");
            }
        }];
//        vc = [[NTESLoginViewController alloc] initWithNibName:nil bundle:nil];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    self.handler = [[NTESNavigationHandler alloc] initWithNavigationController:nav];
//    nav.delegate = self.handler;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
}


#pragma mark - NIMLoginManagerDelegate
- (void)onAutoLoginFailed:(NSError *)error
{
    //添加密码出错等引起的自动登录错误处理
    if ([error code] == NIMRemoteErrorCodeInvalidPass ||
        [error code] == NIMRemoteErrorCodeExist)
    {
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
            [[NTESLoginManager sharedManager] setCurrentNTESLoginData:nil];
            [self setupMainViewController];
        }];
    }
}

- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            reason = @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showAlertWithCompletionHandler:^(NSInteger index) {
            [[NTESLoginManager sharedManager] setCurrentNTESLoginData:nil];
            [self setupMainViewController];
        }];
    }];
}



@end
