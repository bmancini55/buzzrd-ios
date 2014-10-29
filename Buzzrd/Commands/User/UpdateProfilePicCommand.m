//
//  UpdateProfilePicCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 7/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UpdateProfilePicCommand.h"

@implementation UpdateProfilePicCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"updateProfilePicComplete";
        
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:@"/api/me/pic"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.imageURI forKey:@"profilePic"];
    
    [self httpPutWithManager:manager url:url parameters:parameters parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    return rawData[@"results"];
}

- (id) copyWithZone:(NSZone *)zone {
    UpdateProfilePicCommand *newOp = [super copyWithZone:zone];
    newOp.iduser = self.iduser;
    newOp.imageURI = self.imageURI;
    return newOp;
}

@end
