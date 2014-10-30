//
//  GetRoomCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetRoomCommand.h"
#import "Room.h"

@implementation GetRoomCommand


- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"GetRoomCommandComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    NSString *url = [self getAPIUrl:[NSString stringWithFormat:@"/api/rooms/%@", self.roomId]];
    [self httpGetWithManager:manager url:url parameters:nil parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSDictionary *dic = rawData[@"results"];
    Room* instance = [[Room alloc]initWithJson:dic];
    return instance;
}

@end
