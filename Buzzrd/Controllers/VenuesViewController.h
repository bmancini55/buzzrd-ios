//
//  VenuesViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BaseTableViewController.h"
#import "Venue.h"
#import "Room.h"

@interface VenuesViewController : BaseTableViewController <CLLocationManagerDelegate>

@property NSArray *venues;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

-(void)addRoomToTable:(Room *)room;
-(void)addRoomTouch;

@end
