//
//  NMCWebViewDefine.h
//  BlockFo
//
//  Created by taojinliang on 2019/5/29.
//  Copyright © 2019 BlockFo. All rights reserved.
//

#ifndef NMCWebViewDefine_h
#define NMCWebViewDefine_h

#define NMCNativeMethodMessage @"NMCNativeMethodMessage"
#define NMCMethodAction @"action"
#define NMCMethodParam @"param"

#define NMCMethodParamCode @"code"
#define NMCMethodParamMsg @"msg"
#define NMCMethodParamEventName @"eventName"

//登录白板webView
#define NMCMethodActionWebLogin @"jsJoinWB"
//登出白板webView
#define NMCMethodActionWebLogout @"jsLeaveWB"
//发送鉴权信息
#define NMCMethodActionSendAuth @"jsSendAuth"
//发送防盗链信息
#define NMCMethodActionSendAntiLeechInfo @"jsSendAntiLeechInfo"

//设置JS调用命令
#define NMCMethodActionJSDirectCall @"jsDirectCall"
//绘制相关命令
#define NMCMethodTargetDrawPlugin @"drawPlugin"
#define NMCMethodTargetActionEnableDraw @"enableDraw"

//页面加载完成
#define NMCMethodActionWebPageLoaded @"webPageLoaded"

//创建房间成功
#define NMCMethodActionWebCreateWBSucceed @"webCreateWBSucceed"
//创建房间失败
#define NMCMethodActionWebCreateWBFailed @"webCreateWBFailed"
//加入房间成功
#define NMCMethodActionWebJoinWBSucceed @"webJoinWBSucceed"
//加入房间失败
#define NMCMethodActionWebJoinWBFailed @"webJoinWBFailed"

//一般是由于Native调用了jsLeaveWB，webView随之退出IM及白板信令，然后发送此消息给客户端
#define NMCMethodActionWebLeaveWB @"webLeaveWB"
//WebView中发生了网络异常
#define NMCMethodActionWebError @"webError"
//WebView抛出Js错误。客户端可以根据此消息调试
#define NMCMethodActionWebJSError @"webJsError"

//web需要鉴权信息
#define NMCMethodActionWebGetAuth @"webGetAuth"
//web需要防盗链信息
#define NMCMethodActionWebGetAntiLeechInfo @"webGetAntiLeechInfo"

#endif /* NMCWebViewDefine_h */
