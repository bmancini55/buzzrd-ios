//
//  ThemeManager.m
//  Buzzrd
//
//  Created by Robert Beck on 6/4/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "ThemeManager.h"
#import "DefaultTheme.h"

@implementation ThemeManager

BaseTheme *currentTheme;

+(void) setTheme:(ThemeStyle) theme
{
    switch (theme) {
        default:
            currentTheme = [DefaultTheme alloc];
    }
    
    [currentTheme init];
}

+ (UIColor *) getPrimaryColorDark {
    return currentTheme.primaryColorDark;
}

+ (UIColor *) getPrimaryColorMedium {
    return currentTheme.primaryColorMedium;
}

+ (UIColor *) getPrimaryColorLight {
    return currentTheme.primaryColorLight;
}

+ (UIColor *) getSecondaryColorMedium {
    return currentTheme.secondaryColorMedium;
}

@end
