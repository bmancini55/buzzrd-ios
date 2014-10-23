//
//  RemoveRoomCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 10/22/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RemoveRoomCommand.h"

@implementation RemoveRoomCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"removeRoomComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/me/removeRoom/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.room.id forKey:@"roomId"];
    
    [self httpPostWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSDictionary *results = rawData[@"results"];
    
    return results;
}

- (id) copyWithZone:(NSZone *)zone {
    RemoveRoomCommand *newOp = [super copyWithZone:zone];
    newOp.room = self.room;
    return newOp;
}

@end
