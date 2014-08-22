//
//  VenueCell.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "VenueRoomTableDelegate.h"

@interface VenueCell : UITableViewCell

@property (nonatomic) bool showCounts;
@property (nonatomic) bool showSubrooms;

@property (strong, nonatomic) Venue *venue;
@property (weak, nonatomic) id<VenueRoomTableDelegate> roomTableDelegate;

- (CGFloat)calculateHeight;
- (void)setVenue:(Venue *)venue userLocation:(CLLocation *)userLocation;
- (void)addBorder;

@end
