//
//  RemoveRoomCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 10/22/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import "Room.h"

@interface RemoveRoomCommand : CommandBase

@property (strong, nonatomic) Room *room;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
