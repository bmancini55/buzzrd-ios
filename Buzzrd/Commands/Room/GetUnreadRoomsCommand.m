//
//  GetUnreadRoomsCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetUnreadRoomsCommand.h"
#import "Room.h"

@implementation GetUnreadRoomsCommand


- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"GetUnreadRoomsCommandComplete";
        self.autoShowActivityIndicator = false;
        self.autoHideActivityIndicator = false;
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    NSString *url = [self getAPIUrl:@"/api/me/unread"];
    [self httpGetWithManager:manager url:url parameters:nil parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in rawData[@"results"])
    {
        Room* instance = [[Room alloc]initWithJson:dic];
        [temp addObject:instance];
    }
    return temp;
}


@end
