//
//  NMCWhiteBoardRequester.h
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2023/6/2.
//

#import <Foundation/Foundation.h>


@interface NMCWhiteBoardAuthInfo : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString* nonce;
@property (nonatomic, copy) NSString* checksum;
@property (nonatomic, copy) NSString* curTime;

@end


@interface NMCWhiteBoardAntiLeechInfo : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString* secret;

@end


@interface NMCWhiteBoardRequester : NSObject

- (void)requestAuthInfoWithAppKey:(NSString*)appKey
                           roomId:(NSString*)roomId
                           userId:(NSUInteger)userId
                       completion:(void(^)(NSError* error, NMCWhiteBoardAuthInfo* info))completion;

- (void)requestAntiLeechInfoWithAppKey:(NSString*)appKey
                            bucketName:(NSString*)bucketName
                             objectKey:(NSString*)objectKey
                             timeStamp:(NSString*)timeStamp completion:(void(^)(NSError* error, NMCWhiteBoardAntiLeechInfo* info))completion;

@end
