//
//  NSDictionary+NERtc.h
//  NERtcSDK
//
//  Created by Sampson on 2019/4/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (NERtc)

- (NSString *)nertc_jsonString:(NSString *)key;

- (NSDictionary *)nertc_jsonDict:(NSString *)key;
- (NSArray *)nertc_jsonArray:(NSString *)key;
- (NSArray *)nertc_jsonStringArray:(NSString *)key;


- (BOOL)nertc_jsonBool:(NSString *)key;
- (NSInteger)nertc_jsonInteger:(NSString *)key;
- (long long)nertc_jsonLongLong:(NSString *)key;
- (unsigned long long)nertc_jsonUnsignedLongLong:(NSString *)key;
- (unsigned int)nertc_jsonUnsignedInt:(NSString *)key;
- (int)nertc_jsonInt:(NSString *)key;

- (double)nertc_jsonDouble:(NSString *)key;

//
- (BOOL)nertc_checkBool:(NSString *)key;
- (BOOL)nertc_checkInteger:(NSString *)key;
- (BOOL)nertc_checkLongLong:(NSString *)key;
- (BOOL)nertc_checkInt:(NSString *)key;
- (BOOL)nertc_checkDouble:(NSString *)key;
- (BOOL)nertc_checkString:(NSString *)key;

@end

@interface NSObject (nertc)

- (BOOL)nertc_Bool;
- (NSInteger)nertc_Integer;
- (long long)nertc_LongLong;
- (unsigned long long)nertc_UnsignedLongLong;
- (int)nertc_Int;
- (double)nertc_Double;
- (NSString *)nertc_String;

@end

NS_ASSUME_NONNULL_END
