//
//  NMCWebView.h
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NMCWebView : WKWebView

- (instancetype)initWithFrame:(CGRect)frame scriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler;

@end

NS_ASSUME_NONNULL_END
