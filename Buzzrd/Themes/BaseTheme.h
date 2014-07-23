//
//  BaseTheme.h
//  Buzzrd
//
//  Created by Robert Beck on 6/4/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTheme : NSObject

@property (strong, nonatomic) UIColor *primaryColorDark;

@property (strong, nonatomic) UIColor *primaryColorMedium;

@property (strong, nonatomic) UIColor *primaryColorLight;

@property (strong, nonatomic) UIColor *secondaryColorMedium;

-(BaseTheme *) init;

@end
