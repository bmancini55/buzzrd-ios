//
//  CreateRoomCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 7/10/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import "Room.h"
#import "Venue.h"

@interface CreateRoomCommand : CommandBase

@property (strong, nonatomic) Room *room;

@end
