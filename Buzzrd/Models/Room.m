//
//  Room.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "Room.h"
#import "Venue.h"

@implementation Room : NSObject


-(id) initWithJson:(NSDictionary *)json
{
    self = [self init];
    if(self) {
        self.id = json[@"id"];
        self.name = json[@"name"];
        //self.created = // USE DATE UTIL
        //self.updated = // USE DATE UTIL
        
        self.userCount = [json[@"userCount"] unsignedIntegerValue];
        self.lurkerCount = [json[@"lurkerCount"] unsignedIntegerValue];
        self.messageCount = [json[@"messageCount"] unsignedIntegerValue];
        self.watchedRoom = [json[@"watchedRoom"] boolValue];
        self.newMessages = [json[@"newMessages"] boolValue];
        
        NSArray *coord = json[@"coord"];
        self.coord = [[CLLocation alloc]initWithLatitude:[coord[1] doubleValue] longitude:[coord[0] doubleValue]];
        self.location = [[Location alloc]initWithJson:json[@"location"]];

        self.venueId = json[@"venueId"];
        self.venueName = json[@"venueName"];
        

    }
    return self;
}



@end
