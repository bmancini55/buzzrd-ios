//
//  BuzzrdAPI.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomService.h"
#import "MessageService.h"

#import "CommandDispatcher.h"

#import "Authorization.h"
#import "User.h"

@interface BuzzrdAPI : NSObject

+ (BuzzrdAPI *) current;
+ (CommandDispatcher *) dispatch;

// Service Properties
@property (strong, nonatomic) RoomService *roomService;
@property (strong, nonatomic) MessageService *messageService;

// Command Dispatch Pattern
@property (strong, nonatomic) CommandDispatcher *dispatch;

// Data Properties
@property (strong, nonatomic) Authorization *authorization;
@property (strong, nonatomic) User *user;



@end
