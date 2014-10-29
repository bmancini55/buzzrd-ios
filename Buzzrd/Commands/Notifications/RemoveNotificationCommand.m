//
//  RemoveNotificationCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RemoveNotificationCommand.h"

@implementation RemoveNotificationCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"removeNotficationComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/me/removeNotification/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.notification.id forKey:@"notificationId"];
    
    [self httpPostWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSDictionary *results = rawData[@"results"];
    
    return results;
}

- (id) copyWithZone:(NSZone *)zone {
    RemoveNotificationCommand *newOp = [super copyWithZone:zone];
    newOp.notification = self.notification;
    return newOp;
}


@end
