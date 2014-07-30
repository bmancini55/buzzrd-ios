//
//  Message.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "Message.h"
#import "DateUtils.h"

@implementation Message 

- (id)initWithJson:(NSDictionary *)json
{
    Message *message = [[Message alloc] init];
    message.idmessage = json[@"id"];
    message.message = [NSString stringWithFormat:@"%@", json[@"message"]];
    message.created = [DateUtils parseMongoDateString:json[@"created"]];
    message.revealed = [json[@"revealed"] boolValue];
    message.userId = [NSString stringWithFormat:@"%@", json[@"user"][@"id"]];
    message.userName = [NSString stringWithFormat:@"%@", json[@"user"][@"username"]];
    
    return message;
}

- (id)copyWithZone:(NSZone *)zone
{
    Message *message = [[[self class] allocWithZone:zone] init];
    if(message)
    {
        [message setIdmessage:self.idmessage];
        [message setMessage:self.message];
        [message setCreated:self.created];
    }
    return message;
}

@end
