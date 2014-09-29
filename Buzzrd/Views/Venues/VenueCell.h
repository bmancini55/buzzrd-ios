//
//  VenueCell.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Room.h"

@interface VenueCell : UITableViewCell

@property (strong, nonatomic) Venue *venue;

- (void)setVenue:(Venue *)venue userLocation:(CLLocation *)userLocation;

@end
