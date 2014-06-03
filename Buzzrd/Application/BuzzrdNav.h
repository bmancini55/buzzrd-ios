//
//  BuzzrdNav.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "room.h"
#import "JoinBuzzrdViewController.h"
#import "OptionalInfoTableViewController.h"
#import "RequiredInfoTableViewController.h"
#import "ProfileImageViewController.h"

@interface BuzzrdNav : NSObject

+(UIViewController *) createLoginViewController;
+(UIViewController *) createHomeViewController;
+(UIViewController *) createRoomViewController:(Room *)room;
+(UIViewController *) createNewRoomViewController:(void (^)(Room *newRoom))roomCreatedCallback;

// Account Creation
+(JoinBuzzrdViewController *) joinBuzzrdViewController;
+(RequiredInfoTableViewController *) requiredInfoTableViewController;
+(OptionalInfoTableViewController *) optionalInfoTableViewController;
+(ProfileImageViewController *) profileImageViewController;

@end