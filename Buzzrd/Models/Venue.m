//
//  Venue.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "Venue.h"

@implementation Venue

-(id) initWithJson:(NSDictionary *)json
{
    self = [self init];
    if(self) {
        
        self.id = json[@"id"];
        
        NSArray *rawCategories = json[@"categories"];
        NSMutableArray *tempCategories = [[NSMutableArray alloc]initWithCapacity:rawCategories.count];
        for(id rawCategory in rawCategories) {
            id tempCategory = [[VenueCategory alloc]initWithJson:rawCategory];
            [tempCategories addObject:tempCategory];
        }
        self.categories = [[NSArray alloc]initWithArray:tempCategories];
        
        //double lat = [json[@"lat"] doubleValue];
        //double lng = [json[@"lng"] doubleValue];
        //self.coord = CLLocationCoordinate2DMake(lat, lng);

        self.location = [[VenueLocation alloc]initWithJson:json[@"location"]];
        
        self.name = json[@"name"];
        self.referralId = json[@"referralId"];
        self.roomCount = [json[@"roomCount"] unsignedIntegerValue];
        self.userCount = [json[@"userCount"] unsignedIntegerValue];
        self.lurkerCount = [json[@"lurkerCount"] unsignedIntegerValue];
        self.verified = [json[@"verified"] boolValue];
        
        NSArray *rawRooms = json[@"rooms"];
        NSMutableArray *tempRooms = [[NSMutableArray alloc]initWithCapacity:rawCategories.count];
        for(id rawRoom in rawRooms) {
            id room = [[Room alloc]initWithJson:rawRoom];
            [tempRooms addObject:room];
        }
        self.rooms = [[NSArray alloc]initWithArray:tempRooms];
        
    }
    return self;
}

@end
