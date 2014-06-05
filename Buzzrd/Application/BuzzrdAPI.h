//
//  BuzzrdAPI.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserService.h"
#import "RoomService.h"
#import "LocationService.h"
#import "MessageService.h"
#import "VenueService.h"
#import "ImageService.h"

#import "Authorization.h"
#import "User.h"

@interface BuzzrdAPI : NSObject

+(BuzzrdAPI *) current;

// Service Properties
@property (strong, nonatomic) UserService *userService;
@property (strong, nonatomic) RoomService *roomService;
@property (strong, nonatomic) MessageService *messageService;
@property (strong, nonatomic) VenueService *venueService;
@property (strong, nonatomic) ImageService *imageService;

// Data Properties
@property (strong, nonatomic) Authorization *authorization;
@property (strong, nonatomic) User *user;

@end
