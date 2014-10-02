//
//  PrivacyPolicyViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 8/18/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "ThemeManager.h"
#import "GetPrivacyPolicyCommand.h"
#import "BuzzrdAPI.h"

@interface PrivacyPolicyViewController ()

@property (strong, nonatomic) UILabel *privacyPolicyLbL;

@end

@implementation PrivacyPolicyViewController

-(void) loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    self.title = NSLocalizedString(@"Privacy Policy", nil);
    
    self.privacyPolicyLbL = [[UILabel alloc] init];
    self.privacyPolicyLbL.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    self.privacyPolicyLbL.translatesAutoresizingMaskIntoConstraints = NO;
    self.privacyPolicyLbL.textColor = [ThemeManager getPrimaryColorDark];
    self.privacyPolicyLbL.numberOfLines = 0;
    [self.view addSubview:self.privacyPolicyLbL];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[privacyPolicyLbL]-20-|"  options:NSLayoutFormatAlignAllBaseline  metrics:nil  views:@{ @"privacyPolicyLbL" : self.privacyPolicyLbL }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-85-[privacyPolicyLbL]" options:0 metrics:nil views:@{ @"privacyPolicyLbL" : self.privacyPolicyLbL }]];
    
    GetPrivacyPolicyCommand *command = [[GetPrivacyPolicyCommand alloc]init];
    
    [command listenForCompletion:self selector:@selector(getPrivacyPolicyDidComplete:)];
    
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)getPrivacyPolicyDidComplete:(NSNotification *)notif
{
    GetPrivacyPolicyCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        [self.privacyPolicyLbL setText:NSLocalizedString(command.results, nil)];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

@end
