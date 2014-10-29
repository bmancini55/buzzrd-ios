//
//  InviteFriendsCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 10/28/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import "Room.h"

@interface InviteFriendsCommand : CommandBase

@property (strong, nonatomic) Room *room;

@property (strong, nonatomic) NSMutableDictionary *users;

@end
