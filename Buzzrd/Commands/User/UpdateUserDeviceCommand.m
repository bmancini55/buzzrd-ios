//
//  UpdateUserDeviceCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/19/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UpdateUserDeviceCommand.h"
#import "User.h"

@implementation UpdateUserDeviceCommand


- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"updateUserDeviceComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/me/device"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[self.deviceToken description] forKey:@"deviceId"];
    [self httpPutWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSString* token = rawData[@"results"];
    return token;
}

- (id) copyWithZone:(NSZone *)zone {
    UpdateUserDeviceCommand *newOp = [super copyWithZone:zone];
    newOp.deviceToken = self.deviceToken;
    return newOp;
}

@end
