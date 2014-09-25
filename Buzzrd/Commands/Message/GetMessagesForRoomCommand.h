//
//  GetMessagesForRoomCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 7/11/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import "Room.h"
#import "Message.h"

@interface GetMessagesForRoomCommand : CommandBase

@property (strong, nonatomic) Room *room;
@property (nonatomic) int page;
@property (strong, nonatomic) NSString *after;

@end
