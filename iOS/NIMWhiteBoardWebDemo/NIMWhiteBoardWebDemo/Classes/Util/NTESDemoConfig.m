//
//  NTESDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDemoConfig.h"

@interface NTESDemoConfig ()

@end

@implementation NTESDemoConfig
+ (instancetype)sharedConfig
{
    static NTESDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
#warning 注意说明：请使用自己应用的appKey和应用服务器地址apiURL
        _appKey = @"";
        _apiURL = @"";
        _apnsCername = @"ENTERPRISE";
        _pkCername = @"DEMO_PUSH_KIT";
        
        _whiteBoardURL = @"https://app.yunxin.163.com/webdemo/whiteboard/webview.html";
    }
    return self;
}

@end

