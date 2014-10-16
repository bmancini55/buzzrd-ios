//
//  CreateFriendCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 10/7/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import "User.h"

@interface CreateFriendCommand : CommandBase

@property (strong, nonatomic) User *user;

@end
