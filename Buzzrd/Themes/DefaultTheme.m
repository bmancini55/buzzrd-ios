//
//  DefaultTheme.m
//  Buzzrd
//
//  Created by Robert Beck on 6/4/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "DefaultTheme.h"

@implementation DefaultTheme

UIColor *primaryGrayColor;
UIColor *primaryOrangeColor;

-(DefaultTheme *) init
{
    self = [super init];
    
    primaryGrayColor = [UIColor colorWithRed:97.0f/255.0f green:98.0f/255.0f blue:100.0f/255.0f alpha:1.0];
    
    primaryOrangeColor = [UIColor colorWithRed:250.0f/255.0f green:167.0f/255.0f blue:25.0f/255.0f alpha:1.0];
    
    [[UIButton appearance] setBackgroundColor: primaryOrangeColor];
    [[UIButton appearance] setTitleColor: primaryGrayColor forState: UIControlStateNormal];
    [[UIButton appearance] setTitleColor: primaryGrayColor forState: UIControlStateSelected];
    
    [[UITextField appearance] setBackgroundColor: [UIColor whiteColor]];
    
    return self;
}

- (UIColor *) backgroundColor {
    return primaryGrayColor;
}

@end
