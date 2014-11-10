//
//  ResetRoomBadgeCountCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "ResetRoomBadgeCountCommand.h"

@implementation ResetRoomBadgeCountCommand


- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"ResetRoomBadgeCountCommand";
        self.autoShowActivityIndicator = false;
        self.autoHideActivityIndicator = false;
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    
    NSString *url = [self getAPIUrl:[NSString stringWithFormat:@"/api/me/rooms/%@/read", self.roomId]];
    
    [self httpPutWithManager:manager url:url parameters:nil parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NSNumber *badgeCount = rawData[@"results"];
    return badgeCount;
}

- (id) copyWithZone:(NSZone *)zone {
    ResetRoomBadgeCountCommand *newOp = [super copyWithZone:zone];
    newOp.roomId = self.roomId;
    return newOp;
}


@end
