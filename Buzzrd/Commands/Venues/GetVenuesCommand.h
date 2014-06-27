//
//  GetVenuesCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import <CoreLocation/CoreLocation.h>
#import "Venue.h"

@interface GetVenuesCommand : CommandBase

@property (nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) NSString *search;
@property (nonatomic) bool includeRooms;

@end
