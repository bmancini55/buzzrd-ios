//
//  VenueCategory.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueCategory.h"

@implementation VenueCategory

-(id) initWithJson:(NSDictionary *)json
{
    self = [self init];
    if(self) {
        self.id = json[@"id"];
        self.name = json[@"name"];
        self.pluralName = json[@"pluralName"];
        self.shortName = json[@"shortName"];
        self.iconPrefix = json[@"icon"][@"prefix"];
        self.iconSuffix = json[@"icon"][@"suffix"];
    }
    return self;
}

@end
