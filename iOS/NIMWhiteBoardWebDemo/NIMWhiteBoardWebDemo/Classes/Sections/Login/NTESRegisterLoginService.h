//
//  NTESRegisterLoginService.h
//  NIMWhiteBoardWebDemo
//
//  Created by taojinliang on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import "NTESDemoService.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^NTESRegisterLoginHandler)(NSError *error,NSString *errorMsg);

@interface NTESRegisterLoginService : NSObject
+ (instancetype)sharedService;

- (void)registerLoginCompletion:(NTESRegisterLoginHandler)completion;
@end

NS_ASSUME_NONNULL_END
