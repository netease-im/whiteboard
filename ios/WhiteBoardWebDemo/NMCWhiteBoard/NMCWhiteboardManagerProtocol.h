//
//  NMCWhiteboardManagerProtocol.h
//  BlockFo
//
//  Created by taojinliang on 2019/5/30.
//  Copyright © 2019 BlockFo. All rights reserved.
//

#ifndef NMCWhiteboardManagerProtocol_h
#define NMCWhiteboardManagerProtocol_h

#import <WebKit/WebKit.h>

@protocol NMCWhiteboardManagerDelegate <NSObject>

/**
 web页面加载完成
 */
- (void)onWebPageLoaded;

/**
 web创建白板房间成功,可以忽略
 */
- (void)onWebCreateWBSucceed;

/**
 web加入白板房间成功,可以忽略
 */
- (void)onWebJoinWBSucceed;

/**
 提示web加入白板房间的错误及原因
 
 @param code 错误码
 @param error 具体错误信息
 */
- (void)onWebJoinWBFailed:(NSInteger)code error:(NSString *)error;

/**
 提示web创建白板房间的错误及原因
 
 @param code 错误码
 @param error 具体错误信息
 */
- (void)onWebCreateWBFailed:(NSInteger)code error:(NSString *)error;

/**
 web离开白板房间
 */
- (void)onWebLeaveWB;

/**
 web发生了网络异常
 
 @param code 错误码
 @param error 具体错误信息
 */
- (void)onWebError:(NSInteger)code error:(NSString *)error;

/**
 web抛出Js错误
 
 @param error 具体错误信息
 */
- (void)onWebJsError:(NSString *)error;

/**
 web需要鉴权信息
 */
- (void)onWebGetAuth;

@end

@protocol NMCWhiteboardManagerWKDelegate <NSObject>

@optional
/*! @abstract Decides whether to allow or cancel a navigation.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)onDecidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
- (void)onDecidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;

@end

#endif /* NMCWhiteboardManagerProtocol_h */
