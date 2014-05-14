//
//  RoomsTableViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Room.h"

@interface RoomsViewController : UITableViewController <CLLocationManagerDelegate>

@property NSArray *rooms;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

-(void)addRoomToTable:(Room *)room;
-(void)addRoomTouch;

@end
