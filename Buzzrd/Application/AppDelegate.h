//
//  BuzzrdAppDelegate.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/11/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetryAlert.h"
#import "CommandBase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) RetryAlert *retryAlert;

@property (strong, nonatomic) UIWindow *window;

- (void)initializeCommandDispatchListeners;

@end
