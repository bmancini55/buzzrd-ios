//
//  UpdateProfilePicCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 7/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"

@interface UpdateProfilePicCommand : CommandBase

@property (strong, nonatomic) NSString *iduser;
@property (strong, nonatomic) NSString *imageURI;

@end
