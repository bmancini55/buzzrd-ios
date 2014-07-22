//
//  BaseTheme.h
//  Buzzrd
//
//  Created by Robert Beck on 6/4/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTheme : NSObject

@property (strong, nonatomic) UIColor *backgroundColor;

@property (strong, nonatomic) UIColor *primaryColor;

@property (strong, nonatomic) UIColor *secondaryColor;

@property (strong, nonatomic) UIColor *primaryOrangeColor;

-(BaseTheme *) init;

@end
