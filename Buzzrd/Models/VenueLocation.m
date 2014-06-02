//
//  VenueLocation.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueLocation.h"

@implementation VenueLocation

-(id) initWithJson:(NSDictionary *)json
{
    self = [self init];
    if(self) {
        self.countryCode = json[@"cc"];
        self.city = json[@"city"];
        self.country = json[@"country"];
        
        double lat = [json[@"lat"] doubleValue];
        double lng = [json[@"lng"] doubleValue];
        self.coord = CLLocationCoordinate2DMake(lat, lng);
        
        self.state = json[@"state"];
    }
    return self;
}

@end
