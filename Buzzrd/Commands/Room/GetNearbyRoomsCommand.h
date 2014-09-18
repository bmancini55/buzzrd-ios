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
#import "GetRoomsBaseCommand.h"

@interface GetNearbyRoomsCommand : GetRoomsBaseCommand

@property (nonatomic) CLLocationCoordinate2D location;

@end
