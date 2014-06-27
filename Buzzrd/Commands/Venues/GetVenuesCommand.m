//
//  GetVenuesCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetVenuesCommand.h"


@implementation GetVenuesCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getVenuesComplete";

    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/venues/"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[NSNumber numberWithFloat:self.location.latitude] forKey:@"lat"];
    [parameters setValue:[NSNumber numberWithFloat:self.location.longitude] forKey:@"lng"];
    [parameters setValue:[NSNumber numberWithBool:self.includeRooms] forKey:@"includeRooms"];
    [parameters setValue:[NSString emptyStringIfNil:self.search] forKey:@"search"];
    
    [self httpGetWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in rawData)
    {
        Venue* instance = [[Venue alloc]initWithJson:dic];
        [temp addObject:instance];
    }
    return [NSArray arrayWithArray:temp];
}

@end
