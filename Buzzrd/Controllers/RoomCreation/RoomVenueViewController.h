//
//  RoomVenueViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Venue.h"
#import "Room.h"

@interface RoomVenueViewController : BaseTableViewController <UISearchDisplayDelegate>

-(id)initWithCallback:(void (^)(Venue *venue))onVenueSelected;

@property (strong, nonatomic) void(^onVenueSelected)(Venue *venue);

@end
