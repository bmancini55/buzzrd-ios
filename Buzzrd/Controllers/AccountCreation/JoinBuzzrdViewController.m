//
//  NewUserViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "JoinBuzzrdViewController.h"
#import "ThemeManager.h"
#import "DisclaimerView.h"

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
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIImage *megaphoneImage = [UIImage imageNamed:@"Buzzrd_Megaphone.png"];
    
    UIImageView *megaphoneImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    megaphoneImageView.contentMode = UIViewContentModeScaleAspectFit;
    megaphoneImageView.translatesAutoresizingMaskIntoConstraints = NO;
    megaphoneImageView.image = megaphoneImage;
    [self.view addSubview:megaphoneImageView];
    
    self.joinBuzzrdLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,20)];
    [self.joinBuzzrdLbl setText:NSLocalizedString(@"join_buzzrd", nil)];
    self.joinBuzzrdLbl.textAlignment = NSTextAlignmentCenter;
    self.joinBuzzrdLbl.font = [UIFont fontWithName:@"AvenirNext-Bold" size:28.0];
    self.joinBuzzrdLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.joinBuzzrdLbl.textColor = [ThemeManager getSecondaryColorMedium];
    [self.view addSubview:self.joinBuzzrdLbl];
    
    self.createAccountSummaryLbl =  [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,20)];
    [self.createAccountSummaryLbl setText:NSLocalizedString(@"join_buzzrd_summary", nil)];
    self.createAccountSummaryLbl.textAlignment = NSTextAlignmentCenter;
    self.createAccountSummaryLbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0];
    self.createAccountSummaryLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.createAccountSummaryLbl.numberOfLines = 0;
    self.createAccountSummaryLbl.textColor = [ThemeManager getPrimaryColorDark];
    [self.view addSubview:self.createAccountSummaryLbl];
    
    self.getStartedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.getStartedButton setTitle: NSLocalizedString(@"get_started", nil) forState:UIControlStateNormal];
    self.getStartedButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.getStartedButton.backgroundColor = [ThemeManager getSecondaryColorMedium];
    self.getStartedButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0];
    [self.getStartedButton addTarget:self action:@selector(getStartedTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.getStartedButton setTitleColor:[ThemeManager getPrimaryColorLight] forState:UIControlStateNormal];
    self.getStartedButton.layer.cornerRadius = 5; // this value vary as per your desire
    [self.view addSubview:self.getStartedButton];
    
    
    UIView *disclaimerContainerView = [[UIView alloc] initWithFrame:CGRectMake(20,200,self.view.frame.size.width-40,90)];
    disclaimerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:disclaimerContainerView];
    
    UIView *disclaimerView = [[DisclaimerView alloc] initWithFrame:CGRectMake(0,0,disclaimerContainerView.frame.size.width,90)];
    [disclaimerContainerView addSubview:disclaimerView];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[megaphoneImageView]-40-|" options:0 metrics:nil views:@{ @"megaphoneImageView" : megaphoneImageView }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[getStartedButton]-20-|" options:0 metrics:nil views:@{ @"getStartedButton" : self.getStartedButton }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[createAccountSummaryLbl]-90-|" options:0 metrics:nil views:@{ @"createAccountSummaryLbl" : self.createAccountSummaryLbl }]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[disclaimerContainerView]-25-|" options:0 metrics:nil views:@{ @"disclaimerContainerView" :disclaimerContainerView }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-125-[megaphoneImageView]-3-[joinBuzzrdLbl]-0-[createAccountSummaryLbl]-70-[getStartedButton]-10-[disclaimerContainerView]-5-|" options:0 metrics:nil views:@{ @"megaphoneImageView" : megaphoneImageView, @"joinBuzzrdLbl" : self.joinBuzzrdLbl, @"createAccountSummaryLbl" : self.createAccountSummaryLbl, @"getStartedButton" : self.getStartedButton, @"disclaimerContainerView" : disclaimerContainerView }]];
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
