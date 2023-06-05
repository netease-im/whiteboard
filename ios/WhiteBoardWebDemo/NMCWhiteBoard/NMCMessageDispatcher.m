//
//  NMCMessageDispatcher.m
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import "NMCMessageDispatcher.h"
#import "NMCWebViewDefine.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

@interface NMCMessageDispatcher ()

@property (nonatomic, weak) id<NMCWhiteboardManagerDelegate> delegate;

@property (nonatomic, strong) DDFileLogger *fileLogger;

@end

@implementation NMCMessageDispatcher

+ (instancetype)sharedDispatcher {
    static NMCMessageDispatcher *messageDispatcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageDispatcher = [[NMCMessageDispatcher alloc] init];
        [DDLog addLogger:messageDispatcher.fileLogger];
    });
    
    return messageDispatcher;
}

- (void)configureDelegate:(id<NMCWhiteboardManagerDelegate>)delegate {
    _delegate = delegate;
}

- (void)nativeCallWebWithWebView:(WKWebView *)webview action:(NSString *)action param:(NSDictionary *)param {
    DDLogInfo(@"[webview] native call web ---> action : %@, param : %@", action, param);
    NSLog(@"[webview] native call web ---> action : %@, param : %@", action, param);
    
    if (!action || action.length == 0 ) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:action forKey:NMCMethodAction];
    if (param && param.count > 0) {
        [dict setObject:param forKey:NMCMethodParam];
    }
    
    NSString *bridgeObj = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL] encoding:NSUTF8StringEncoding];
    NSString *callWebString = [NSString stringWithFormat:@"window.WebJSBridge('%@')", bridgeObj];
    
    if ([[NSThread currentThread] isMainThread]) {
        [webview evaluateJavaScript:callWebString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            if (error) {
                NSLog(@"[webview] error = %@",error);
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [webview evaluateJavaScript:callWebString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"[webview] error = %@",error);
                }
            }];
        });
    }
}

- (void)webCallNativeWithWebView:(WKWebView *)webview action:(NSString *)action param:(NSDictionary *)param {
    DDLogInfo(@"[webview] web call native ---> action : %@, param : %@", action, param);
    NSLog(@"[webview] web call native ---> action : %@, param : %@", action, param);
    
    if ([action isEqualToString:NMCMethodActionWebPageLoaded]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebPageLoaded)]) {
            [_delegate onWebPageLoaded];
        }
    } else if ([action isEqualToString:NMCMethodActionWebCreateWBSucceed]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebCreateWBSucceed)]) {
            [_delegate onWebCreateWBSucceed];
        }
    } else if ([action isEqualToString:NMCMethodActionWebJoinWBSucceed]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebJoinWBSucceed)]) {
            [_delegate onWebJoinWBSucceed];
        }
    } else if ([action isEqualToString:NMCMethodActionWebJoinWBFailed]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebJoinWBFailed:error:)]) {
            [_delegate onWebJoinWBFailed:[param[NMCMethodParamCode] integerValue] error:param[NMCMethodParamMsg]];
        }
    } else if ([action isEqualToString:NMCMethodActionWebCreateWBFailed]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebCreateWBFailed:error:)]) {
            [_delegate onWebCreateWBFailed:[param[NMCMethodParamCode] integerValue] error:param[NMCMethodParamMsg]];
        }
    } else if ([action isEqualToString:NMCMethodActionWebLeaveWB]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebLeaveWB)]) {
            [_delegate onWebLeaveWB];
        }
    } else if ([action isEqualToString:NMCMethodActionWebError]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebError:error:)]) {
            [_delegate onWebError:[param[NMCMethodParamCode] integerValue] error:param[NMCMethodParamMsg]];
        }
    } else if ([action isEqualToString:NMCMethodActionWebJSError]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebJsError:)]) {
            [_delegate onWebJsError:param[NMCMethodParamMsg]];
        }
    } else if ([action isEqualToString:NMCMethodActionWebGetAuth]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebGetAuth)]) {
            [_delegate onWebGetAuth];
        }
    } else if ([action isEqualToString:NMCMethodActionWebGetAntiLeechInfo]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onWebGetAntiLeechInfoWithParams:)]) {
            [_delegate onWebGetAntiLeechInfoWithParams:param];
        }
    }
}

- (DDFileLogger *)fileLogger {
    if (!_fileLogger) {
        NSString *logFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        id<DDLogFileManager> fileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logFilePath];
        
        // 1、每次启动App时生成新的日志文件
        // 2、日志文件不设置个数上限
        // 3、每个日志文件的有效期为3天
        // 4、web->native 和 native->web 的内容全都记录
        _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
        _fileLogger.rollingFrequency = 60 * 60 * 24 * 3; // 3天
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 0;
        _fileLogger.doNotReuseLogFiles = YES;
    }
    
    return _fileLogger;
}

@end
