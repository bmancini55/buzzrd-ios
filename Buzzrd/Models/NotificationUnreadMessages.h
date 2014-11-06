//
//  NotificationUnreadMessages.h
//  Buzzrd
//
//  Created by Robert Beck on 11/5/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "Notification.h"

@interface NotificationUnreadMessages : Notification

@property (strong, readonly) NSString *roomId;

@property (strong, readonly) NSString *roomName;

@end