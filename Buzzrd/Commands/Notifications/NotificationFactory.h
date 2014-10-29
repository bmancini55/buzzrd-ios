//
//  NotificationFactory.h
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"

@interface NotificationFactory : Notification

- (Notification *) buildFromJson:(NSDictionary *)json;

@end
