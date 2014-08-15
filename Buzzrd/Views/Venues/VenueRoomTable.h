//
//  VenueRoomTable.h
//  Buzzrd
//
//  Created by Brian Mancini on 8/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Room.h"

@interface VenueRoomTable : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) NSArray *rooms;

@end
