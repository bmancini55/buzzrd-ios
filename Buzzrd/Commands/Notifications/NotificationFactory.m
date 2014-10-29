//
//  NotificationFactory.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NotificationFactory.h"
#import "NotificationInvitation.h"
#import "NotificationType.h"

@implementation NotificationFactory

- (Notification *)buildFromJson:(NSDictionary *)json
{
    int typeId = [[json objectForKey:@"typeId"] intValue];
                  
    switch (typeId) {
        case 1:
            return [[NotificationInvitation alloc]initWithJson:json];
            break;
            
        default:
            return [[Notification alloc]initWithJson:json];
            break;
    }
    
    return self;
}

@end
