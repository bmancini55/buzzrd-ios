//
//  NewUserViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "JoinBuzzrdViewController.h"

@interface JoinBuzzrdViewController ()

@end

@implementation JoinBuzzrdViewController

-(void) loadView
{
    [super loadView];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    mainView = [[JoinBuzzrdView alloc] initWithFrame:CGRectMake(0, 0, 320, 468)];
    [self.view addSubview:mainView];
    
    [mainView.getStartedButton addTarget:self action:@selector(getStartedButton_click) forControlEvents:UIControlEventTouchUpInside];
}

-(void) cancelTouch
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) getStartedButton_click
{
    EnterUsernameViewController *enterUsernameViewController = [BuzzrdNav enterUsernameViewController];
    [self.navigationController pushViewController:enterUsernameViewController animated:YES];
}

@end
