//
//  TermsOfServiceViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 8/18/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "TermsOfServiceViewController.h"
#import "ThemeManager.h"

@interface TermsOfServiceViewController ()

@end

@implementation TermsOfServiceViewController

-(void) loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    self.title = NSLocalizedString(@"Buzzrd Terms", nil);
    
    UILabel *buzzrdTermsLbL = [[UILabel alloc] init];
    [buzzrdTermsLbL setText:NSLocalizedString(@"Some terms that we have to create that should be fairly long and wrap multiple lines.", nil)];
    buzzrdTermsLbL.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    buzzrdTermsLbL.translatesAutoresizingMaskIntoConstraints = NO;
    buzzrdTermsLbL.textColor = [ThemeManager getPrimaryColorDark];
    buzzrdTermsLbL.numberOfLines = 0;
    [self.view addSubview:buzzrdTermsLbL];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[buzzrdTermsLbL]-20-|"  options:NSLayoutFormatAlignAllBaseline  metrics:nil  views:@{ @"buzzrdTermsLbL" : buzzrdTermsLbL }]];
        
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-85-[buzzrdTermsLbL]" options:0 metrics:nil views:@{ @"buzzrdTermsLbL" : buzzrdTermsLbL }]];
}

@end
