//
//  RoomService.h
//  FizBuz
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"

@interface RoomService : NSObject

+ (void)getRooms:(void (^)(NSArray *theRooms))callback;

+ (void)createRoom:(Room *)newRoom callback:(void (^)(Room *createdRoom))callback;

@end
