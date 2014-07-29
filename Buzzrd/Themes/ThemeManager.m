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

+ (UIColor *) getPrimaryColorMediumLight {
    return currentTheme.primaryColorMediumLight;
}

+ (UIColor *) getPrimaryColorLight {
    return currentTheme.primaryColorLight;
}

+ (UIColor *) getSecondaryColorMedium {
    return currentTheme.secondaryColorMedium;
}

+ (UIColor *) getTertiaryColorDark {
    return currentTheme.tertiaryColorDark;
}

+ (UIFont *) getPrimaryFontRegular:(float) fontSize {
    return [UIFont fontWithName:currentTheme.primaryFontRegular size:fontSize];
}

+ (UIFont *) getPrimaryFontMedium:(float) fontSize {
    return [UIFont fontWithName:currentTheme.primaryFontMedium size:fontSize];
}

+ (UIFont *) getPrimaryFontBold:(float) fontSize {
    return [UIFont fontWithName:currentTheme.primaryFontBold size:fontSize];
}

+ (UIFont *) getPrimaryFontDemiBold:(float) fontSize {
    return [UIFont fontWithName:currentTheme.primaryFontDemiBold size:fontSize];
}

@end
