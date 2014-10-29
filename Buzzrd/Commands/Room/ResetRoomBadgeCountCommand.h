//
//  ResetRoomBadgeCountCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"

@interface ResetRoomBadgeCountCommand : CommandBase

@property (strong, nonatomic) NSString *roomId;

@end
