//
//  EnterUsernameViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/21/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "EnterUsernameViewController.h"
#import "CreatePasswordViewController.h"

@interface EnterUsernameViewController ()

@end

@implementation EnterUsernameViewController

-(void) loadView
{
    [super loadView];
    
    self.user = [[User alloc] init];
    
    mainView = [[EnterUsernameView alloc] initWithFrame:CGRectMake(0, 0, 320, 468)];
    [self.view addSubview:mainView];
    
    [mainView.continueButton addTarget:self action:@selector(continueButton_click) forControlEvents:UIControlEventTouchUpInside];
}

-(void) cancelTouch
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) continueButton_click
{
    // Check that the username is unique before moving forward
    
    CreatePasswordViewController *createPasswordViewController = [BuzzrdNav createPasswordViewController];
    createPasswordViewController.user = self.user;
    createPasswordViewController.user.username = mainView.usernameTextField.text;
    [self.navigationController pushViewController:createPasswordViewController animated:YES];
}

@end
