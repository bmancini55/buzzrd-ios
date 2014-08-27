//
//  GetVenueRoomsCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 8/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import "Venue.h"
#import "room.h"

@interface GetVenueRoomsCommand : CommandBase

@property (strong, nonatomic) Venue *venue;
@property (nonatomic) uint page;
@property (nonatomic) uint pagesize;

@end
