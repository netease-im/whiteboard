//
//  NMCWhiteBoardRequester.m
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2023/6/2.
//

#import "NMCWhiteBoardRequester.h"
#import "NSDictionary+NERtc.h"
#import "NSDictionary+NERtcJson.h"
#import "NMCWhiteBoardConfig.h"


@implementation NMCWhiteBoardAuthInfo

@end


@implementation NMCWhiteBoardAntiLeechInfo

@end


@interface NMCWhiteBoardRequester ()

@property (nonatomic, strong) NSURLSession* urlSession;

@end

@implementation NMCWhiteBoardRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return self;
}

- (void)dealloc {
    [_urlSession finishTasksAndInvalidate];
    _urlSession = nil;
}

- (void)requestAuthInfoWithAppKey:(NSString *)appKey roomId:(NSString *)roomId userId:(NSUInteger)userId completion:(void (^)(NSError *, NMCWhiteBoardAuthInfo *))completion {
    NSURL* url = [NSURL URLWithString:[kServerDomain stringByAppendingPathComponent:@"wb/getCheckSum"]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:appKey forKey:@"wbAppKey"];
    [params setObject:roomId forKey:@"roomId"];
    [params setObject:@(userId) forKey:@"uid"];
    [request setHTTPBody:[params nertc_toJsonData]];
    
    NSURLSessionTask* task = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
        if (connectionError) {
            if (completion) {
                completion(connectionError, nil);
            }
        }
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200 || !data) {
            if (completion) {
                NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:statusCode userInfo:nil];
                completion(error, nil);
            }
        }
        
        id tempData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (![tempData isKindOfClass:[NSDictionary class]]) {
            if (completion) {
                NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
                completion(error, nil);
            }
        }
        
        NSDictionary* resultDic = tempData;
        if (![resultDic objectForKey:@"code"]) {
            if (completion) {
                NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:-2 userInfo:nil];
                completion(error, nil);
            }
        }
        
        NSInteger code = [resultDic nertc_jsonInteger:@"code"];
        NMCWhiteBoardAuthInfo* info = [[NMCWhiteBoardAuthInfo alloc] init];
        info.code = code;
        if (code == 200) {
            NSDictionary* checksumData = [resultDic objectForKey:@"data"];
            info.nonce = [checksumData nertc_jsonString:@"wbNonce"];
            info.checksum = [checksumData nertc_jsonString:@"wbCheckSum"];
            info.curTime = [checksumData nertc_jsonString:@"wbCurtime"];
        }
        if (completion) {
            completion(nil, info);
        }
    }];
    
    [task resume];
}

- (void)requestAntiLeechInfoWithAppKey:(NSString*)appKey
                            bucketName:(NSString*)bucketName
                             objectKey:(NSString*)objectKey
                             timeStamp:(NSString*)timeStamp completion:(void(^)(NSError* error, NMCWhiteBoardAntiLeechInfo* info))completion {
    NSURL* url = [NSURL URLWithString:[kServerDomain stringByAppendingPathComponent:@"getWsSecret"]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:appKey forKey:@"wbAppKey"];
    [params setObject:bucketName forKey:@"bucketName"];
    [params setObject:objectKey forKey:@"objectKey"];
    [params setObject:timeStamp forKey:@"wsTime"];
    [request setHTTPBody:[params nertc_toJsonData]];
    
    NSURLSessionTask* task = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
        if (connectionError) {
            if (completion) {
                completion(connectionError, nil);
            }
        }
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200 || !data) {
            if (completion) {
                NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:statusCode userInfo:nil];
                completion(error, nil);
            }
        }
        
        id tempData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (![tempData isKindOfClass:[NSDictionary class]]) {
            if (completion) {
                NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
                completion(error, nil);
            }
        }
        
        NSDictionary* resultDic = tempData;
        if (![resultDic objectForKey:@"code"]) {
            if (completion) {
                NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:-2 userInfo:nil];
                completion(error, nil);
            }
        }
        
        NSInteger code = [resultDic nertc_jsonInteger:@"code"];
        NMCWhiteBoardAntiLeechInfo* info = [[NMCWhiteBoardAntiLeechInfo alloc] init];
        info.code = code;
        if (code == 200) {
            NSDictionary* checksumData = [resultDic objectForKey:@"data"];
            info.secret = [checksumData nertc_jsonString:@"wsSecret"];
        }
        if (completion) {
            completion(nil, info);
        }
    }];
    
    [task resume];
}

@end
