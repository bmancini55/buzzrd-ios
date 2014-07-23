//
//  DefaultTheme.m
//  Buzzrd
//
//  Created by Robert Beck on 6/4/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "DefaultTheme.h"

@implementation DefaultTheme

UIColor *primaryColorDark;
UIColor *primaryColorMedium;
UIColor *primaryColorLight;

UIColor *secondaryColorMedium;


-(DefaultTheme *) init
{
    self = [super init];
    
    primaryColorDark = [UIColor colorWithRed:97.0f/255.0f green:98.0f/255.0f blue:100.0f/255.0f alpha:1.0];

    primaryColorMedium = [UIColor colorWithRed:135.0f/255.0f green:137.0f/255.0f blue:139.0f/255.0f alpha:1.0];

    primaryColorLight = [UIColor colorWithRed:226/255.0f green:227/255.0f blue:228/255.0f alpha:1.0];
    
    secondaryColorMedium = [UIColor colorWithRed:250.0f/255.0f green:167.0f/255.0f blue:25.0f/255.0f alpha:1.0];
    
    [[UIButton appearance] setBackgroundColor: primaryColorMedium];
    [[UIButton appearance] setTitleColor: primaryColorDark forState: UIControlStateNormal];
    [[UIButton appearance] setTitleColor: primaryColorDark forState: UIControlStateSelected];
    [[UIButton appearanceWhenContainedIn:[UITableViewCell class], nil]
     setBackgroundColor: [UIColor whiteColor]];
    
    [[UITextField appearance] setBackgroundColor: [UIColor whiteColor]];
    [[UITextField appearance] setFont: [UIFont fontWithName:@"AvenirNext-Regular" size:17.0]];
    [[UITextField appearance] setTextColor: primaryColorDark];
    
    return self;
}

- (UIColor *) primaryColorDark {
    return primaryColorDark;
}

- (UIColor *) primaryColorMedium {
    return primaryColorMedium;
}

- (UIColor *) primaryColorLight {
    return primaryColorLight;
}

- (UIColor *) secondaryColorMedium {
    return secondaryColorMedium;
}

@end
