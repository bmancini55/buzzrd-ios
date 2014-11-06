//
//  NotificationUnreadMessages.m
//  Buzzrd
//
//  Created by Robert Beck on 11/5/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NotificationUnreadMessages.h"

@implementation NotificationUnreadMessages

- (NSString *) roomId{
    
    return self.payload[@"roomId"];
}

- (NSString *) roomName{
    
    return self.payload[@"roomName"];
}

@end
