//
//  CreateUser.m
//  Buzzrd
//
//  Created by Robert Beck on 7/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CreateUserCommand.h"
#import "User.h"

@implementation CreateUserCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"createUserComplete";
        
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/users/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.user.username forKey:@"username"];
    [parameters setObject:self.user.password forKey:@"password"];
    [parameters setObject:self.user.firstName forKey:@"firstName"];
    [parameters setObject:self.user.lastName forKey:@"lastName"];
    [parameters setObject:self.user.genderId forKey:@"sex"];
    
    [self httpPostWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    User* instance = [[User alloc]initWithJson:rawData[@"results"]];
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    CreateUserCommand *newOp = [super copyWithZone:zone];
    newOp.user = self.user;
    return newOp;
}

@end
