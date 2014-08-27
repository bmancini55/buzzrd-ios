//
//  GetVenueRoomsCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 8/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetVenueRoomsCommand.h"

@implementation GetVenueRoomsCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getVenueRoomsComplete";
        self.showActivityIndicator = false;
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:[NSString stringWithFormat:@"/api/venues/%@/rooms", self.venue.id]];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[NSNumber numberWithUnsignedInteger:self.page] forKey:@"page"];
    [parameters setValue:[NSNumber numberWithUnsignedInteger:self.pagesize ] forKey:@"pagesize"];

    [self httpGetWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in rawData[@"results"])
    {
        Room* instance = [[Room alloc]initWithJson:dic];
        [temp addObject:instance];
    }
    return [NSArray arrayWithArray:temp];
}

- (id) copyWithZone:(NSZone *)zone {
    GetVenueRoomsCommand *newOp = [super copyWithZone:zone];
    newOp.venue = self.venue;
    return newOp;
}

@end
