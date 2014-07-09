//
//  ServiceBase.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "ServiceBase.h"
#import "BuzzrdAPI.h"

@implementation ServiceBase

+ (NSDate *) parseMongoDateString:(NSString *)dateString
{
    return [DateUtils stringToLocalDate:dateString dateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
}

- (id) init
{
    self = [super init];
    if(self) {
//        self.apiURLBase = @"http://devapi.buzzrd.io:5050";
        self.apiURLBase = @"http://localhost:5050";
    }
    return self;
}

- (AFHTTPSessionManager *) getJSONRequestManager
{
    // create new manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // set authorization header
    if([[BuzzrdAPI current] authorization] != nil)
    {
        NSString *authorization = [@"Bearer " stringByAppendingString:[BuzzrdAPI current].authorization.bearerToken];
        [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    
    return manager;
}

@end
