//
//  RemoveFriendCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 10/16/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import "User.h"

@interface RemoveFriendCommand : CommandBase

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
