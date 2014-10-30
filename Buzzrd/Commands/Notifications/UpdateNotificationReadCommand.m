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
    
    NSString *url = [self getAPIUrl:@"/api/me/notifications/updateNotificationRead"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.notification.id forKey:@"notificationId"];
    [parameters setValue:[NSNumber numberWithBool:self.notification.read] forKey:@"read"];
    
    [self httpPutWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
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
