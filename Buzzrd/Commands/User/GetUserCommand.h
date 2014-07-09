//
//  GetUserCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 6/30/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"
#import "User.h"

@interface GetUserCommand : CommandBase

@property (strong, nonatomic) NSString *username;

@end
