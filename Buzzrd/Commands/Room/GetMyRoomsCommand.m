//
//  GetMyRoomsCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 9/17/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetMyRoomsCommand.h"

@implementation GetMyRoomsCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getMyRoomsComplete";
        self.showActivityIndicator = false;
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/me/rooms"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
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
