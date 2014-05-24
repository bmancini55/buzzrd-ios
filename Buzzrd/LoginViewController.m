//
//  LoginViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "LoginViewController.h"
#import "BuzzrdNav.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)loadView
{
    [super loadView];    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.backgroundColor = [UIColor orangeColor];
    loginButton.frame = CGRectMake(80, 200, 160, 40);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    createButton.backgroundColor = [UIColor orangeColor];
    createButton.frame = CGRectMake(80, 280, 160, 40);
    [createButton setTitle:@"Create" forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createButton];
}

- (void)loginTouch
{
    // TODO actual login... on callback do...
    UIViewController *homeController = [BuzzrdNav createHomeViewController];
    [self presentViewController:homeController animated:true completion:nil];
}

- (void)createTouch
{
    UIViewController *createController = [BuzzrdNav joinBuzzrdViewController];
    [self presentViewController:createController animated:true completion:nil];
}



@end
