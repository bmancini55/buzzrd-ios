//
//  RoomCell.h
//  Buzzrd
//
//  Created by Brian Mancini on 9/15/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import <CoreLocation/CoreLocation.h>


@interface RoomCell : UITableViewCell

@property (strong, nonatomic) Room* room;

- (CGFloat)calculateHeight;
- (void) setRoom:(Room *)room userLocation:(CLLocation *)userLocation;

@end
