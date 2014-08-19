//
//  PrivacyPolicyViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 8/18/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "ThemeManager.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

-(void) loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    UILabel *privacyPolicyTitleLbL = [[UILabel alloc] init];
    [privacyPolicyTitleLbL setText:NSLocalizedString(@"PRIVACY POLICY", nil)];
    privacyPolicyTitleLbL.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17.0];
    privacyPolicyTitleLbL.translatesAutoresizingMaskIntoConstraints = NO;
    privacyPolicyTitleLbL.textColor = [ThemeManager getPrimaryColorDark];
    privacyPolicyTitleLbL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:privacyPolicyTitleLbL];
    
    UILabel *privacyPolicyLbL = [[UILabel alloc] init];
    [privacyPolicyLbL setText:NSLocalizedString(@"Some terms that we have to create that should be fairly long and wrap multiple lines.", nil)];
    privacyPolicyLbL.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    privacyPolicyLbL.translatesAutoresizingMaskIntoConstraints = NO;
    privacyPolicyLbL.textColor = [ThemeManager getPrimaryColorDark];
    privacyPolicyLbL.numberOfLines = 0;
    [self.view addSubview:privacyPolicyLbL];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[privacyPolicyTitleLbL]-20-|"  options:NSLayoutFormatAlignAllBaseline  metrics:nil  views:@{ @"privacyPolicyTitleLbL" : privacyPolicyTitleLbL }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[privacyPolicyLbL]-20-|"  options:NSLayoutFormatAlignAllBaseline  metrics:nil  views:@{ @"privacyPolicyLbL" : privacyPolicyLbL }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-85-[privacyPolicyTitleLbL]-10-[privacyPolicyLbL]" options:0 metrics:nil views:@{ @"privacyPolicyTitleLbL" : privacyPolicyTitleLbL, @"privacyPolicyLbL" : privacyPolicyLbL }]];
}

@end
