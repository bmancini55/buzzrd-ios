//
//  LoginCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 6/30/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"

@interface LoginCommand : CommandBase

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@end
