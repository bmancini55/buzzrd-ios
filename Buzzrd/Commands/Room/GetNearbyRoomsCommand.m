//
//  GetNearbyRoomsCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 9/15/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetNearbyRoomsCommand.h"

@implementation GetNearbyRoomsCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getNearbyRoomsComplete";
        self.activityIndicatorText = NSLocalizedString(@"Loading", nil);
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/rooms/nearby"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[NSNumber numberWithFloat:self.location.latitude] forKey:@"lat"];
    [parameters setValue:[NSNumber numberWithFloat:self.location.longitude] forKey:@"lng"];
    [parameters setValue:[NSString emptyStringIfNil:self.search] forKey:@"search"];
    
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

@end
