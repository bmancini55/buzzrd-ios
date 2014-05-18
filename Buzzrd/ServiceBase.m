//
//  ServiceBase.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "ServiceBase.h"

@implementation ServiceBase

+ (NSDate *) parseMongoDateString:(NSString *)dateString
{
    return [DateUtils stringToLocalDate:dateString dateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
}

- (id) init
{
    self = [super init];
    if(self) {
        self.apiURLBase = @"http://derpturkey.listmill.com:5050";
    }
    return self;
}

- (AFHTTPSessionManager *) getJSONRequestManager
{
    // create new manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // set oauth tokens here
    //NSString *accessToken = [BuzzrdAPI instance].accessToken;
    //[manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"access_token"];
    
    return manager;
}

@end
