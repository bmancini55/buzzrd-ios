//
//  NearbyViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//


#import "BaseTableViewController.h"
#import "Venue.h"
#import "Room.h"

@interface NearbyViewController : BaseTableViewController

@property NSArray *venues;

-(void)addRoomToTable:(Room *)room;
-(void)addRoomTouch;

@end
