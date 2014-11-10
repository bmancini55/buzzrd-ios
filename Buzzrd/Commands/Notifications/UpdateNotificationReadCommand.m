//
//  UpdateNotificationReadCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UpdateNotificationReadCommand.h"

@implementation UpdateNotificationReadCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"updateNotificationReadComplete";
        
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:[NSString stringWithFormat:@"/api/notifications/%@/read", self.notification.id]];
    
    [self httpPutWithManager:manager url:url parameters:nil parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    return rawData[@"results"];
}

- (id) copyWithZone:(NSZone *)zone {
    UpdateNotificationReadCommand *newOp = [super copyWithZone:zone];
    newOp.notification = self.notification;
    return newOp;
}

@end
