//
//  VenueLocation.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface VenueLocation : NSObject

@property (strong,nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *state;


-(id) initWithJson:(NSDictionary *)json;

@end
