//
//  NMCWhiteBoardManager.h
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "NMCWebLoginParam.h"
#import "NMCWhiteboardManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NMCWhiteBoardManager : NSObject

+ (instancetype)sharedManager;

- (void)configureDelegate:(id<NMCWhiteboardManagerDelegate>)delegate;

- (void)confiureWKDelegate:(id<NMCWhiteboardManagerWKDelegate>)wkDelegate;

- (WKWebView *)createWebViewWithFrame:(CGRect)frame;

/// 调用web登录，在页面加载完成之后执行
/// @param param 登录参数
- (void)callWebLoginWithParam:(NMCWebLoginParam *)param;

/// 调用web登出
- (void)callWebLogout;

/// 设置白板是否可以绘制
/// @param enable 是否可以绘制
- (void)callWebEnableDraw:(BOOL)enable;

/// 给web发送鉴权信息
/// @param appKey appKey
/// @param channelName channelName
/// @param userId userId
- (void)callWebSendAuthWithAppKey:(NSString*)appKey
                      channelName:(NSString*)channelName
                           userId:(NSUInteger)userId;

/// 给web发送防盗链信息
/// @param appKey appKey
/// @param bucketName bucketName
/// @param objectKey objectKey
/// @param url url
/// @param seqId seqId
/// @param timeStamp timeStamp
- (void)callWebSendAntiLeechInfoWithAppKey:(NSString*)appKey
                                bucketName:(NSString*)bucketName
                                 objectKey:(NSString*)objectKey
                                       url:(NSString*)url
                                     seqId:(NSInteger)seqId
                                 timeStamp:(NSString*)timeStamp;

@end

NS_ASSUME_NONNULL_END
