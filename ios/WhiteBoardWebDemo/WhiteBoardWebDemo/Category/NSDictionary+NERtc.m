//
//  NSDictionary+NERtc.m
//  NERtcSDK
//
//  Created by Sampson on 2019/4/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NSDictionary+NERtc.h"

@implementation NSDictionary (NERtc)

- (NSString *)nertc_jsonString:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    else if([object isKindOfClass:[NSNumber class]])
    {
        return [object stringValue];
    }
    return nil;
}

- (NSDictionary *)nertc_jsonDict:(NSString *)key
{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSDictionary class]] ? object : nil;
}


- (NSArray *)nertc_jsonArray:(NSString *)key
{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSArray class]] ? object : nil;
    
}

- (NSArray *)nertc_jsonStringArray:(NSString *)key
{
    NSArray *array = [self nertc_jsonArray:key];
    BOOL invalid = NO;
    for (id item in array)
    {
        if (![item isKindOfClass:[NSString class]])
        {
            invalid = YES;
        }
    }
    return invalid ? nil : array;
}

- (BOOL)nertc_jsonBool:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object boolValue];
    }
    return NO;
}

- (NSInteger)nertc_jsonInteger:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object integerValue];
    }
    return 0;
}

- (long long)nertc_jsonLongLong:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object longLongValue];
    }
    return 0;
}

- (int)nertc_jsonInt:(NSString *)key
{
    id object = self[key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object intValue];
    }
    return 0;
}

- (unsigned long long)nertc_jsonUnsignedLongLong:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object unsignedLongLongValue];
    }
    return 0;
}

- (unsigned int)nertc_jsonUnsignedInt:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object unsignedIntValue];
    }
    return 0;
}


- (double)nertc_jsonDouble:(NSString *)key{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object doubleValue];
    }
    return 0;
}

#pragma mark --

- (BOOL)nertc_checkBool:(NSString *)key {
    id object = self[key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)nertc_checkInteger:(NSString *)key {
    id object = self[key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)nertc_checkLongLong:(NSString *)key {
    id object = self[key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)nertc_checkInt:(NSString *)key {
    id object = self[key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)nertc_checkDouble:(NSString *)key {
    id object = self[key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)nertc_checkString:(NSString *)key {
    id object = self[key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    return NO;
}

@end

@implementation NSObject (nertc)

- (BOOL)nertc_Bool {
    id object = self;
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object boolValue];
    }
    return NO;
}

- (NSInteger)nertc_Integer {
    id object = self;
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object integerValue];
    }
    return 0;
}

- (long long)nertc_LongLong {
    id object = self;
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object longLongValue];
    }
    return 0;
}

- (unsigned long long)nertc_UnsignedLongLong {
    id object = self;
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object unsignedLongLongValue];
    }
    return 0;
}

- (int)nertc_Int {
    id object = self;
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object intValue];
    }
    return 0;
}

- (double)nertc_Double {
    id object = self;
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object doubleValue];
    }
    return 0;
}

- (NSString *)nertc_String {
    id object = self;
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    else if([object isKindOfClass:[NSNumber class]])
    {
        return [object stringValue];
    }
    return nil;
}

@end
