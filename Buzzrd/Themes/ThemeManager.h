//
//  ThemeManager.h
//  Buzzrd
//
//  Created by Robert Beck on 6/4/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    defaultStyle
    
} ThemeStyle;

@interface ThemeManager : NSObject

+ (UIColor *) getBackgroundColor;

+ (UIColor *) getPrimaryColor;

+ (UIColor *) getSecondaryColor;

+ (UIColor *) getOrangeColor;

+(void) setTheme:(ThemeStyle) theme;

@end
