//
//  NTESDemoConfig.m
//  NERtcAudioChatroom
//
//  Created by Simon Blue on 2019/1/16.
//  Copyright © 2019年 netease. All rights reserved.
//

#import "NTESDemoConfig.h"

NSString *const kAppKey = @"a24e6c8a956a128bd50bdffe69b405ff";
NSString *const kApiHost = @"https://api.netease.im/nimserver/chatroom";

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
        _appKey = kAppKey;
        _apiURL = kApiHost;
        _whiteBoardURL = @"https://apptest.netease.im/webdemo/whiteboard/webview.html";
    }
    return self;
}

- (NSString *)appKey
{
    NSAssert((_appKey.length != 0), @"请填入APPKEY");
    return _appKey;
}

- (NSString *)apiURL
{
    NSAssert((_apiURL.length != 0), @"请填入APIURL");
    return _apiURL;
}

@end
