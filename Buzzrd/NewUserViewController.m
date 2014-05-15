//
//  NewUserViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "NewUserViewController.h"
#import "BuzzrdNav.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

-(void) loadView
{
    [super loadView];
    
    self.title = @"Create Account";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    createButton.backgroundColor = [UIColor orangeColor];
    createButton.frame = CGRectMake(80, 200, 160, 40);
    [createButton setTitle:@"Create" forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createButton];
}

-(void) cancelTouch
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) createTouch
{
    UIViewController *homeController = [BuzzrdNav createHomeViewController];
    [self presentViewController:homeController animated:true completion:nil];
}

@end
