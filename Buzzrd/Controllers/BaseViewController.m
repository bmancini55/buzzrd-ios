//
//  BaseViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/16/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation BaseViewController

-(void)loadView
{
    [super loadView];

    // defaults the back button to have no text
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.view setBackgroundColor: [ThemeManager getBackgroundColor]];
}

- (void) showActivityView {
    [self.view endEditing:YES];
    
    if (self.activityView==nil) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.activityView];
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.activityView.hidesWhenStopped = YES;
    }
    // Center
    CGFloat x = UIScreen.mainScreen.applicationFrame.size.width/2;
    CGFloat y = UIScreen.mainScreen.applicationFrame.size.height/2;
    // Offset. If tableView has been scrolled
    self.view.frame = CGRectMake(x, y, 0, 0);
    
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

- (void) hideActivityView {
    [self.activityView stopAnimating];
}


@end
