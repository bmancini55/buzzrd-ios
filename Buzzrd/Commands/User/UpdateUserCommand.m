//
//  UpdateUserCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 8/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UpdateUserCommand.h"

@implementation UpdateUserCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"updateUserComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/users/update/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.user.username forKey:@"username"];
    [parameters setObject:self.user.firstName forKey:@"firstName"];
    [parameters setObject:self.user.lastName forKey:@"lastName"];
    [parameters setObject:self.user.genderId forKey:@"sex"];
    
    if (self.user.password != nil) {
        [parameters setObject:self.user.password forKey:@"password"];
    }
    
    [self httpPostWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    User* instance = [[User alloc]initWithJson:rawData[@"results"]];
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    UpdateUserCommand *newOp = [super copyWithZone:zone];
    newOp.user = self.user;
    newOp.allowRetry = self.allowRetry;
    return newOp;
}

@end
