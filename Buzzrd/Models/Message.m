//
//  Message.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "Message.h"

@implementation Message 

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
