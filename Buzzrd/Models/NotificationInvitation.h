//
//  NotificationInvitation.h
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"

@interface NotificationInvitation : Notification

@property (strong, readonly) NSString *senderId;

@property (strong, readonly) NSString *senderName;

@property (strong, readonly) NSString *roomId;

@property (strong, readonly) NSString *roomName;

@end
