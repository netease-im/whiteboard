//
//  NSDictionary+NERtcJson.m
//  NERtcSDK
//
//  Created by Simon Blue on 2020/4/13.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "NSDictionary+NERtcJson.h"


@implementation NSDictionary (NERtcJson)

- (NSData *)nertc_toJsonData
{
    NSData *data = nil;
    NSError *error = nil;
    data =[NSJSONSerialization dataWithJSONObject:self
                                          options:0
                                            error:&error];
    if (error)
    {
        NSLog(@"json parse error %@ for %@",error,self);
    }
    return data;
}

- (NSString *)nertc_toJsonString
{
    NSData *data = [self nertc_toJsonData];
    return data ? [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding] : nil;
}


@end
