//
//  GetPotentialFriendsCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 10/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetPotentialFriendsCommand.h"
#import "User.h"

@implementation GetPotentialFriendsCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getPotentialFriendsComplete";
        
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/me/findPotentialFriends"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[NSString emptyStringIfNil:self.search] forKey:@"search"];
    
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
    return [NSArray arrayWithArray:temp];
}

@end
