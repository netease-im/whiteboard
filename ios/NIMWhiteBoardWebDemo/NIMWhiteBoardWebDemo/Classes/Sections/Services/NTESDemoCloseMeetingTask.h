//
//  NTESDemoCloseMeetingTask.h
//  NIMEducationDemo
//
//  Created by fenric on 16/4/22.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESDemoServiceTask.h"

typedef void (^NTESCloseMeetingHandler)(NSError *error, NSString *roomId);

@interface NTESDemoCloseMeetingTask : NSObject<NTESDemoServiceTask>

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *creator;

@property (nonatomic,copy) NTESCloseMeetingHandler handler;

@end
