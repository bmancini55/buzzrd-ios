//
//  BuzzrdAPI.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomService.h"
#import "LocationService.h"
#import "MessageService.h"

@interface BuzzrdAPI : NSObject

+(BuzzrdAPI *) current;

@property (strong, nonatomic) RoomService *roomService;
@property (strong, nonatomic) LocationService *locationService;
@property (strong, nonatomic) MessageService *messageService;

@end
