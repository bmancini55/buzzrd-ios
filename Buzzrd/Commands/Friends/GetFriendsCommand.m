//
//  GetFriendsCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 10/6/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetFriendsCommand.h"
#import "User.h"

@implementation GetFriendsCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getFriendsComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/me/friends"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    [self httpGetWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in rawData[@"results"])
    {
        User* instance = [[User alloc]initWithJson:dic];
        [temp addObject:instance];
    }
    return temp;
}

@end
