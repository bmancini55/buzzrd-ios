//
//  Notification.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "Notification.h"
#import "DateUtils.h"

@implementation Notification

-(id) initWithJson:(NSDictionary *)json
{
    self = [self init];
    if(self) {
        self.id = json[@"id"];
        self.typeId = [NSNumber numberWithInt:[json[@"typeId"] intValue]];
        self.recipientId = json[@"recipientId"];
        self.message = json[@"message"];
        self.created = [DateUtils parseMongoDateString:json[@"created"]];
        self.read = [json[@"read"] boolValue];
        self.badgeCount = [json[@"badgeCount"] unsignedIntValue];
        self.payload = json[@"payload"];
    }
    
    return self;
}

@end
