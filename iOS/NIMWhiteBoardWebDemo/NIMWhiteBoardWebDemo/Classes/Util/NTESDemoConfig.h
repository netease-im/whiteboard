//
//  NTESDemoConfig.h
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESDemoConfig : NSObject
+ (instancetype)sharedConfig;

@property (nonatomic,copy)  NSString    *appKey;
@property (nonatomic,copy)  NSString    *apiURL;
@property (nonatomic,copy)  NSString    *apnsCername;
@property (nonatomic,copy)  NSString    *pkCername;

@property (nonatomic,copy)  NSString    *whiteBoardURL;

@end
