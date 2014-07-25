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

+ (UIColor *) getPrimaryColorDark;

+ (UIColor *) getPrimaryColorMedium;

+ (UIColor *) getPrimaryColorLight;

+ (UIColor *) getSecondaryColorMedium;

+(void) setTheme:(ThemeStyle) theme;

+ (UIFont *) getPrimaryFontRegular:(float) fontSize;

+ (UIFont *) getPrimaryFontBold:(float) fontSize;

+ (UIFont *) getPrimaryFontDemiBold:(float) fontSize;

@end
