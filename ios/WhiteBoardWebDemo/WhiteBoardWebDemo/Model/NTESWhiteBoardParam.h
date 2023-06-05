//
//  NTESWhiteBoardParam.h
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/8.
//

#import <Foundation/Foundation.h>

@interface NTESWhiteBoardParam : NSObject

/// 房间名
@property (nonatomic, copy) NSString *channelName;

/// app key
@property (nonatomic, copy) NSString *appKey;

/// uid
@property (nonatomic, assign) NSUInteger uid;

/// web view url
@property (nonatomic, copy) NSString *webViewUrl;

@end
