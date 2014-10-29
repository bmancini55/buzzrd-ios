//
//  RootViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 10/2/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RootViewController.h"
#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidAppear:(BOOL)animated
{
    // Show the login view controller when not authenticated
    if ([BuzzrdAPI current].authorization.bearerToken == nil) {
        [self presentViewController:[BuzzrdNav createLoginViewController] animated:false completion:nil];
    }
    else {
        [[BuzzrdAPI current] registerForRemoteNotifications];
        [self presentViewController:[BuzzrdNav createHomeViewController] animated:false completion:nil];
    }
}

@end
