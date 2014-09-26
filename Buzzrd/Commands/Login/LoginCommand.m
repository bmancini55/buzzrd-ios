//
//  LoginCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 6/30/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "LoginCommand.h"
#import "Authorization.h"

@implementation LoginCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"loginComplete";
        
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *url = [self getAPIUrl:@"/oauth/grant/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"password" forKey:@"grant_type"];
    [parameters setObject:self.username forKey:@"username"];
    [parameters setObject:self.password forKey:@"password"];
    
    NSString *authorizationString = @"Basic YTRjZTkzMmZiM2E2MjNmNDc4ZjUzZmExMTMxMjlmNzM6YjBhZGQxY2I4MmE5MzAyMDQ1MzQ1ZTdkOWNhYTEzODc5MjRmYmI1MTZhODZjZjk3MGYyNGIyM2MyYzQ0OGQyNWNmZDU3YTRjNGIwMzc4MDdjOGJiOTMwMjgyNGY0NzI3NzMzYTI1Yzc3YmRiYzVhYWFjNTZmM2ZkY2U3OWU5MTA=";
    
    [manager.requestSerializer setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    
    
    [self httpPostWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    Authorization *authorization = [[Authorization alloc]initWithBearerToken: rawData[@"access_token"]];
    
    return authorization;
}

- (NSError *) handleError:(NSError *)error
           responseObject:(id)responseObject;
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if ([responseObject[@"error"] isEqual: @"invalid_grant"]) {
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        [userInfo setObject:NSLocalizedString(@"Invalid credentials", nil) forKey:NSLocalizedDescriptionKey];
        [userInfo setObject:NSLocalizedString(@"Check your username and password and try again", nil) forKey:NSLocalizedRecoverySuggestionErrorKey];
        
        self.allowRetry = false;
        
        return [[NSError alloc] initWithDomain: error.domain
                                          code: error.code
                                      userInfo:userInfo];
    }
    
    return [super handleError:error responseObject:responseObject];
}

- (id) copyWithZone:(NSZone *)zone {
    LoginCommand *newOp = [super copyWithZone:zone];
    newOp.username = self.username;
    newOp.password = self.password;
    newOp.allowRetry = self.allowRetry;
    return newOp;
}

@end
