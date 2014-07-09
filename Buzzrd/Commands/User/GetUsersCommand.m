//
//  GetUsersCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 7/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetUsersCommand.h"
#import "User.h"

@implementation GetUsersCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getUsersComplete";
        
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/users/"];
    
    [self httpGetWithManager:manager url:url parameters:nil parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in rawData[@"results"])
    {
        User* instance = [[User alloc]initWithJson:dic];
        [temp addObject:instance];
    }
    return [NSArray arrayWithArray:temp];
}

@end
