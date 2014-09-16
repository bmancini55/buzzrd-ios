//
//  GetNearbyRoomsCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 9/15/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import <CoreLocation/CoreLocation.h>
#import "Room.h"

@interface GetNearbyRoomsCommand : CommandBase

@property (nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) NSString *search;

@end
