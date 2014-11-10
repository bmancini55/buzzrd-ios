//
//  GetUnreadNotificationsCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetUnreadNotificationsCommand.h"
#import "Notification.h"
#import "NotificationFactory.h"

@implementation GetUnreadNotificationsCommand


- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"GetUnreadNotificationsCommandComplete";
        self.autoShowActivityIndicator = false;
        self.autoHideActivityIndicator = false;
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    NSString *url = [self getAPIUrl:@"/api/me/notifications/unread"];
    [self httpGetWithManager:manager url:url parameters:nil parser:@selector(parser:)];
}

- (id) parser:(id)rawData
{
    NotificationFactory *factory = [[NotificationFactory alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in rawData[@"results"])
    {
        Notification* instance = [factory buildFromJson:dic];
        [temp addObject:instance];
    }
    return temp;
}


@end
