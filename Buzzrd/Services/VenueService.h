//
//  VenueService.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ServiceBase.h"
#import "Venue.h"

@interface VenueService : ServiceBase

-(void)getVenues:(CLLocationCoordinate2D)location
                search:(NSString *)search
          includeRooms:(bool)includeRooms
               success:(void (^)(NSArray *theVenues))success
               failure:(void (^)(NSError *error))failure;

@end
