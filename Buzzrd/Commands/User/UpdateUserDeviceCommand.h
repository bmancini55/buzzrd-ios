//
//  UpdateUserDeviceCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 10/19/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"

@interface UpdateUserDeviceCommand : CommandBase

@property (strong, nonatomic) NSData *deviceToken;

@end
