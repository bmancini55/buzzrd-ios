//
//  LogoutCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 7/7/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "LogoutCommand.h"

@implementation LogoutCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"logoutComplete";
        
    }
    return self;
}

- (void)main
{
    // Clear the local storage
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    
    self.status = kSuccess;
    [self sendCompletionNotification];
}

@end
