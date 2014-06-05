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

+ (UIColor *) getBackgroundColor {
    return currentTheme.backgroundColor;
}

@end
