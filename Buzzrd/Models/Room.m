//
//  Room.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "Room.h"

@implementation Room : NSObject


-(id) initWithJson:(NSDictionary *)json
{
    self = [self init];
    if(self) {
        //self.created = // USE DATE UTIL
        self.id = json[@"id"];
        self.name = json[@"name"];
        //self.updated = // USE DATE UTIL
        self.venueDefault = [json[@"venueDefault"] boolValue];
        self.venueId = json[@"venueId"];
        
        self.userCount = [json[@"userCount"] unsignedIntegerValue];
        self.lurkerCount = [json[@"lurkerCount"] unsignedIntegerValue];
    }
    return self;
}



@end
