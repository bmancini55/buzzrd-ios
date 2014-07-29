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

- (NSError *) handleError:(NSError *)error
           responseObject:(id)responseObject;
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if ([responseObject[@"error"][@"message"] isEqual: @"The username you entered already exists."]) {
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        [userInfo setObject:NSLocalizedString(@"Username Already In Use", nil) forKey:NSLocalizedDescriptionKey];
        [userInfo setObject:NSLocalizedString(@"The username you entered already exists.", nil) forKey:NSLocalizedRecoverySuggestionErrorKey];
        
        return [[NSError alloc] initWithDomain: error.domain
                                          code: error.code
                                      userInfo:userInfo];
    }
    
    return [super handleError:error responseObject:responseObject];
}

@end
