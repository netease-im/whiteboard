//
//  NTESLogManager.m
//  NIM
//
//  Created by Xuhui on 15/4/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESLogManager.h"
#import "NTESLogViewController.h"
#import <NIMSDK/NIMSDK.h>

@interface NTESLogManager () {
    DDFileLogger *_fileLogger;
}

@end

@implementation NTESLogManager

+ (instancetype)sharedManager
{
    static NTESLogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESLogManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagDebug];
        NSString *logDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        id<DDLogFileManager> fileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logDir];
        _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:_fileLogger];
    }
    return self;
}

- (void)start
{
    DDLogInfo(@"App Started SDK Version %@\n",[[NIMSDK sharedSDK] sdkVersion]);
}

- (UIViewController *)demoLogViewController {
    NSString *filepath = _fileLogger.currentLogFileInfo.filePath;
    NTESLogViewController *vc = [[NTESLogViewController alloc] initWithFilepath:filepath];
    vc.title = @"Demo Log";
    return vc;
}

- (UIViewController *)sdkLogViewController
{
    NSString *filepath = [[NIMSDK sharedSDK] currentLogFilepath];
    NTESLogViewController *vc = [[NTESLogViewController alloc] initWithFilepath:filepath];
    vc.title = @"SDK Log";
    return vc;
}

- (NSString *)currentLogPath
{
    return _fileLogger.currentLogFileInfo.filePath;
}

@end
