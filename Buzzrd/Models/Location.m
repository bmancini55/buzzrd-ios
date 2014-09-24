//
//  Location.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "Location.h"

@implementation Location

-(id) initWithJson:(NSDictionary *)json
{
    self = [self init];
    if(self) {
        
        self.address = json[@"address"];
        self.city = json[@"city"];
        self.state = json[@"state"];
        
        self.countryCode = json[@"cc"];
        self.country = json[@"country"];
        
        double lat = [json[@"lat"] doubleValue];
        double lng = [json[@"lng"] doubleValue];
        self.location = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    }
    return self;
}

- (NSString *) prettyString
{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    
    if(self.address.length > 0) {
        [result appendString:self.address];
    }
    
    if(self.city.length > 0) {
        if(result.length > 0) {
           [result appendString:@", "];
        }
        [result appendString:self.city];
    }
    
    if(self.state.length > 0) {
        if(result.length > 0) {
            [result appendString:@", "];
        }
        [result appendString:self.state];
    }
    
    return [NSString stringWithString:result];
}

@end
