//
//  BuzzrdAPI.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CommandDispatcher.h"
#import "Authorization.h"
#import "User.h"

@interface BuzzrdAPI : NSObject

+ (BuzzrdAPI *) current;
+ (CommandDispatcher *) dispatch;
+ (NSString *) apiURLBase;

- (void) clearAuthorization;
- (CLLocation *) currentLocation;

// Command Dispatch Pattern
@property (strong, nonatomic) CommandDispatcher *dispatch;

// Data Properties
@property (strong, nonatomic) Authorization *authorization;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIImage *profilePic;


// This should be refactored out when we refactor location stuff...
// For now, use it as a data cache for results from the command objects
@property (strong, nonatomic) CLLocation *lastLocation;


@end
