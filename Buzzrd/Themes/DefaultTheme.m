//
//  DefaultTheme.m
//  Buzzrd
//
//  Created by Robert Beck on 6/4/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "DefaultTheme.h"

@implementation DefaultTheme

UIColor *primaryColor;
UIColor *secondaryColor;
UIColor *primaryOrangeColor;

-(DefaultTheme *) init
{
    self = [super init];
    
    primaryColor = [UIColor colorWithRed:97.0f/255.0f green:98.0f/255.0f blue:100.0f/255.0f alpha:1.0];

    secondaryColor = [UIColor colorWithRed:135.0f/255.0f green:137.0f/255.0f blue:139.0f/255.0f alpha:1.0];
    
    primaryOrangeColor = [UIColor colorWithRed:250.0f/255.0f green:167.0f/255.0f blue:25.0f/255.0f alpha:1.0];
    
    [[UIButton appearance] setBackgroundColor: secondaryColor];
    [[UIButton appearance] setTitleColor: primaryColor forState: UIControlStateNormal];
    [[UIButton appearance] setTitleColor: primaryColor forState: UIControlStateSelected];
    [[UIButton appearanceWhenContainedIn:[UITableViewCell class], nil]
     setBackgroundColor: [UIColor whiteColor]];
    
    [[UITextField appearance] setBackgroundColor: [UIColor whiteColor]];
    [[UITextField appearance] setFont: [UIFont fontWithName:@"AvenirNext-Regular" size:17.0]];
    [[UITextField appearance] setTextColor: primaryColor];
    
    return self;
}

- (UIColor *) backgroundColor {
    return primaryColor;
}

- (UIColor *) primaryColor {
    return primaryColor;
}

- (UIColor *) primaryOrangeColor {
    return primaryOrangeColor;
}

@end
