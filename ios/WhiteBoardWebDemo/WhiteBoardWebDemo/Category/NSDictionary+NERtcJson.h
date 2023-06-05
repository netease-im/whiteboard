//
//  NSDictionary+NERtcJson.h
//  NERtcSDK
//
//  Created by Simon Blue on 2020/4/13.
//  Copyright © 2020 Netease. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (NERtcJson)

- (NSData *)nertc_toJsonData;

- (NSString *)nertc_toJsonString;

@end

NS_ASSUME_NONNULL_END
