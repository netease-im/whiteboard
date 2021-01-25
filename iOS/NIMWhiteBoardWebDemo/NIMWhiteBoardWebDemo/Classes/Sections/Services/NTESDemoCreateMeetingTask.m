//
//  NTESDemoCreateMeetingTask.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/12.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESDemoCreateMeetingTask.h"
#import "NTESDemoConfig.h"
#import "NSDictionary+NTESJson.h"

#define NTESDemoCreateMeetingKeyCreator              @"creator"
#define NTESDemoCreateMeetingKeyMeetingName          @"name"
#define NTESDemoCreateMeetingKeyMeetingAnnouncement  @"announcement"
#define NTESDemoCreateMeetingKeyExt                  @"ext"
#define NTESDemoCreateMeetingKeyMeeting              @"meeting"



@implementation NTESDemoCreateMeetingTask

- (NSURLRequest *)taskRequest
{
    
    if (![self validate]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSError *error = [NSError errorWithDomain:@"ntes domain"
                                                 code:NIMLocalErrorCodeInvalidParam
                                             userInfo:nil];
            
            self.handler(error,nil);
        });
        return nil;

    }
    
    NSString *urlString = [[[NTESDemoConfig sharedConfig] apiURL] stringByAppendingString:@"/chatroom/create"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30];
    [request setHTTPMethod:@"Post"];
    
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appKey"];
    
    NSData *data = [self encodedBody];
    
    [request setHTTPBody:data];
    
    return request;
}

- (BOOL)validate
{
    return self.meetingName.length;
}

- (NSData *)encodedBody
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];

    [dict setObject:currentUserId forKey:NTESDemoCreateMeetingKeyCreator];
    
    if (self.meetingName.length) {
        [dict setObject:self.meetingName forKey:NTESDemoCreateMeetingKeyMeetingName];
    }
    
    NSDictionary *ext = @{
                          NTESDemoCreateMeetingKeyMeeting : self.meetingName,
                          };
    
    NSString *extString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:ext options:0 error:nil]
                                                encoding:NSUTF8StringEncoding];
    
    [dict setObject:extString
             forKey:NTESDemoCreateMeetingKeyExt];

    return [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
}


- (void)onGetResponse:(id)jsonObject
                error:(NSError *)error
{
    NSError *resultError = error;
    NSString *meetingRoomID;
    
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)jsonObject;
        NSInteger code = [dict jsonInteger:@"res"];
        resultError = code == 200 ? nil : [NSError errorWithDomain:@"ntes domain"
                                                              code:code
                                                          userInfo:nil];
        if (resultError == nil)
        {
            meetingRoomID = [dict jsonString:@"msg"];
        }
    }
    
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(error,meetingRoomID);
        });
    }
}

@end
