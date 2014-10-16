//
//  CreateFriendCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 10/7/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CreateFriendCommand.h"

@implementation CreateFriendCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"createFriendComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/friends/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.user.iduser forKey:@"friendId"];
    
    [self httpPostWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSDictionary *results = rawData[@"results"];
    
    return results;
}

- (id) copyWithZone:(NSZone *)zone {
    CreateFriendCommand *newOp = [super copyWithZone:zone];
    newOp.user = self.user;
    return newOp;
}

@end
