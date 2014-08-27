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
#import "VenueCellDelegate.h"
#import "VenueRoomTableDelegate.h"

@interface NearbyViewController : BaseTableViewController <UIAlertViewDelegate, VenueCellDelegate, VenueRoomTableDelegate>

@end
