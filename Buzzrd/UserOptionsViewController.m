//
//  UserOptionsViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "UserOptionsViewController.h"

@interface UserOptionsViewController ()

@end

@implementation UserOptionsViewController

-(void)loadView
{
    [super loadView];
    
    self.title = @"Options";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutButton.backgroundColor = [UIColor orangeColor];
    logoutButton.frame = CGRectMake(80, 200, 160, 40);
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
}

-(void)logoutTouch
{
    // TODO Perform logout... then do...
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
