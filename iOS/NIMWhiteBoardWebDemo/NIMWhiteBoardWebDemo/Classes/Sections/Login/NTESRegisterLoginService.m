//
//  NTESRegisterLoginService.m
//  NIMWhiteBoardWebDemo
//
//  Created by taojinliang on 2021/1/13.
//

#import "NTESRegisterLoginService.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "NTESService.h"


@implementation NTESRegisterLoginService

+ (instancetype)sharedService
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

- (void)registerLoginCompletion:(NTESRegisterLoginHandler)completion {
    NTESRegisterData *data = [[NTESRegisterData alloc] init];
    data.account = [self getRandomStringWithNum:8];
    data.nickname= [self getRandomStringWithNum:10];
    data.token = [[self getRandomStringWithNum:6] tokenByPassword];

    NSLog(@"注册账号：%@", data.account);
    [[NTESDemoService sharedService] registerUser:data
                                       completion:^(NSError *error, NSString *errorMsg) {
                                           if (error == nil) {
                                               NSLog(@"注册账号成功！！！");
                                               NSString *loginAccount = data.account;
                                               NSString *loginToken   = data.token;
                                               
                                               [[[NIMSDK sharedSDK] loginManager] login:loginAccount
                                                                                  token:loginToken
                                                                             completion:^(NSError *error) {
                                                                                 if (error == nil)
                                                                                 {
                                                                                     NSLog(@"登录账号成功！！！");
                                                                                     NTESLoginData *sdkData = [[NTESLoginData alloc] init];
                                                                                     sdkData.account   = loginAccount;
                                                                                     sdkData.token     = loginToken;
                                                                                     [[NTESLoginManager sharedManager] setCurrentNTESLoginData:sdkData];
                                                                                     
                                                                                     [[NTESServiceManager sharedManager] start];
                                                                                     if (completion) {
                                                                                         completion(nil, @"");
                                                                                     }
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                     NSLog(@"登录账号失败！！！");
                                                                                     if (completion) {
                                                                                         completion(error, @"LoginError");
                                                                                     }
                                                                                 }
                                                                             }];
                                           }else{
                                               NSLog(@"注册账号失败！！！");
                                               if (completion) {
                                                   completion(error, @"RegisterError");
                                               }
                                           }
                                       }];
}
@end
