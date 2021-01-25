//
//  NTESDemoService.h
//  NIM
//
//  Created by amao on 1/20/16.
//  Copyright © 2016 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESDemoRegisterTask.h"
#import "NTESDemoCreateMeetingTask.h"
#import "NTESDemoCloseMeetingTask.h"


@interface NTESDemoService : NSObject
+ (instancetype)sharedService;

- (void)registerUser:(NTESRegisterData *)data
          completion:(NTESRegisterHandler)completion;


- (void)requestChatRoom:(NSString *)name
             completion:(NTESCreateMeetingHandler)completion;

- (void)closeChatRoom:(NSString *)roomId
              creator:(NSString *)creator
           completion:(NTESCloseMeetingHandler)completion;

@end
