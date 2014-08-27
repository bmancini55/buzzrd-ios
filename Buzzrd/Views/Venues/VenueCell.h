//
//  VenueCell.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "VenueCellDelegate.h"
#import "VenueRoomTableDelegate.h"

@interface VenueCell : UITableViewCell

@property (weak, nonatomic) id<VenueCellDelegate> delegate;
@property (weak, nonatomic) id<VenueRoomTableDelegate> roomTableDelegate;

@property (nonatomic) bool showCounts;
@property (nonatomic) bool showSubrooms;

@property (strong, nonatomic) Venue *venue;


- (CGFloat)calculateHeight;
- (void)setVenue:(Venue *)venue userLocation:(CLLocation *)userLocation;
- (void)addBorder;

@end
