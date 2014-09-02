//
//  BaseTableViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/17/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

-(id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)loadView
{
    [super loadView];
    
    // defaults the back button to have no text
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (void) showRetryAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                  retryOperation:(NSOperation *)operation
{
    self.retryAlert = [[RetryAlert alloc]init];
    self.retryAlert.title = title;
    self.retryAlert.message = message;
    self.retryAlert.operation = operation;
    [self.retryAlert show];
}

- (void) showDefaultRetryAlert:(NSOperation *)operation
{
    [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                          message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                   retryOperation:operation];
}

@end
