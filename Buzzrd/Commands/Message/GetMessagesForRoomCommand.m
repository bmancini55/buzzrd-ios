//
//  GetMessagesForRoomCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 7/11/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetMessagesForRoomCommand.h"
#import "NSString+string.h"

@implementation GetMessagesForRoomCommand


- (id)init
{
    self = [super init];
    if(self)
    {
        self.completionNotificationName = @"GetMessagesForRoomComplete";
        self.showActivityIndicator = false;
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self.apiURLBase stringByAppendingString:[NSString stringWithFormat:@"/api/rooms/%@/messages", self.room.id]];
    NSDictionary *params =
    @{
        @"page": [NSNumber numberWithInt:self.page],
        @"pagesize": [NSNumber numberWithInt:25],
        @"after": [NSString emptyStringIfNil:self.after]
    };
    

    [self httpGetWithManager:manager url:url parameters:params parser:@selector(parser:)];
}

- (id)parser:(id)rawData
{
    NSArray *results = rawData[@"results"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in results)
    {
        Message* message = [[Message alloc]initWithJson:dic];
        [temp addObject:message];
    }
    results = [[NSArray alloc]initWithArray:temp];
    return results;
}

- (id) copyWithZone:(NSZone *)zone {
    GetMessagesForRoomCommand *newOp = [super copyWithZone:zone];
    newOp.room = self.room;
    newOp.page = self.page;
    return newOp;
}

@end
