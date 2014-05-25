//
//  CreatePasswordViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "CreatePasswordViewController.h"
#import "OptionalInfoViewController.h"

@interface CreatePasswordViewController ()

@end

@implementation CreatePasswordViewController

-(void) loadView
{
    [super loadView];
    
    mainView = [[CreatePasswordView alloc] initWithFrame:CGRectMake(0, 0, 320, 468)];
    [self.view addSubview:mainView];
    
    [mainView.continueButton addTarget:self action:@selector(continueButton_click) forControlEvents:UIControlEventTouchUpInside];
}

-(void) continueButton_click
{
    // Check that the password is valid before moving forward
    
    OptionalInfoViewController *optionalInfoViewController = [BuzzrdNav optionalInfoViewController];
    optionalInfoViewController.user = self.user;
    optionalInfoViewController.user.password = mainView.passwordTextField.text;
    [self.navigationController pushViewController:optionalInfoViewController animated:YES];
}

@end
