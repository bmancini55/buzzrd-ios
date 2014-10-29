//
//  GetCurrentUserCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 6/30/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetCurrentUserCommand.h"

@implementation GetCurrentUserCommand

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
    
    NSString *url = [self getAPIUrl:@"/api/me"];
    
    [self httpGetWithManager:manager url:url parameters:nil parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    User* instance = [[User alloc]initWithJson:rawData[@"results"]];
    
    return instance;
}

@end
