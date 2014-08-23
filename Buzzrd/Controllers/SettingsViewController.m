//
//  SettingsViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "SettingsViewController.h"
#import "BuzzrdAPI.h"
#import "LogoutCommand.h"
#import "BuzzrdNav.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

-(void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"settings", nil);
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
    NSString *actionSheetTitle = NSLocalizedString(@"Logout Confirmation", nil);
    NSString *destructiveTitle = NSLocalizedString(@"Log Out", nil);
    NSString *cancelTitle = NSLocalizedString(@"cancel", nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles: nil, nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        LogoutCommand *command = [[LogoutCommand alloc]init];
        
        [command listenForCompletion:self selector:@selector(logoutDidComplete:)];
        
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

- (void)logoutDidComplete:(NSNotification *)notif
{
    LogoutCommand *command = notif.object;
    
    if(command.status == kSuccess)
    {
        [self performSelectorOnMainThread:@selector(popToRootView) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

-(void)popToRootView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
