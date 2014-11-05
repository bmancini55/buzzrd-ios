//
//  NotificationInvitation.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NotificationInvitation.h"

@implementation NotificationInvitation

- (NSString *) senderId{
    
    return self.payload[@"senderId"];
}

- (NSString *) senderName{
    
    return self.payload[@"senderName"];
}

- (NSString *) roomId{
    
    return self.payload[@"roomId"];
}

- (NSString *) roomName{
    
    return self.payload[@"roomName"];
}

@end
