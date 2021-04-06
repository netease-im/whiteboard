//
//  NMCWhiteboardManager.h
//  BlockFo
//
//  Created by taojinliang on 2019/5/30.
//  Copyright © 2019 BlockFo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "NMCWebLoginParam.h"
#import "NMCWhiteboardManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NMCWhiteboardManager : NSObject

@property(nonatomic, weak) id<NMCWhiteboardManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (WKWebView *)createWebViewFrame:(CGRect)frame;

/**
 调用web登录，再页面加载之后

 @param loginParam 登录参数
 */
- (void)callWebLoginIM:(NMCWebLoginParam *)loginParam;

/**
 调用web退出登录，当不再使用白板之后
 */
- (void)callWebLogoutIM;

/**
 设置白板是否可以绘制

 @param enable 是否可用
 */
- (void)callEnableDraw:(BOOL)enable;

/**
 设置白板颜色

 @param color 白板颜色
 */
- (void)setWhiteboardColor:(NSString *)color;

@end

NS_ASSUME_NONNULL_END
