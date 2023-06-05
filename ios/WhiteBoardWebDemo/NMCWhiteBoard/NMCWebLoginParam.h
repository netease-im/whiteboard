//
//  NMCWebLoginParam.h
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import <Foundation/Foundation.h>

@interface NMCWebLoginParam : NSObject

/// 房间名
@property (nonatomic, copy) NSString *channelName;

/// app key
@property (nonatomic, copy) NSString *appKey;

/// uid
@property (nonatomic, assign) NSUInteger uid;

/// 是否服务端录制
@property (nonatomic, assign) BOOL record;

/// 是否开启 web 调试日志
@property (nonatomic, assign) BOOL debug;

@end
