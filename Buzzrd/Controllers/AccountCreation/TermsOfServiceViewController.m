//
//  TermsOfServiceViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 8/18/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "TermsOfServiceViewController.h"
#import "ThemeManager.h"
#import "GetTermsOfServiceCommand.h"
#import "BuzzrdAPI.h"

@interface TermsOfServiceViewController ()

@property (strong, nonatomic) UILabel *buzzrdTermsLbL;

@end

@implementation TermsOfServiceViewController

-(void) loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    self.title = NSLocalizedString(@"Buzzrd Terms", nil);
    
    self.buzzrdTermsLbL = [[UILabel alloc] init];
    self.buzzrdTermsLbL.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    self.buzzrdTermsLbL.translatesAutoresizingMaskIntoConstraints = NO;
    self.buzzrdTermsLbL.textColor = [ThemeManager getPrimaryColorDark];
    self.buzzrdTermsLbL.numberOfLines = 0;
    [self.view addSubview:self.buzzrdTermsLbL];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[buzzrdTermsLbL]-20-|"  options:NSLayoutFormatAlignAllBaseline  metrics:nil  views:@{ @"buzzrdTermsLbL" : self.buzzrdTermsLbL }]];
        
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-85-[buzzrdTermsLbL]" options:0 metrics:nil views:@{ @"buzzrdTermsLbL" : self.buzzrdTermsLbL }]];
    
    GetTermsOfServiceCommand *command = [[GetTermsOfServiceCommand alloc]init];
    
    [command listenForCompletion:self selector:@selector(getTermsOfServiceDidComplete:)];
    
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)getTermsOfServiceDidComplete:(NSNotification *)notif
{
    GetTermsOfServiceCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        [self.buzzrdTermsLbL setText:NSLocalizedString(command.results, nil)];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}


@end
