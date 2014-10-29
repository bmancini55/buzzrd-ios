//
//  InviteFriendsCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 10/28/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "InviteFriendsCommand.h"
#import "NSObject+Helpers.h"
#import "User.h"
#import "NSMutableDictionary+Helpers.h"

@implementation InviteFriendsCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"inviteFriendsComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/rooms/inviteFriends/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.room.id forKey:@"roomId"];
    [parameters setObject:[self.users toJson] forKey:@"users"];
    
    [self httpPostWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSDictionary *results = rawData[@"results"];
    
    return results;
}

- (id) copyWithZone:(NSZone *)zone {
    InviteFriendsCommand *newOp = [super copyWithZone:zone];
    newOp.room = self.room;
    newOp.users = self.users;
    return newOp;
}

@end
