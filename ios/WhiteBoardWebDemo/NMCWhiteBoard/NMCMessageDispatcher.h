//
//  NMCMessageDispatcher.h
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import <Foundation/Foundation.h>
#import "NMCWhiteboardManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NMCMessageDispatcher : NSObject

+ (instancetype)sharedDispatcher;

- (void)configureDelegate:(id<NMCWhiteboardManagerDelegate>)delegate;

- (void)nativeCallWebWithWebView:(WKWebView *)webview action:(NSString *)action param:(NSDictionary *)param;

- (void)webCallNativeWithWebView:(WKWebView *)webview action:(NSString *)action param:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
