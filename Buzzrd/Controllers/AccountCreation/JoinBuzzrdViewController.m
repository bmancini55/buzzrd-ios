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

@property (strong, nonatomic) UILabel *joinBuzzrdLbl;
@property (strong, nonatomic) UILabel *createAccountSummaryLbl;
@property (strong, nonatomic) UILabel *createAccountDetailsLbl;
@property (strong, nonatomic) UIButton *getStartedButton;

@end

@implementation JoinBuzzrdViewController

-(void) loadView
{
    [super loadView];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    self.joinBuzzrdLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,100,self.view.frame.size.width,20)];
    [self.joinBuzzrdLbl setText:NSLocalizedString(@"join_buzzrd", nil)];
    self.joinBuzzrdLbl.textAlignment = NSTextAlignmentCenter;
    self.joinBuzzrdLbl.font = [UIFont boldSystemFontOfSize:17.0];
    [self.view addSubview:self.joinBuzzrdLbl];
    
    self.createAccountSummaryLbl = [ [UILabel alloc] initWithFrame:CGRectMake(0,130,self.view.frame.size.width,20)];
    [self.createAccountSummaryLbl setText:NSLocalizedString(@"join_buzzrd_summary", nil)];
    self.createAccountSummaryLbl.textAlignment = NSTextAlignmentCenter;
    self.createAccountSummaryLbl.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:self.createAccountSummaryLbl];
    
    self.createAccountDetailsLbl = [ [UILabel alloc] initWithFrame:CGRectMake(20.0,145,(self.view.frame.size.width-40.0),90)];
    [self.createAccountDetailsLbl setText:NSLocalizedString(@"join_buzzrd_detail", nil)];
    self.createAccountDetailsLbl.textAlignment = NSTextAlignmentCenter;
    self.createAccountDetailsLbl.font = [UIFont systemFontOfSize:12.0];
    self.createAccountDetailsLbl.numberOfLines = 0;
    [self.view addSubview:self.createAccountDetailsLbl];
    
    self.getStartedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.getStartedButton.frame = CGRectMake(80, 235, 160, 40);
    [self.getStartedButton setTitle:NSLocalizedString(@"get_started", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.getStartedButton];
    
    [self.getStartedButton addTarget:self action:@selector(getStartedTouch) forControlEvents:UIControlEventTouchUpInside];
}

-(void) cancelTouch
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) getStartedTouch
{
    CreateAccountTableViewController *createAccountTableViewController = [BuzzrdNav createAccountTableViewController];
    [self.navigationController pushViewController:createAccountTableViewController animated:YES];
}

@end
