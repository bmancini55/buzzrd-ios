//
//  BuzzrdNav.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "room.h"

@interface BuzzrdNav : NSObject

+(UIViewController *) createLoginViewController;
+(UIViewController *) createNewUserViewController;
+(UIViewController *) createHomeViewController;
+(UIViewController *) createRoomViewController:(Room *)room;
+(UIViewController *) createNewRoomViewController:(void (^)(Room *newRoom))roomCreatedCallback;

@end
