//
//  UpdateRoomNotificationCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 10/30/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"

@interface UpdateRoomNotificationCommand : CommandBase

@property (strong, nonatomic) NSString *roomId;
@property (nonatomic) bool notify;

@end
