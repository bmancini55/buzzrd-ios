//
//  BuzzrdAPI.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandDispatcher.h"
#import "Authorization.h"
#import "User.h"
#import "BZLocationManager.h"
#import "BuzzrdConfig.h"

@interface BuzzrdAPI : NSObject

+ (BuzzrdAPI *) current;
+ (CommandDispatcher *) dispatch;
+ (NSString *) apiURLBase;

- (void) clearLocalStorage;
- (void) checkForUnreadNotifications;
- (void) updateBadgeCount:(uint)badgeCount;
- (void) updateBadgeCountWithArray:(NSArray *)notifications;
- (void) decrementBadgeCount:(uint)amount;

- (bool) isAuthenticated;

// Configuration
@property (strong, nonatomic) BuzzrdConfig *config;

// Command Dispatch Pattern
@property (strong, nonatomic) CommandDispatcher *dispatch;

// Data Properties
@property (strong, nonatomic) Authorization *authorization;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIImage *profilePic;

// Additional Properties
@property (strong, nonatomic) NSData *deviceToken;

@end
