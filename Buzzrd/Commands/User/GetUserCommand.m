//
//  GetUserCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 6/30/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetUserCommand.h"

@implementation GetUserCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getUserComplete";
        
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/user/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[NSString emptyStringIfNil:self.username] forKey:@"username"];
    
    [self httpGetWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    User* instance = [[User alloc]initWithJson:rawData[@"results"]];
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    GetUserCommand *newOp = [super copyWithZone:zone];
    newOp.username = self.username;
    return newOp;
}

@end
