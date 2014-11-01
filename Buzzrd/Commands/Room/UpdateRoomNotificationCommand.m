//
//  UpdateRoomNotificationCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/30/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UpdateRoomNotificationCommand.h"
#import "NSString+string.h"

@implementation UpdateRoomNotificationCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = [@"UpdateRoomNotificationCountCommand-" stringByAppendingString:[NSString generateRandomString:12]];
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    NSString *url = [self getAPIUrl:[@"/api/me/rooms/" stringByAppendingString:self.roomId]];
    
    NSDictionary *parameters = @{ @"notify": [NSNumber numberWithBool:self.notify] };
    [self httpPutWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    return nil;
}

- (id) copyWithZone:(NSZone *)zone {
    UpdateRoomNotificationCommand *newOp = [super copyWithZone:zone];
    newOp.roomId = self.roomId;
    newOp.notify = self.notify;
    return newOp;
}

@end
