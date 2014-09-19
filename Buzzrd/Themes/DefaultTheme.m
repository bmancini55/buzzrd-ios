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
UIColor *primaryColorMediumLight;
UIColor *primaryColorLight;

UIColor *secondaryColorDark;
UIColor *secondaryColorMedium;
UIColor *secondaryColorLight;

UIColor *tertiaryColorDark;

NSString *primaryFontRegular;
NSString *primaryFontMedium;
NSString *primaryFontBold;
NSString *primaryFontDemiBold;

-(DefaultTheme *) init
{
    self = [super init];
    
    primaryColorDark = [UIColor colorWithRed:97.0f/255.0f green:98.0f/255.0f blue:100.0f/255.0f alpha:1.0];
    primaryColorMedium = [UIColor colorWithRed:135.0f/255.0f green:137.0f/255.0f blue:139.0f/255.0f alpha:1.0];
    primaryColorMediumLight = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:166.0f/255.0f alpha:1.0];
    primaryColorLight = [UIColor colorWithRed:226/255.0f green:227/255.0f blue:228/255.0f alpha:1.0];

    secondaryColorDark = [UIColor colorWithRed:245.0f/255.0f green:135.0f/255.0f blue:32.0f/255.0f alpha:1.0];
    secondaryColorMedium = [UIColor colorWithRed:250.0f/255.0f green:168.0f/255.0f blue:25.0f/255.0f alpha:1.0];
    secondaryColorLight = [UIColor colorWithRed:255.0f/255.0f green:207.0f/255.0f blue:116.0f/255.0f alpha:1.0];
    
    tertiaryColorDark = [UIColor colorWithRed:242.0f/255.0f green:114.0f/255.0f blue:78.0f/255.0f alpha:1.0];
    
    primaryFontRegular = @"AvenirNext-Regular";
    primaryFontMedium = @"AvenirNext-Medium";
    primaryFontBold = @"AvenirNext-Bold";
    primaryFontDemiBold = @"AvenirNext-DemiBold";

    // set text tint colors
    [[UITextField appearance] setBackgroundColor: [UIColor whiteColor]];
    [[UITextField appearance] setFont: [UIFont fontWithName:primaryFontRegular size:17.0]];
    [[UITextField appearance] setTextColor: primaryColorDark];
    [[UITextField appearance] setTintColor:tertiaryColorDark];
    
    // set navigation appearance for app
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
      primaryColorDark, NSForegroundColorAttributeName,
      [UIFont fontWithName:primaryFontRegular size:17.0], NSFontAttributeName,
      nil]];
    [[UINavigationBar appearance] setTintColor:tertiaryColorDark];
    
    // set searchbar appearance
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:@{ NSForegroundColorAttributeName:  primaryColorDark }
     forState:UIControlStateNormal];
    
    return self;
}

- (UIColor *) primaryColorDark {
    return primaryColorDark;
}

- (UIColor *) primaryColorMedium {
    return primaryColorMedium;
}

- (UIColor *) primaryColorMediumLight {
    return primaryColorMediumLight;
}

- (UIColor *) primaryColorLight {
    return primaryColorLight;
}

- (UIColor *) secondaryColorDark {
    return secondaryColorDark;
}

- (UIColor *) secondaryColorMedium {
    return secondaryColorMedium;
}

- (UIColor *) secondaryColorLight {
    return secondaryColorLight;
}

- (UIColor *) tertiaryColorDark {
    return tertiaryColorDark;
}

- (NSString *) primaryFontRegular {
    return primaryFontRegular;
}

- (NSString *) primaryFontMedium {
    return primaryFontMedium;
}

- (NSString *) primaryFontBold {
    return primaryFontBold;
}

- (NSString *) primaryFontDemiBold {
    return primaryFontDemiBold;
}
@end
